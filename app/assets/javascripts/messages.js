$(function () {
  let html;
  for (let i = 1; i <= 3; i++) {
    html = `<input type="file" name="message[pictures_attributes][${i}][picture]" id="message_pictures_attributes_${i}_picture">`
    $(".message-pictures").append(html);
  }
})