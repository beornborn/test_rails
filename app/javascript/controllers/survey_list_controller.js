import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi, responsesApi } from 'api';

export default class extends BaseController {
  static targets = ['list', 'createForm'];

  connect() {
    this.loadSurveys();
    this.bindEvents();
  }

  disconnect() {
    this.element.removeEventListener('survey-form:surveyCreated', this.handleSurveyCreated);
  }

  bindEvents() {
    this.handleSurveyCreated = () => {
      this.hideCreateForm();
      this.loadSurveys();
    };
    this.element.addEventListener('survey-form:surveyCreated', this.handleSurveyCreated);
  }

  async loadSurveys() {
    try {
      const surveys = await surveysApi.getAll();
      this.renderSurveys(surveys);
    } catch (error) {
      console.error('Error loading surveys:', error);
    }
  }

  renderSurveys(surveys) {
    if (surveys.length === 0) {
      this.listTarget.innerHTML =
        '<div class="empty-state">No surveys yet. Create your first survey!</div>';
      return;
    }

    this.listTarget.innerHTML = surveys
      .map(
        (survey) => `
      <div class="survey-item" data-survey-id="${survey.id}">
        <div class="survey-header">
          <h3>${survey.question}</h3>
          ${
            survey.user_creator
              ? `
            <button data-action="click->survey-list#deleteSurvey"
                    data-survey-id="${survey.id}"
                    class="button button-danger">
              Delete
            </button>
          `
              : ''
          }
        </div>
        <div class="response-counts">
          <span class="yes-count">
            <span class="dot"></span>
            Yes: ${survey.response_counts?.yes || 0}
          </span>
          <span class="no-count">
            <span class="dot"></span>
            No: ${survey.response_counts?.no || 0}
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

  async deleteSurvey(event) {
    const surveyId = event.currentTarget.dataset.surveyId;

    if (!confirm('Are you sure you want to delete this survey?')) {
      return;
    }

    try {
      await surveysApi.delete(surveyId);
      this.loadSurveys();
    } catch (error) {
      console.error('Error deleting survey:', error);
    }
  }

  async submitResponse(event) {
    const surveyId = event.currentTarget.dataset.surveyId;
    const answer = event.currentTarget.dataset.answer;

    try {
      await responsesApi.create(surveyId, { answer });
      this.loadSurveys();
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
