// 投稿した画像のポップアップに関する処理
$(function () {
  // ポップアップ用の背景と画像を非表示にする
  $('#popup-background').hide();
  $('#popup-item').hide();

  // 投稿した画像をクリックしてポップアップを表示する処理
  $('.popup-img').on('click', function () {
    // クリックした画像ファイルをimageSrcに格納
    var imgSrc = this.src;
    $('#popup-item').attr('src', imgSrc);
    // ポップアップを表示
    showPopup();
  });

  // ポップアップをクリックして画像を非表示にする処理
  $('#popup-background, #popup-item').on('click', function () {
    $('#popup-background').fadeOut();
    $('#popup-item').fadeOut();
  });
});

// ポップアップを表示する関数
function showPopup() {
  //ポップアップ用の背景を表示
  $('#popup-background').fadeIn(function () {
    var cssObj = {
      marginTop: -250,
      marginLeft: -200,
      width: 400,
      height: 500
    }
    // ポップアップ画像を表示
    $('#popup-item').css(cssObj).fadeIn(100);
  });
}
