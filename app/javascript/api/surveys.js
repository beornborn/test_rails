import { handleResponse, getHeaders } from './base';
import { urls } from './constants';

export const surveysApi = {
  getAll: async () => {
    const response = await fetch(urls.surveys, {
      headers: getHeaders(),
    });
    return handleResponse(response);
  },

  create: async (data) => {
    const response = await fetch(urls.surveys, {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify({ survey: data }),
    });
    return handleResponse(response);
  },

  delete: async (id) => {
    const response = await fetch(`${urls.surveys}/${id}`, {
      method: 'DELETE',
      headers: getHeaders(),
    });
    return handleResponse(response);
  },
};
