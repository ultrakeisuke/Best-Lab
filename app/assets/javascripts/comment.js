window.addEventListener('load', function () {
  // 回答に関する処理
  function clickAnswerContents() {
    // 回答編集用のアイコンをクリックしたときの処理
    $(document).on('click', '.edit-answer-icon', function () {
      var answerID = this.getAttribute('data-answer-id');
      // 回答とアイコンを非表示にする処理
      $('#answer-container__body-' + answerID).addClass('hide');
      $('#edit-answer-icon-' + answerID).addClass('hide');
      // 回答の編集フォームを表示する処理
      $('#edit-answer-form-' + answerID).removeClass('hide');
      $('#edit-answer-form-' + answerID).addClass('show');
    });

    // 回答編集フォームのキャンセルボタンをクリックした時の処理
    $(document).on('click', '.edit-answer-cancel', function () {
      var answerID = this.getAttribute('data-answer-cancel');
      // 編集フォームを非表示にする処理
      $('#edit-answer-form-' + answerID).removeClass('show');
      $('#edit-answer-form-' + answerID).addClass('hide');
      // 回答とアイコンを表示する処理
      $('#answer-container__body-' + answerID).removeClass('hide');
      $('#edit-answer-icon-' + answerID).removeClass('hide');
    });
  }

  clickAnswerContents();

  // リプライに関する処理
  function clickReplyContents() {
    // リプライ編集用のアイコンをクリックしたときの処理
    $(document).on('click', '.edit-reply-icon', function () {
      var replyID = this.getAttribute('data-reply-id');
      // リプライとアイコンを非表示にする処理
      $('#reply-container__body-' + replyID).addClass('hide');
      $('#edit-reply-icon-' + replyID).addClass('hide');
      // 編集フォームを表示する処理
      $('#edit-reply-form-' + replyID).removeClass('hide');
      $('#edit-reply-form-' + replyID).addClass('show');
    });

    // リプライ編集をキャンセルするときの処理
    $(document).on('click', '.edit-reply-cancel', function () {
      var replyID = this.getAttribute('data-reply-cancel');
      // 編集フォームを非表示にする処理
      $('#edit-reply-form-' + replyID).removeClass('show');
      $('#edit-reply-form-' + replyID).addClass('hide');
      // リプライとアイコンを表示する処理
      $('#reply-container__body-' + replyID).removeClass('hide');
      $('#edit-reply-icon-' + replyID).removeClass('hide');
    });
  }

  clickReplyContents();
});
