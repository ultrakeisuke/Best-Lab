// 画像選択に関する処理
$(function () {
  // 選択した画像の枚数をカメラアイコンの代わりに表示する処理
  $('#picture-file').change(function () {
    var files = this.files;
    $('#picture-file-icon').replaceWith(
      `<i id="num-of-files">${files.length}</i>`
    );
    if (files.length > 4) {
      $('#num-of-files').addClass('too-many-files');
    }
    // 画像の再選択に関する処理
    if ($('#num-of-files')) {
      $('#picture-file').change(function () {
        var files = this.files;
        $('#num-of-files').replaceWith(
          `<i id="num-of-files">${files.length}</i>`
        );
        if (files.length > 4) {
          $('#num-of-files').addClass('too-many-files');
        }
      });
    }
  });
});
