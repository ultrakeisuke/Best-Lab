// 親カテゴリーを選択した際に子カテゴリーが動的に変化する処理
$(function () {
  $('#parent_category').change(function () {
    var parentCategoryID = document.getElementById('parent_category').value;
    $.ajax({
      url: '/questions/posts/get_children_categories',
      type: 'GET',
      data: { parent_category_id: parentCategoryID },
    });
  });
});

// 検索フォームで親カテゴリーを選択した際に子カテゴリーが動的に変化する処理
$(function () {
  $('#parent_category_for_search').change(function () {
    var searchParentCategoryID = document.getElementById(
      'parent_category_for_search'
    ).value;
    $.ajax({
      url: '/searches/questions/get_children_categories_for_search',
      type: 'GET',
      data: { parent_category_id: searchParentCategoryID },
    });
  });
});
