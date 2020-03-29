defmodule LiveViewCollection.TwitterTest do
  use ExUnit.Case, async: true

  alias LiveViewCollection.Twitter

  test "id" do
    assert Twitter.id(nil) == nil
    assert Twitter.id("") == nil

    assert Twitter.id("https://twitter.com/chris_mccord/status/1106291353670045696") ==
             "1106291353670045696"
  end

  test "tweet" do
    assert Twitter.tweet(nil) == nil
    assert Twitter.tweet("") == nil

    assert %{"html" => _html} =
             Twitter.tweet("https://twitter.com/chris_mccord/status/1106291353670045696")

    assert Twitter.tweet("https://twitter.com/chris_mccord/status/invalid_id") == nil
  end

  test "resolve" do
    assert [resolved | []] =
             Twitter.resolve([
               %{
                 "name" => "Chris McCord examples",
                 "tweet_url" => "https://twitter.com/chris_mccord/status/1106291353670045696",
                 "github_url" => "https://github.com/chrismccord/phoenix_live_view_example"
               },
               %{
                 "name" => "Chris McCord examples",
                 "tweet_url" => nil,
                 "github_url" => "https://github.com/chrismccord/phoenix_live_view_example"
               },
               %{
                 "name" => "Chris McCord examples",
                 "github_url" => "https://github.com/chrismccord/phoenix_live_view_example"
               },
               %{},
               nil
             ])

    assert resolved["tweet_id"] == "1106291353670045696"
    assert resolved["tweet_url"] == "https://twitter.com/chris_mccord/status/1106291353670045696"
  end
end
