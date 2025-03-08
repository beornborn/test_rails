import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi } from 'api';

export default class extends BaseController {
  static targets = ['form', 'question'];

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content;
  }

  async submit(event) {
    event.preventDefault();

    try {
      await surveysApi.create({
        question: this.questionTarget.value,
      });

      this.formTarget.reset();
      this.dispatch('surveyCreated');
    } catch (error) {
      console.error('Error creating survey:', error);
    }
  }
}
