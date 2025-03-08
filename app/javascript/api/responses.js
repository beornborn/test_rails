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
};
