// ハンバーガーメニュー押下時の処理
$(function () {
  var $header = $('#header');
  $('#nav-toggle').click(function () {
    $header.toggleClass('open');
  });
  // 灰色背景を押下すると解除
  $('#toggle-background').click(function () {
    $header.toggleClass('open');
  });
});
