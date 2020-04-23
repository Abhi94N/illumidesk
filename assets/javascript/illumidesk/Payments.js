'use strict';


export function showOrClearError(errorMessage) {
  const displayError = document.getElementById('card-errors');
  if (errorMessage) {
    displayError.textContent = errorMessage;
  } else {
    displayError.textContent = '';
  }
}

export function createCardElement(stripe) {
  let elements = stripe.elements();
  const style = {
      base: {
          fontSize: '16px',
      }
  };
  // Create an instance of the card Element.
  let cardElement = elements.create('card', {style: style});
  cardElement.mount("#card-element");
  cardElement.addEventListener('change', function (event) {
    const errorMessage = event.error ? event.error.message : '';
    showOrClearError(errorMessage);
  });
  return cardElement;
}


export const Payments = {
  showOrClearError: showOrClearError,
  createCardElement: createCardElement,
};
