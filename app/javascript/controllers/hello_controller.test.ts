import { Application } from '@hotwired/stimulus'
import { afterEach, beforeEach, describe, expect, it } from 'vitest'
import HelloController from './hello_controller'

describe('HelloController', () => {
  let application: Application

  beforeEach(() => {
    // Set up Stimulus application
    application = Application.start()
    application.register('hello', HelloController)

    // Set up DOM
    document.body.innerHTML = `
      <div data-controller="hello"></div>
    `
  })

  afterEach(() => {
    // Clean up
    application.stop()
    document.body.innerHTML = ''
  })

  it('sets element text content on connect', async () => {
    // Wait for Stimulus to connect the controller
    await new Promise((resolve) => setTimeout(resolve, 0))

    const element = document.querySelector("[data-controller='hello']")
    expect(element?.textContent).toBe('Hello World!')
  })

  it('works with multiple elements', async () => {
    document.body.innerHTML = `
      <div data-controller="hello" id="first"></div>
      <div data-controller="hello" id="second"></div>
    `

    await new Promise((resolve) => setTimeout(resolve, 0))

    expect(document.getElementById('first')?.textContent).toBe('Hello World!')
    expect(document.getElementById('second')?.textContent).toBe('Hello World!')
  })
})
