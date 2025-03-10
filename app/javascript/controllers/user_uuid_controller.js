import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    const userUuid = this.element.dataset.userUuid;
    if (userUuid) {
      localStorage.setItem('user_uuid', userUuid);
    }
  }
}
