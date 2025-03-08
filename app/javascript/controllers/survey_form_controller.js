import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi } from 'api';

export default class extends BaseController {
  static targets = ['form', 'question'];

  async submit(event) {
    event.preventDefault();

    try {
      await surveysApi.create({
        question: this.questionTarget.value,
        options: ['yes', 'no'],
      });

      this.formTarget.reset();
      this.dispatch('surveyCreated');
    } catch (error) {
      console.error('Error creating survey:', error);
    }
  }
}
