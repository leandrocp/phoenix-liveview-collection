import css from "../css/app.css"
import "phoenix_html"
import LiveSocket from "phoenix_live_view"

let Hooks = {}
Hooks.Tweet = {
  mounted(){
    twttr.widgets.createTweet(this.el.id, this.el);
  },
  updated(){
    twttr.widgets.createTweet(this.el.id, this.el);
  }
}

let liveSocket = new LiveSocket("/live", {hooks: Hooks});
liveSocket.connect();
