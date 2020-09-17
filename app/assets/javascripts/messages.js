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
      var num = $('.message-picture').length + 1 + i
      //ブラウザに画像ファイルを表示
      fileReader.readAsDataURL(file);
      //画像が4枚になったらdataBoxを削除
      if (num == 4) {
        $('.picture-icon').css('display', 'none')
      }
      //読み込み完了後にファイルのURLをsrcに格納するイベントを設定
      fileReader.onloadend = function () {
        var src = fileReader.result
        var html = `<div class='message-picture' data-picture="${file.name}">
                      <div class='message-picture__content'>
                        <div class='message-picture__content--icon'>
                          <img src=${src} width='100%' height='80'>
                        </div>
                      </div>
                      <div class='message-picture__operation'>
                        <div class='message-picture__operation--delete'>
                          <i class="far fa-times-circle"></i>
                        </div>
                      </div>
                    </div>`
        //#picture-box__containerの前にhtmlを挿入
        $('#picture-box__container').before(html);
      }
    });
  });
  $(document).on("click", '.message-picture__operation--delete', function () {
    //プレビュー要素(.message-picture)を取得
    var target_picture = $(this).parent().parent()
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
  })
});