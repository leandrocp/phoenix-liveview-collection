defmodule LiveViewCollection.Twitter do
  def embed_html(tweet_url) do
    %_{body: body} = HTTPotion.get("https://publish.twitter.com/oembed?url=#{tweet_url}")

    body
    |> Jason.decode!()
    |> Map.fetch!("html")
    |> Floki.filter_out("script")
    |> Floki.raw_html()
  end
end
