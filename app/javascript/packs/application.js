// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Этот код добавляет обработчик события выдвигания формы при клике на кнопку
// «Задать вопрос», которая видна только, когда страница открыта в маленьком
// окне.

document.addEventListener('turbolinks:load', () => {
    const askButton = document.getElementById('ask-button')
    if(askButton) askButton.addEventListener('click', formHider)
})

const formHider = (event) => {
    event.preventDefault()
    const askForm = document.getElementById('ask-form')

    setTimeout(() => {
        askForm.classList.toggle('hide')
    }, 300)
}
