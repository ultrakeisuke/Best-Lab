// 所属ごとにテキストの背景色が変わる処理
window.addEventListener('load', function () {
  var affiliation = document.getElementById('user-affiliation');
  var lists = [
    { ja: '大学生', en: 'undergraduate' },
    { ja: '大学院生', en: 'graduate' },
    { ja: '高専生', en: 'technical-students' },
    { ja: '専門学生', en: 'professional-students' },
    { ja: '社会人', en: 'working' },
    { ja: 'その他', en: 'other' }
  ]
  // ユーザーの所属がlistsの日本語表記と一致していれば、その英語表記のクラスを追加
  if (affiliation) {
    lists.forEach(function (i) {
      if (affiliation.textContent == i.ja) {
        affiliation.classList.add(i.en);
      }
    });
  }
});
