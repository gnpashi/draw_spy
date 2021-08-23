import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["spyOrWord"]
    toggle(e) {
        this.spyOrWordTarget.classList.toggle('show')

    }
}