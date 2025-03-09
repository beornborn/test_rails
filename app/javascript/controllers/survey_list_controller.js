import { Controller } from '@hotwired/stimulus';
import BaseController from './base_controller';
import { surveysApi, responsesApi } from 'api';
import { SurveyRenderer } from '../components/survey_renderer';

export default class extends BaseController {
  static targets = ['list', 'createForm'];
  static classes = ['loading'];

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
      this.listTarget.classList.add(this.loadingClass);
      const surveys = await surveysApi.getAll();
      this.renderSurveys(surveys);
    } catch (error) {
      console.error('Error loading surveys:', error);
    } finally {
      this.listTarget.classList.remove(this.loadingClass);
    }
  }

  renderSurveys(surveys) {
    if (surveys.length === 0) {
      this.listTarget.innerHTML = SurveyRenderer.renderEmpty();
      return;
    }

    this.listTarget.innerHTML = surveys
      .map((survey) => SurveyRenderer.renderSurveyItem(survey))
      .join('');
  }

  async submitResponse(event) {
    const surveyId = event.currentTarget.dataset.surveyId;
    const answer = event.currentTarget.dataset.answer;
    const button = event.currentTarget;

    try {
      button.disabled = true;
      await responsesApi.create(surveyId, { answer });
      this.loadSurveys();
    } catch (error) {
      console.error('Error submitting response:', error);
    } finally {
      button.disabled = false;
    }
  }

  async deleteSurvey(event) {
    const surveyId = event.currentTarget.dataset.surveyId;
    const button = event.currentTarget;

    if (!confirm('Are you sure you want to delete this survey?')) {
      return;
    }

    try {
      button.disabled = true;
      await surveysApi.delete(surveyId);
      this.loadSurveys();
    } catch (error) {
      console.error('Error deleting survey:', error);
    } finally {
      button.disabled = false;
    }
  }

  async changeVote(event) {
    const surveyId = event.currentTarget.dataset.surveyId;
    const button = event.currentTarget;

    try {
      button.disabled = true;
      await responsesApi.delete(surveyId);
      this.loadSurveys();
    } catch (error) {
      console.error('Error changing vote:', error);
    } finally {
      button.disabled = false;
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
