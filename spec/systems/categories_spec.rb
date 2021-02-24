require 'rails_helper'

RSpec.feature '同一カテゴリーに属する質問一覧を表示', type: :system do
  
  let(:user) { create(:user) }
  let(:parent_category) { create(:parent_category) }
  let(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post1) { create(:post, user_id: user.id, category_id: children_category.id, title: "post1") }
  let!(:post2) { create(:post, user_id: user.id, category_id: children_category.id, title: "post2") }

  scenario '質問一覧の表示を確認' do
    visit questions_category_path(children_category)
    expect(page).to have_content "#{parent_category.name}"
    expect(page).to have_content "#{children_category.name}"
    expect(page).to have_content "post1"
    expect(page).to have_content "post2"
    click_on "post1"
    expect(page).to have_current_path(questions_post_path(post1))
  end

end
