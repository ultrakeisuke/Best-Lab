$(function () {
  //ドラッグされているデータを保持するためにDataTransferオブジェクトを作成
  var dataBox = new DataTransfer();
  //querySelectorでfile_fieldを取得
  var file_field = document.querySelector('input[type="file"]')

  //fileを選択するとイベントが発生
  $('#picture-file').change(function () {
    //アップロードするファイルにアクセス
    $.each(this.files, function (i, file) {
      //ファイルをURIとして読み込む処理を設定
      var fileReader = new FileReader();
      //dataTransferにfileを追加
      dataBox.items.add(file)
      //転送中のファイル一覧をfile_fieldに代入
      file_field.files = dataBox.files
      //プレビューのファイル数をnumに代入
      var num = $('.preview').length + 1 + i
      //ブラウザに画像ファイルを表示
      fileReader.readAsDataURL(file);
      //画像が4枚になったらdataBoxを削除
      if (num == 4) {
        $('.post-field__picture').css('display', 'none')
      }
      //読み込み完了後にファイルのURLをsrcに格納するイベントを設定
      fileReader.onloadend = function () {
        var src = fileReader.result
        var html = `<div class='preview-field__box' data-picture="${file.name}">
                      <div class='preview-field__content'>
                        <div class='preview-field__picture'>
                          <img src=${src} width='100%' height='80'>
                        </div>
                        <div class='preview-field__operation'>
                          <div class='preview-field__operation--delete'>
                            <i class="far fa-times-circle"></i>
                          </div>
                        </div>
                      </div>
                    </div>`
        //.insert-pointの後にhtmlを挿入
        $('.insert-point').after(html);
      }
    });
  });
  $(document).on("click", '.preview-field__operation--delete', function () {
    //プレビュー要素(.preview)を取得
    var target_picture = $(this).parent().parent().parent();
    //削除ボタンを押された画像のfile名を取得
    var target_name = $(target_picture).data('picture')
    //プレビューがひとつだけの場合file_fieldを削除
    if (file_field.files.length == 1) {
      //inputタグに入ったファイルを削除
      $('input[type=file]').val(null)
      //dataTransfer内のデータを削除
      dataBox.clearData();
      console.log(dataBox)
    } else {
      $.each(file_field.files, function (i, input) {
        if (input.name == target_name) {
          dataBox.items.remove(i)
        }
      })
      file_field.files = dataBox.files
    }
    //対象のプレビューを消去
    target_picture.remove()
    //枚数の上限に達した時にプレビューの削除ボタンを押すと画像投稿用アイコンが再表示される
    $('.post-field__picture').show();
  })
});


//メッセージ相手と最後にやりとりした部分から表示する処理
$(function () {
  var element = document.getElementById('message-field__scroll');
  element.scrollIntoView(false);
});


//画像をポップアップで表示する処理
$(function () {
  $('#popup-background').hide();
  $('#popup-item').hide();

  //popupimgがクリックされたときのイベント
  $('.popupimg').bind('click', function () {
    //新たなimg要素を作成
    var img = new Image();
    var imgsrc = this.src;
    //Imageのロードイベントを定義
    $(img).load(function () {
      $('#popup-item').attr('src', imgsrc);
      //ポップアップで表示する表示するためのimgタグに画像が読み込まれているか確認
      $('#popup-item').each(function () {
        //読み込みが完了していた場合、ポップアップ表示用の関数を呼び出す
        if (this.complete) {
          imgload(img);
          return;
        }
      });
      //imgタグのロードイベントを定義
      $('#popup-item').bind('load', function () {
        //画像がロードされたらポップアップ表示用の関数を呼び出す
        imgload(img);
      });
    });
    //Image()に画像を読み込ませる
    img.src = imgsrc;
  });

  //ポップアップされた領域のクリックイベント
  $('#popup-background, #popup-item').bind('click', function () {
    $('#popup-background').fadeOut();
    $('#popup-item').fadeOut();
  });

  //ポップアップ表示用関数を定義
  function imgload() {
    //ポップアップの背景部分を表示する
    $('#popup-background').fadeIn(function () {
      var cssObj = {
        marginTop: -250,
        marginLeft: -200,
        width: 400,
        height: 500
      }
      $('#popup-item').css(cssObj).fadeIn(100);
    });
  }
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
});