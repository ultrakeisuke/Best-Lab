// 所属ごとにテキストの背景色が変わる処理
window.addEventListener('load', function () {
  var affiliation = document.getElementById('user-affiliation');
  if (affiliation) {
    if (affiliation.textContent == "大学生") {
      document.getElementById('user-affiliation').classList.add('undergraduate');
    } else if (affiliation.textContent == "大学院生") {
      document.getElementById('user-affiliation').classList.add('graduate');
    } else if (affiliation.textContent == "高専生") {
      document.getElementById('user-affiliation').classList.add('technical-students');
    } else if (affiliation.textContent == "専門学生") {
      document.getElementById('user-affiliation').classList.add('professional-students');
    } else if (affiliation.textContent == "社会人") {
      document.getElementById('user-affiliation').classList.add('working');
    } else if (affiliation.textContent == "その他") {
      document.getElementById('user-affiliation').classList.add('other');
    }
  }
});
