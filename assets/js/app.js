// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss'
import 'alpinejs'
import '../node_modules/bootstrap/dist/js/bootstrap.bundle.min'
import * as Bezier from 'bezier-easing'

//
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

const bezier = Bezier(0, 0, 0.58, 1)

function cuadratic(a, b, c, x) {
  return a * Math.pow(x, 2) + b * x + c
}

function cuadratic_steps(steps, base) {
  const container = Array.from(new Array(steps))
  const step = Math.round((1 / steps) * 100) / 100

  return container.map((_x, i) => {
    return cuadratic(-0.5, 0.5, 0, step * ++i) + base
  })
}

function bezier_steps(steps, number) {
  const container = Array.from(new Array(steps))
  const bezier_step = Math.round((1 / steps) * 100) / 100

  return container.map((_x, i) => {
    if (steps === ++i) return 1

    return bezier(i * bezier_step)
  })
}

function numberAnimation({
  el,
  from = 0,
  number,
  total_steps = 50,
  time = 2500,
}) {
  const diff = number - from
  const step_time = Math.abs(time / total_steps)
  const steps = bezier_steps(total_steps, diff)
  const scale_steps = cuadratic_steps(total_steps, 1)
  console.log(scale_steps)
  _handleNumberAnimation(el, from, number, diff, step_time, steps, scale_steps)
}

function _handleNumberAnimation(
  el,
  from,
  number,
  diff,
  step_time,
  steps,
  cuadratic_steps
) {
  const current_scale = cuadratic_steps.pop()

  if (steps.length > 0) {
    const step = steps.shift()
    const current = step * diff + from

    setAmount(el, current, number > from ? 'up' : 'down', current_scale)

    return setTimeout(
      _handleNumberAnimation.bind(
        this,
        el,
        from,
        number,
        diff,
        step_time,
        steps,
        cuadratic_steps
      ),
      step_time * Math.pow(step, 10)
    )
  }

  setAmount(el, number, 'keep', current_scale)
}

function formatNumber(number, _opts) {
  number = Math.round(number)

  return `${new Intl.NumberFormat('es').format(number)}<sup>Ars</ars>`
}

function setAmount(el, amount, direction, scale) {
  el.innerHTML = formatNumber(amount)
  el.style.color = backgroundColor(direction)
  el.style.transform = `scale(${scale})`
}

function amount(el) {
  return parseInt(el.dataset.amount)
}

function prevAmount(el) {
  return parseInt(el.dataset.prevAmount)
}

function setPrevAmount(el, amount) {
  el.dataset.prevAmount = amount
}

function backgroundColor(direction) {
  if (direction === 'up') return 'green'
  if (direction === 'down') return 'red'
  return ''
}

const Hooks = {
  Odometer: {
    mounted() {
      setAmount(this.el, amount(this.el))
    },
    updated() {
      const amountValue = amount(this.el)
      const prevAmountValue = prevAmount(this.el)

      if (prevAmountValue === amountValue)
        return setAmount(this.el, amountValue)

      numberAnimation({
        el: this.el,
        from: prevAmountValue,
        number: amountValue,
      })

      setPrevAmount(this.el, amountValue)
    },
  },
  Focus: {
    mounted() {
      this.el.focus()
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
