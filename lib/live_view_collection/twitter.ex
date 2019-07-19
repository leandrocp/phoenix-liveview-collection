defmodule LiveViewCollection.Twitter do
  require Logger

  def tweet(tweet_url) do
    %HTTPotion.Response{body: body, status_code: status_code} = HTTPotion.get("https://publish.twitter.com/oembed?url=#{tweet_url}")

    Logger.info("#{tweet_url} => #{status_code}")

    Jason.decode!(body)
  end

  def embed_html(tweet_url) do
    tweet_url
    |> tweet()
    |> Map.fetch!("html")
    |> Floki.filter_out("script")
    |> Floki.raw_html()
  end
end
