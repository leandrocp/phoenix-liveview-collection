defmodule LiveViewCollection.Github do
  require Logger

  def repo(github_url) do
    {_, _, _, user, repo} =
      github_url
      |> String.split("/")
      |> Enum.take(5)
      |> List.to_tuple()

    user_repo = user <> "/" <> repo

    Logger.info("#{github_url} => #{user_repo}")

    user_repo
  end
end
