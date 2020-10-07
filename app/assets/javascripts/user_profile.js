//所属ごとにテキストの背景色が変わる処理
window.onload = function () {
  var affiliation = document.getElementById('user_affiliation').textContent;
  if (affiliation == "大学生") {
    $('#user_affiliation').attr('class', 'undergraduate');
  } else {
    $('#user_affiliation').attr('class', 'graduate');
  }
}