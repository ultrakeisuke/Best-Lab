// 親カテゴリーを選択した際に子カテゴリーが動的に変化する処理
$(function () {
  $('#parent_category').change(function () {
    parentCategoryID = document.getElementById('parent_category').value;
    $.ajax({
      url: 'get_children_categories',
      type: 'GET',
      data: { parent_category_id: parentCategoryID }
    });
  });
});
