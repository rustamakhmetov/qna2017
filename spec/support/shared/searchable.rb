shared_examples_for "Searchable" do
  scenario 'find objects', js: true do
    ThinkingSphinx::Test.run do
      index
      visit questions_path
      within '.search' do
        fill_in 'query', with: query
        select condition, from: :condition
        click_on 'Search'
        wait_for_ajax
      end
      data.each do |value|
        within ".search-results" do
          value[:objects].each do |object|
            expect(page).to have_content object.send(value[:attr])
          end
        end
      end
    end
  end
end