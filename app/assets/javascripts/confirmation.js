window.onload = function () {

  class Confirm {
    constructor(el) {
      //押下したボタンのdata-confirm値を取得する
      this.message = el.getAttribute('data-confirm')
      //値がセットされていた場合
      if (this.message) {
        //buttonを押下するとthis.messageの内容がモーダルダイアログで表示される
        el.form.addEventListener('submit', this.confirm.bind(this))
        //値がセットされていなかった場合
      } else {
        //data-confirmに値がセットされていない警告を表示する
        console && console.warn('No value specified in `data-confirm`', el)
      }
    }

    //例外処理
    confirm(e) {
      //モーダルダイアログが出ない場合
      if (!window.confirm(this.message)) {
        //そのイベントを実行しない
        e.preventDefault();
      }
    }
  }

  //data-confirmを持つすべての要素を取り出して配列に格納
  //各要素に対しConfirmクラスからインスタンスを生成
  Array.from(document.querySelectorAll('[data-confirm]')).forEach((el) => {
    new Confirm(el);
  })

}
