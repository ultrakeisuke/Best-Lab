//メッセージ相手と最後にやりとりした部分から表示する処理
$(function () {
  var element = document.getElementById('message-field__scroll');
  if (element) {
    element.scrollIntoView(false);
  };
});

//メッセージを右クリックすると削除ボタンなどのリストが表示される処理
$(document).on("contextmenu", '.message-field__message', function (e) {
  //右クリックのデフォルトの表示をキャンセル
  e.preventDefault();
  //右クリックした位置情報を取得
  var posX = e.pageX;
  var posY = e.pageY;
  //右クリックした要素のidと対応するリストのidを取得し表示
  id = $(this).attr('id') + "__menu"
  var contextmenu = document.getElementById(id)
  contextmenu.style.display = "block";
  contextmenu.style.left = posX + 'px';
  contextmenu.style.top = posY + 'px';
  //リスト外をクリックしたときにリストを非表示にする処理
  $(document).on("click", function () {
    document.getElementById(id).style.display = "none";
  });
  //他のメッセージを右クリックすると新たなリストが表示され、もとのリストは非表示になる処理
  $(document).on("contextmenu", '.message-field__message', function () {
    contextmenu.style.display = "none";
    document.getElementById(id).style.display = "block";
  });
});
