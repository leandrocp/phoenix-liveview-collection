import css from "../css/app.scss";
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

let Hooks = {};

Hooks.Tweet = {
  mounted() {
    twttr.widgets.createTweet(this.el.id, this.el);
  },
  updated() {
    twttr.widgets.createTweet(this.el.id, this.el);
  },
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

liveSocket.connect();
