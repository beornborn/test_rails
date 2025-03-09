import { calculateVotePercentages } from '../utils/percentage_calculator';

export class SurveyRenderer {
  static renderEmpty() {
    return '<div class="empty-state">No surveys yet. Create your first survey!</div>';
  }

  static renderSurveyItem(survey) {
    return `
      <div class="survey-item" data-survey-id="${survey.id}">
        ${this.renderHeader(survey)}
        ${this.renderContent(survey)}
      </div>
    `;
  }

  static renderHeader(survey) {
    return `
      <div class="survey-header">
        <h3>${survey.question}</h3>
        ${this.renderActions(survey)}
      </div>
    `;
  }

  static renderActions(survey) {
    const actions = [];
    if (survey.user_responded) {
      actions.push(this.renderChangeVoteButton(survey));
    }
    if (survey.user_creator) {
      actions.push(this.renderDeleteButton(survey));
    }
    return actions.length ? `<div class="survey-actions">${actions.join('')}</div>` : '';
  }

  static renderChangeVoteButton(survey) {
    return `
      <button data-action="click->survey-list#changeVote"
              data-survey-id="${survey.id}"
              class="button button-secondary">
        Change Vote
      </button>
    `;
  }

  static renderDeleteButton(survey) {
    return `
      <button data-action="click->survey-list#deleteSurvey"
              data-survey-id="${survey.id}"
              class="button button-danger">
        Delete
      </button>
    `;
  }

  static renderContent(survey) {
    return survey.user_responded ? this.renderVoteStats(survey) : this.renderVoteButtons(survey);
  }

  static renderVoteStats(survey) {
    const percentages = calculateVotePercentages(survey.response_counts);
    const yesVotes = survey.response_counts?.yes || 0;
    const noVotes = survey.response_counts?.no || 0;
    const yesPercentage = percentages['yes'] || 0;
    const noPercentage = percentages['no'] || 0;

    return `
      <div class="response-counts">
        ${this.renderVoteOption('yes', yesVotes, yesPercentage)}
        ${this.renderVoteOption('no', noVotes, noPercentage)}
      </div>
    `;
  }

  static renderVoteOption(type, votes, percentage) {
    return `
      <div class="vote-option ${type}-count">
        <div class="vote-header">
          <div class="vote-label">
            <span class="dot"></span>
            ${type.charAt(0).toUpperCase() + type.slice(1)}
          </div>
          <div class="vote-count">${votes} votes (${percentage}%)</div>
        </div>
        <div class="vote-bar" style="width: ${percentage}%"></div>
      </div>
    `;
  }

  static renderVoteButtons(survey) {
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
}
