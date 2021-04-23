// DM、質問投稿、回答投稿時の画像選択に関する処理
$(function () {
  // 選択した画像の枚数をカメラアイコンの代わりに表示する処理
  $('#picture-file').change(function () {
    var files = this.files;
    $('#picture-file-icon').replaceWith(
      `<p id="num-of-files">${files.length}</p>`
    );
    if (files.length > 4) {
      $('#num-of-files').addClass('too-many-files');
    }
    // 画像の再選択に関する処理
    if ($('#num-of-files')) {
      $('#picture-file').change(function () {
        var files = this.files;
        $('#num-of-files').replaceWith(
          `<p id="num-of-files">${files.length}</p>`
        );
        if (files.length > 4) {
          $('#num-of-files').addClass('too-many-files');
        }
      });
    }
  });
});

// プロフィール画像選択に関する処理
$(function () {
  // 選択した画像の枚数をカメラアイコンの代わりに表示する処理
  $('#setting-picture-for-account').change(function () {
    $('#picture-file-text').replaceWith(`<p>画像が選択されました</p>`);
  });
});
