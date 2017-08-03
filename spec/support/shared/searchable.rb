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
      datas.each do |data|
        within ".search-results > .#{data[:model].downcase}" do
          data[:objects].each do |object|
            expect(page).to have_content object.send(data[:attr])
          end
        end
      end
    end
  end
end