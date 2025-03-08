import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';

export default class extends BaseController {
  static targets = ['list', 'createForm'];

  connect() {
    this.loadSurveys();
  }

  async loadSurveys() {
    try {
      const response = await fetch('/api/v1/surveys', {
        headers: this.headers,
      });
      const surveys = await response.json();
      this.renderSurveys(surveys);
    } catch (error) {
      console.error('Error loading surveys:', error);
    }
  }

  renderSurveys(surveys) {
    this.listTarget.innerHTML = surveys
      .map(
        survey => `
      <div class="survey-item" data-survey-id="${survey.id}">
        <h3>${survey.question}</h3>
        <div class="response-counts">
          <span class="yes-count">
            <span class="dot"></span>
            Yes: ${survey.response_counts.yes || 0}
          </span>
          <span class="no-count">
            <span class="dot"></span>
            No: ${survey.response_counts.no || 0}
          </span>
        </div>
        <div class="response-buttons">
          <button data-action="click->survey-list#submitResponse"
                  data-survey-id="${survey.id}"
                  data-answer="yes"
                  class="button button-success">
            Yes
          </button>
          <button data-action="click->survey-list#submitResponse"
                  data-survey-id="${survey.id}"
                  data-answer="no"
                  class="button button-danger">
            No
          </button>
        </div>
      </div>
    `
      )
      .join('');
  }

  async submitResponse(event) {
    const surveyId = event.currentTarget.dataset.surveyId;
    const answer = event.currentTarget.dataset.answer;

    try {
      const response = await fetch(`/api/v1/surveys/${surveyId}/responses`, {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify({ response: { answer } }),
      });

      if (response.ok) {
        this.loadSurveys(); // Refresh the list
      } else {
        console.error('Error submitting response');
      }
    } catch (error) {
      console.error('Error submitting response:', error);
    }
  }

  showCreateForm() {
    this.createFormTarget.classList.remove('hidden');
  }

  hideCreateForm() {
    this.createFormTarget.classList.add('hidden');
  }
}
