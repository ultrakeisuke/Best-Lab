$(function () {
  //ドラッグされているデータを保持するためにDataTransferオブジェクトを作成
  var dataBox = new DataTransfer();
  //querySelectorでfile_fieldを取得
  var file_field = document.querySelector('input[type="file"]')
  //fileが選択した際にイベントが発生
  $('#picture-file').change(function () {
    //アップロードするファイルにアクセス
    var files = $('input[type="file"]').prop('files')[0];
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
        $('picture-container').css('display', 'none')
      }
      //読み込み完了後にファイルのURLをsrcに格納するイベントを設定
      fileReader.onloadend = function () {
        var src = fileReader.result
        var html = `<div class='message-picture' data-picture="${file.name}">
                      <div class='message-picture__content'>
                        <div class='message-picture__content--icon'>
                          <img src=${src} width='100' height='80'>
                        </div>
                      </div>
                      <div class='message-picture__operation'>
                        <div class='message-picture__operation--delete'>削除</div>
                      </div>
                    </div>`
        //#picture-containerの前にhtmlを挿入
        $('#picture-container').before(html);
      }
      //#picture-containerクラスを変更し、CSSでドロップボックスの大きさを変更
      $('#picture-container').attr('class', `picture-num-${num}`)
    });
  });
  $(document).on("click", '.message-picture__operation--delete', function () {
    //プレビュー要素(.message-picture)を取得
    var target_picture = $(this).parent().parent()
    //プレビュー全体を消去
    target_picture.remove();
    //inputタグに入ったファイルを削除
    file_field.val("")
  })
});