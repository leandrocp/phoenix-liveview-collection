defmodule LiveViewCollection.Collection do
  use Agent
  require Logger
  alias LiveViewCollection.Twitter

  @collection [
    {"Flappy Bird clone", "https://twitter.com/moomerman/status/1111711999963086849"},
    {"Form with multiple steps and progression indicator",
     "https://twitter.com/_AlexGaribay/status/1111641314955849728"}
  ]

  def start_link(_) do
    Agent.start_link(fn -> resolve_tweets(@collection) end, name: __MODULE__)
  end

  def all, do: Agent.get(__MODULE__, fn collection -> collection end)

  def filter(), do: all()
  def filter(query) when query == "" or is_nil(query), do: all()

  def filter(query) do
    {:ok, regex} = Regex.compile(query, "i")

    Agent.get(__MODULE__, fn collection ->
      Enum.filter(collection, fn {name, _} -> String.match?(name, regex) end)
    end)
  end

  defp resolve_tweets(collection) do
    resolve_item = fn {name, tweet_url} ->
      Logger.info("Loading #{name}")
      # {name, tweet_url}
      {name, Twitter.embed_html(tweet_url)}
    end

    collection
    |> Enum.map(&(Task.async(fn -> resolve_item.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
