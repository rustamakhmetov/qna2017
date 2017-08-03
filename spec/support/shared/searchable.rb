shared_examples_for "Searchable" do
  scenario 'find objects', js: true do
    ThinkingSphinx::Test.run do
      index
      visit questions_path
      within '.search' do
        fill_in 'query', with: query
        select model, from: :condition
        click_on 'Search'
        wait_for_ajax
      end
      within ".search-results > .#{model.downcase}" do
        objects.each do |object|
          expect(page).to have_content object.send(attr)
        end
      end
    end
  end
end