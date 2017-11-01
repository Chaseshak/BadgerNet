# Toggles modal on page with id
window.toggleModal = (id) ->
    modal = document.getElementById(id)
    if modal.classList.contains('hidden')
        modal.classList.remove('hidden')
    else modal.classList.add('hidden')
