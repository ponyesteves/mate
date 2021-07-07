// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss'
import 'alpinejs'
import '../node_modules/bootstrap/dist/js/bootstrap.bundle.min'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'
import { Socket } from 'phoenix'
import topbar from 'topbar'
import { LiveSocket } from 'phoenix_live_view'

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

function handleDragStart(_e) {
  this.style.opacity = '0.4'
}

function handleDragEnd(_e) {
  this.style.opacity = '1'
}

const Hooks = {
  Drop: {
    mounted() {
      /* events fired on the drop targets */
      this.el.addEventListener(
        'dragover',
        function (e) {
          // prevent default to allow drop
          e.currentTarget.style.transform = 'scale(1.05)'
          // e.preventDefault()
        },
        false
      )

      this.el.addEventListener(
        'dragenter',
        function (e) {
          // highlight potential drop target when the draggable element enters it
          // e.currentTarget.style.border = '5px dotted grey'
        },
        false
      )
      this.el.addEventListener(
        'dragleave',
        function (e) {
          // reset background of potential drop target when the draggable element leaves it
          e.currentTarget.style.transform = 'scale(1)'
        },
        false
      )
    },
  },
  Drag: {
    mounted() {
      this.el.draggable = true
      this.el.addEventListener('dragstart', handleDragStart)
      this.el.addEventListener('dragend', handleDragEnd)
    },
  },
}
let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to)
      }
    },
  },
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', (_info) => topbar.show())
window.addEventListener('phx:page-loading-stop', (_info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
