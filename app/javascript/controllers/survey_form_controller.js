import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi } from 'api';

export default class extends BaseController {
  static targets = ['form', 'question', 'submitButton'];
  static classes = ['error', 'loading'];
  static values = {
    submitting: Boolean,
  };

  connect() {
    this.questionTarget.addEventListener('input', () => this.validateQuestion());
  }

  disconnect() {
    this.questionTarget.removeEventListener('input', () => this.validateQuestion());
  }

  validateQuestion() {
    const question = this.questionTarget.value.trim();
    const isValid = question.length >= 3;

    this.questionTarget.classList.toggle(this.errorClass, !isValid);
    return isValid;
  }

  async submit(event) {
    event.preventDefault();

    if (!this.validateQuestion() || this.submittingValue) {
      return;
    }

    try {
      this.submittingValue = true;
      this.submitButtonTarget.disabled = true;
      this.element.closest('.form-container').classList.add(this.loadingClass);

      await surveysApi.create({
        question: this.questionTarget.value.trim(),
        options: ['yes', 'no'],
      });

      this.formTarget.reset();
      this.dispatch('surveyCreated');
    } catch (error) {
      console.error('Error creating survey:', error);
      this.questionTarget.classList.add(this.errorClass);
    } finally {
      this.submittingValue = false;
      this.submitButtonTarget.disabled = false;
      this.element.closest('.form-container').classList.remove(this.loadingClass);
    }
  }
}
