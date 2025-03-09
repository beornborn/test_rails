export const API_BASE_URL = '/api/v1';

export const urls = {
  surveys: `${API_BASE_URL}/surveys`,
  surveyResponses: (surveyId) => `${API_BASE_URL}/surveys/${surveyId}/responses`,
  surveyResponseOwn: (surveyId) => `${API_BASE_URL}/surveys/${surveyId}/responses/own`,
};
