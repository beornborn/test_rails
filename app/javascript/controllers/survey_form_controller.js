import { Controller } from "@hotwired/stimulus"
import BaseController from "./base_controller"

export default class extends BaseController {
  static targets = ["form", "question"]

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }

  async submit(event) {
    event.preventDefault()

    try {
      const response = await fetch("/api/v1/surveys", {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify({
          survey: {
            question: this.questionTarget.value
          }
        })
      })

      if (response.ok) {
        this.formTarget.reset()
        this.dispatch('surveyCreated')
      } else {
        console.error("Error creating survey")
      }
    } catch (error) {
      console.error("Error creating survey:", error)
    }
  }
}
