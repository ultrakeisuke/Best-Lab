// 回答に関する処理
function clickAnswerContents() {
  // 回答編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-answer-icon', function () {
    // 回答を非表示にする処理
    var answerID = this.getAttribute('data-answer-id');
    document.getElementById('answer-contents-' + answerID).classList.add('hide');

    // 回答の編集フォームを表示する処理
    document.getElementById('edit-answer-form-' + answerID).classList.remove('hide');
    document.getElementById('edit-answer-form-' + answerID).classList.add('show');
  });

  // 回答編集フォームのキャンセルボタンをクリックした時の処理
  $(document).on('click', '.edit-answer-cancel', function () {
    // 編集フォームを非表示にする処理
    var answerID = this.getAttribute('data-answer-cancel');
    document.getElementById('edit-answer-form-' + answerID).classList.remove('show');
    document.getElementById('edit-answer-form-' + answerID).classList.add('hide');

    // 回答を表示する処理
    document.getElementById('answer-contents-' + answerID).classList.remove('hide');
  });
}

clickAnswerContents();


// リプライに関する処理
function clickReplyContents() {
  // リプライ編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-reply-icon', function () {
    // リプライを非表示にする処理
    var replyID = this.getAttribute('data-reply-id');
    document.getElementById('reply-contents-' + replyID).classList.add('hide');

    // リプライの編集フォームを表示する処理
    document.getElementById('edit-reply-form-' + replyID).classList.remove('hide');
    document.getElementById('edit-reply-form-' + replyID).classList.add('show');
  });

  // リプライ編集をキャンセルするときの処理
  $(document).on('click', '.edit-reply-cancel', function () {
    // 編集フォームを非表示にする処理
    var replyID = this.getAttribute('data-reply-cancel');
    document.getElementById('edit-reply-form-' + replyID).classList.remove('show');
    document.getElementById('edit-reply-form-' + replyID).classList.add('hide');

    // リプライを表示する処理
    document.getElementById('reply-contents-' + replyID).classList.remove('hide');
  });
}

clickReplyContents();
