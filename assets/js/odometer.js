import * as Bezier from 'bezier-easing'

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

export const Odometer = {
  mounted() {
    setAmount(this.el, amount(this.el))
  },
  updated() {
    const amountValue = amount(this.el)
    const prevAmountValue = prevAmount(this.el)

    if (prevAmountValue === amountValue) return setAmount(this.el, amountValue)

    numberAnimation({
      el: this.el,
      from: prevAmountValue,
      number: amountValue,
    })

    setPrevAmount(this.el, amountValue)
  },
}
