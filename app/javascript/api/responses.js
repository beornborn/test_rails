import { handleResponse, getHeaders } from './base';
import { urls } from './constants';

export const responsesApi = {
  create: async (surveyId, data) => {
    const response = await fetch(urls.surveyResponses(surveyId), {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify({ response: data }),
    });
    return handleResponse(response);
  },

  delete: async (surveyId) => {
    const response = await fetch(urls.surveyResponseOwn(surveyId), {
      method: 'DELETE',
      headers: getHeaders(),
    });
    return handleResponse(response);
  },
};
