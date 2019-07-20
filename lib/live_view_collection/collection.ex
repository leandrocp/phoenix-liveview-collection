defmodule LiveViewCollection.Collection do
  use Agent
  require Logger
  alias LiveViewCollection.Twitter
  alias LiveViewCollection.Github

  def start_link(_) do
    Agent.start_link(fn -> load_from_file() end, name: __MODULE__)
  end

  def all, do: Agent.get(__MODULE__, fn collection -> collection end)

  def filter(), do: all()
  def filter(query) when query == "" or is_nil(query), do: all()

  def filter(query) do
    {:ok, regex} = Regex.compile(query, "i")

    Agent.get(__MODULE__, fn collection ->
      Enum.filter(collection, fn %{"name" => name, "tweet_html" => tw_html} ->
        content = name <> " " <> tw_html
        String.match?(content, regex)
      end)
    end)
  end

  def load_from_file do
    {:ok, collection} =
      File.cwd!()
      |> Path.join("collection.yml")
      |> YamlElixir.read_from_file()

    collection
    |> resolve_tweets()
    |> resolve_repos()
  end

  defp resolve_tweets(collection) do
    resolve_item = fn %{"tweet_url" => tweet_url} = item ->
      %{"html" => html} = Twitter.tweet(tweet_url)
      Map.put(item, "tweet_html", html)
    end

    collection
    |> Enum.map(&Task.async(fn -> resolve_item.(&1) end))
    |> Enum.map(&Task.await/1)
  end

  defp resolve_repos(collection) do
    collection
    |> Enum.reject(fn %{"github_url" => github_url} -> is_nil(github_url) end)
    |> Enum.map(fn %{"github_url" => github_url} = item ->
      Map.put(item, "github_repo", Github.repo(github_url))
    end)
  end
end
