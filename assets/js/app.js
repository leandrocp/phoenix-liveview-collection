import css from "../css/app.css"
import "phoenix_html"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live");
liveSocket.connect();
