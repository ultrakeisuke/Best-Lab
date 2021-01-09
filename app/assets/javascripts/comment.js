// 回答に関する処理
$(function () {
  // 回答編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-answer-icon', function () {
    // 回答を非表示にする処理
    var answerID = $(this).data('answer-id');
    $(`#answer-contents-${answerID}`).addClass("hide");

    // 回答の編集フォームを表示する処理
    $(`#edit-answer-form-${answerID}`).removeClass("hide");
    $(`#edit-answer-form-${answerID}`).addClass("show");
  });

  // 回答の編集をキャンセルするときの処理
  $(document).on('click', '.edit-answer-cancel', function () {
    // 編集フォームを非表示にする処理
    var answerID = $(this).data('answer-cancel');
    $(`#edit-answer-form-${answerID}`).removeClass("show");
    $(`#edit-answer-form-${answerID}`).addClass("hide");

    // 回答を表示する処理
    $(`#answer-contents-${answerID}`).removeClass("hide");
  });
});

// リプライに関する処理
$(function () {
  // リプライ編集用のアイコンをクリックしたときの処理
  $(document).on('click', '.edit-reply-icon', function () {
    // リプライを非表示にする処理
    var replyID = $(this).data('reply-id');
    $(`#reply-contents-${replyID}`).addClass("hide");

    // リプライの編集フォームを表示する処理
    $(`#edit-reply-form-${replyID}`).removeClass("hide");
    $(`#edit-reply-form-${replyID}`).addClass("show");
  });

  // リプライ編集をキャンセルするときの処理
  $(document).on('click', '.edit-reply-cancel', function () {
    // 編集フォームを非表示にする処理
    var replyID = $(this).data('reply-cancel');
    $(`#edit-reply-form-${replyID}`).removeClass("show");
    $(`#edit-reply-form-${replyID}`).addClass("hide");

    // リプライを表示する処理
    $(`#reply-contents-${replyID}`).removeClass("hide");
  });
});
