$(function () {
  //querySelectorでfile_fieldを取得
  var file_field = document.querySelector('input[type="file"]')
  //fileが選択した際にイベントが発生
  $('#picture-file').change(function () {
    //アップロードするファイルにアクセス
    var file = $('input[type="file"]').prop('files')[0];
    //ファイルをURIとして読み込む処理を設定
    var fileReader = new FileReader();
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
    //読み込みを実行
    fileReader.readAsDataURL(file);
  });
});