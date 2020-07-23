defmodule LiveViewCollection.Twitter do
  require Logger

  @spec tweet(String.t() | nil) :: map() | nil
  def tweet(_tweet_url = nil), do: nil
  def tweet(_tweet_url = ""), do: nil

  def tweet(tweet_url) do
    {:ok, %Mojito.Response{body: body, status_code: status_code}} =
      Mojito.request(
        method: :get,
        url:
          "https://publish.twitter.com/oembed?url=#{tweet_url}&omit_script=true&hide_thread=true"
      )

    Logger.info("#{tweet_url} => #{status_code}")

    body
    |> Jason.decode()
    |> case do
      {:ok, tweet} ->
        tweet

      {:error, _body} ->
        Logger.debug("^ error fetching this tweet ^")
        nil
    end
  end

  @spec id(String.t() | nil) :: String.t() | nil
  def id(_tweet_url = nil), do: nil
  def id(_tweet_url = ""), do: nil

  def id(tweet_url) when is_binary(tweet_url) do
    tweet_url
    |> String.split("/")
    |> List.last()
  end

  @spec resolve(list[map()]) :: list[map()]
  def resolve(collection) when is_list(collection) do
    resolve_item = fn
      %{"tweet_url" => tweet_url} = item ->
        case tweet(tweet_url) do
          nil ->
            nil

          tweet ->
            tweet = %{
              "tweet_id" => id(tweet_url),
              "tweet_html" => tweet["html"]
            }

            Map.merge(item, tweet)
        end

      _ ->
        nil
    end

    collection
    |> Enum.map(&Task.async(fn -> resolve_item.(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reject(&is_nil(&1))
  end
end
