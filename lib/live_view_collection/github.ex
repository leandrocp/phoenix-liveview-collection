defmodule LiveViewCollection.Github do
  require Logger

  @spec repo(String.t() | nil) :: String.t() | nil
  def repo(_github_url = nil), do: nil
  def repo(_github_url = ""), do: nil

  def repo(github_url) when is_binary(github_url) do
    url =
      github_url
      |> String.split("/")
      |> Enum.take(5)
      |> List.to_tuple()

    user_repo =
      case url do
        {_, _, _, user, repo} ->
          user <> "/" <> repo

        {user, repo} ->
          user <> "/" <> repo

        _ ->
          nil
      end

    Logger.info("#{github_url} => #{user_repo}")
    user_repo
  end

  @spec url(String.t() | nil) :: String.t() | nil
  def url(_repo = nil), do: nil
  def url(_repo = ""), do: nil

  def url(repo) when is_binary(repo) do
    uri =
      repo
      |> String.split("/")
      |> Enum.take(2)
      |> List.to_tuple()

    case uri do
      {"https:", _} -> repo
      {user, repo} -> "https://github.com/#{user}/#{repo}"
      _ -> nil
    end
  end

  @spec resolve(list[map()]) :: list[map()]
  def resolve(collection) do
    collection
    |> Enum.map(fn
      nil ->
        :error

      %{"github_url" => github_url} = item ->
        gh = %{
          "github_url" => url(github_url),
          "github_repo" => repo(github_url)
        }

        Map.merge(item, gh)

      item ->
        gh = %{
          "github_url" => nil,
          "github_repo" => nil
        }

        Map.merge(item, gh)
    end)
    |> Enum.filter(&is_map(&1))
  end
end
