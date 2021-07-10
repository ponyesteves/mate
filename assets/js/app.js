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

function handleDragStart(e) {
  const account_id = e.currentTarget.dataset.accountId
  const source_id = e.currentTarget.dataset.sourceId
  const amount = e.currentTarget.dataset.amount

  e.dataTransfer.setData('account_id', account_id)
  e.dataTransfer.setData('source_id', source_id)
  e.dataTransfer.setData('amount', amount)

  // e.preventDefault()
  this.style.opacity = '0.4'
}

function handleDragEnd(_e) {
  this.style.opacity = '1'
}

const bezier = Bezier(0, 0, 0.58, 1)

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

  _handleNumberAnimation(el, from, number, diff, step_time, steps)
}

function _handleNumberAnimation(el, from, number, diff, step_time, steps) {
  if (steps.length > 0) {
    const step = steps.shift()
    const current = step * diff + from

    setAmount(el, current, number > from ? 'up' : 'down')

    return setTimeout(
      _handleNumberAnimation.bind(
        this,
        el,
        from,
        number,
        diff,
        step_time,
        steps
      ),
      step_time * Math.pow(step, 10)
    )
  }

  setAmount(el, number)
}

function formatNumber(number, _opts) {
  number = Math.round(number)

  return `${new Intl.NumberFormat('es').format(number)}<sup>Ars</ars>`
}

function setAmount(el, amount, direction) {
  el.innerHTML = formatNumber(amount)
  el.style.color = backgroundColor(direction)
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
  Drop: {
    mounted() {
      const $this = this

      this.el.addEventListener(
        'drop',
        function (e) {
          e.preventDefault()

          // Get the data, which is the id of the drop target
          //TODO: normalize variables on startdrag to fit 👇
          const account_credit_id = e.currentTarget.getAttribute('id')
          const account_debit_id = e.dataTransfer.getData('account_id')
          const source_id = e.dataTransfer.getData('source_id')
          const amount = e.dataTransfer.getData('amount')

          $this.pushEventTo('#available-card', 'drop', {
            account_credit_id,
            account_debit_id,
            source_id,
            amount,
          })
        },
        false
      )
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
