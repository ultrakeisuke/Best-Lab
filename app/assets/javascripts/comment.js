// 回答に関する処理
$(function () {
  // 回答編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-answer-icon', function () {
    // 回答を非表示にする処理
    var answerID = $(this).data('answer-id');
    hideAnswerContents = document.getElementById('answer-contents-' + answerID);
    hideAnswerContents.style.display = "none";

    // 回答の編集フォームを表示する処理
    showAnswerForm = document.getElementById('edit-answer-form-' + answerID);
    showAnswerForm.style.display = "block";
  });

  // 回答の編集をキャンセルするときの処理
  $(document).on('click', '.edit-answer-cancel', function () {
    // 編集フォームを非表示にする処理
    var answerID = $(this).data('answer-cancel');
    hideAnswerForm = document.getElementById('edit-answer-form-' + answerID);
    hideAnswerForm.style.display = "none";

    // 回答を表示する処理
    showAnswerContents = document.getElementById('answer-contents-' + answerID);
    showAnswerContents.style.display = "block";
  });
});

// リプライに関する処理
$(function () {
  // リプライ編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-reply-icon', function () {
    // リプライを非表示にする処理
    var replyID = $(this).data('reply-id');
    hideReplyContents = document.getElementById('reply-contents-' + replyID);
    hideReplyContents.style.display = "none";

    // リプライの編集フォームを表示する処理
    showReplyForm = document.getElementById('edit-reply-form-' + replyID);
    showReplyForm.style.display = "block";
  });

  // リプライ編集をキャンセルするときの処理
  $(document).on('click', '.edit-reply-cancel', function () {
    // 編集フォームを非表示にする処理
    var replyID = $(this).data('reply-cancel');
    hideReplyForm = document.getElementById('edit-reply-form-' + replyID);
    hideReplyForm.style.display = "none";

    // リプライを表示する処理
    showReplyContents = document.getElementById('reply-contents-' + replyID);
    showReplyContents.style.display = "block";
  });
});
