defmodule LiveViewCollection.CollectionTest do
  use ExUnit.Case, async: true

  alias LiveViewCollection.Collection

  test "load_from_file" do
    assert [a | [b | []]] = Collection.load_from_file()

    assert a["name"] == "Chris McCord examples"
    assert a["tweet_url"] == "https://twitter.com/chris_mccord/status/1106291353670045696"
    assert a["github_url"] == "https://github.com/chrismccord/phoenix_live_view_example"
    assert a["search"] =~ "Chris McCord examples"
    assert a["search"] =~ "public"

    assert b["name"] == "Chris McCord examples"
    assert a["tweet_url"] == "https://twitter.com/chris_mccord/status/1106291353670045696"
    assert b["github_url"] == nil
    assert b["search"] =~ "Chris McCord examples"
    assert b["search"] =~ "public"
  end
end
