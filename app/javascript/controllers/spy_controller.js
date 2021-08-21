import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["spyOrWord"]

    toggle(e) {
        console.log("togle");
        if (this.spyOrWordTarget.classList.contains('show')) {
            this.spyOrWordTarget.classList.remove('show')

        } else {
            this.spyOrWordTarget.classList.add('show')

        }
    }
}