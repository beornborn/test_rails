import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content;
  }

  get headers() {
    return {
      'Content-Type': 'application/json',
      'X-User-UUID': localStorage.getItem('user_uuid'),
      'X-CSRF-Token': this.csrfToken,
    };
  }
}
