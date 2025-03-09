import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi, responsesApi } from 'api';
import { calculateVotePercentages } from '../utils/percentage_calculator';

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
          <div class="survey-actions">
            ${
              survey.user_responded
                ? `
              <button data-action="click->survey-list#changeVote"
                      data-survey-id="${survey.id}"
                      class="button button-secondary">
                Change Vote
              </button>
            `
                : ''
            }
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
        </div>
        ${this.renderSurveyContent(survey)}
      </div>
    `
      )
      .join('');
  }

  renderSurveyContent(survey) {
    if (survey.user_responded) {
      return this.renderVoteStats(survey);
    } else {
      return this.renderVoteButtons(survey);
    }
  }

  renderVoteStats(survey) {
    const percentages = calculateVotePercentages(survey.response_counts);
    const yesVotes = survey.response_counts?.yes || 0;
    const noVotes = survey.response_counts?.no || 0;
    const yesPercentage = percentages['yes'] || 0;
    const noPercentage = percentages['no'] || 0;

    return `
      <div class="response-counts">
        <div class="vote-option yes-count">
          <div class="vote-header">
            <div class="vote-label">
              <span class="dot"></span>
              Yes
            </div>
            <div class="vote-count">${yesVotes} votes (${yesPercentage}%)</div>
          </div>
          <div class="vote-bar" style="width: ${yesPercentage}%"></div>
        </div>
        <div class="vote-option no-count">
          <div class="vote-header">
            <div class="vote-label">
              <span class="dot"></span>
              No
            </div>
            <div class="vote-count">${noVotes} votes (${noPercentage}%)</div>
          </div>
          <div class="vote-bar" style="width: ${noPercentage}%"></div>
        </div>
      </div>
    `;
  }

  renderVoteButtons(survey) {
    return `
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
    `;
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

  async changeVote(event) {
    const surveyId = event.currentTarget.dataset.surveyId;

    try {
      await responsesApi.delete(surveyId);
      this.loadSurveys();
    } catch (error) {
      console.error('Error changing vote:', error);
    }
  }

  showCreateForm() {
    this.createFormTarget.classList.remove('hidden');
  }

  hideCreateForm() {
    const formController = this.element.querySelector('[data-controller="survey-form"]');
    if (formController) {
      formController.querySelector('form').reset();
    }
    this.createFormTarget.classList.add('hidden');
  }
}
