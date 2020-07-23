defmodule LiveViewCollection.GithubTest do
  use ExUnit.Case, async: true

  alias LiveViewCollection.Github

  test "repo" do
    assert Github.repo(nil) == nil
    assert Github.repo("") == nil
    assert Github.repo("phoenix_live_view_example") == nil

    assert Github.repo("https://github.com/chrismccord/phoenix_live_view_example") ==
             "chrismccord/phoenix_live_view_example"

    assert Github.repo("chrismccord/phoenix_live_view_example") ==
             "chrismccord/phoenix_live_view_example"
  end

  test "url" do
    assert Github.url(nil) == nil
    assert Github.url("") == nil
    assert Github.url("phoenix_live_view_example") == nil

    assert Github.url("https://github.com/chrismccord/phoenix_live_view_example") ==
             "https://github.com/chrismccord/phoenix_live_view_example"

    assert Github.url("chrismccord/phoenix_live_view_example") ==
             "https://github.com/chrismccord/phoenix_live_view_example"
  end

  test "resolve" do
    assert [a, b, c, d] =
             Github.resolve([
               %{
                 "name" => "Chris McCord examples",
                 "tweet_url" => "https://twitter.com/chris_mccord/status/1106291353670045696",
                 "github_url" => "https://github.com/chrismccord/phoenix_live_view_example"
               },
               %{
                 "name" => "Chris McCord examples",
                 "github_url" => "chrismccord/phoenix_live_view_example"
               },
               %{
                 "name" => "Chris McCord examples",
                 "tweet_url" => "https://twitter.com/chris_mccord/status/1106291353670045696"
               },
               %{},
               nil
             ])

    assert a["github_url"] == "https://github.com/chrismccord/phoenix_live_view_example"
    assert a["github_repo"] == "chrismccord/phoenix_live_view_example"

    assert b["github_url"] == "https://github.com/chrismccord/phoenix_live_view_example"
    assert b["github_repo"] == "chrismccord/phoenix_live_view_example"

    refute c["github_url"]
    refute c["github_repo"]

    refute d["github_url"]
    refute d["github_repo"]
  end
end
