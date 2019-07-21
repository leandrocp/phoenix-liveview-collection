import css from "../css/app.css"
import "phoenix_html"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live");
liveSocket.connect();

document.addEventListener('phx:update', () => {
  setTimeout(() => {
    twttr.widgets.load(document.getElementById("collection"));
  }, 100);
});
