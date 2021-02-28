window.addEventListener('load', function () {
  // 回答に関する処理
  function clickAnswerContents() {
    // 回答編集用のアイコンをクリックしたときの処理
    $(document).on('click', '.edit-answer-icon', function () {
      var answerID = this.getAttribute('data-answer-id');
      // 回答を非表示にする処理
      $('#answer-contents-' + answerID).addClass('hide');
      // 回答の編集フォームを表示する処理
      $('#edit-answer-form-' + answerID).removeClass('hide');
      $('#edit-answer-form-' + answerID).addClass('show');
    });

    // 回答編集フォームのキャンセルボタンをクリックした時の処理
    $(document).on('click', '.edit-answer-cancel', function () {
      var answerID = this.getAttribute('data-answer-cancel');
      // 編集フォームを非表示にする処理
      $('#edit-answer-form-' + answerID).removeClass('show');
      // 回答を表示する処理
      $('#edit-answer-form-' + answerID).addClass('hide');
      $('#answer-contents-' + answerID).removeClass('hide');
    });
  }

  clickAnswerContents();

  // リプライに関する処理
  function clickReplyContents() {
    // リプライ編集用のアイコンをクリックしたときの処理
    $(document).on('click', '.edit-reply-icon', function () {
      var replyID = this.getAttribute('data-reply-id');
      $('#reply-contents-' + replyID).addClass('hide');
      $('#edit-reply-form-' + replyID).removeClass('hide');
      $('#edit-reply-form-' + replyID).addClass('show');
    });

    // リプライ編集をキャンセルするときの処理
    $(document).on('click', '.edit-reply-cancel', function () {
      var replyID = this.getAttribute('data-reply-cancel');
      // 編集フォームを非表示にする処理
      $('#edit-reply-form-' + replyID).removeClass('show');
      $('#edit-reply-form-' + replyID).addClass('hide');
      // リプライを表示する処理
      $('#reply-contents-' + replyID).removeClass('hide');
    });
  }

  clickReplyContents();

});
