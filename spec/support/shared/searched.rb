shared_examples_for "Searched" do
  it 'for class' do
    expect(ThinkingSphinx).to receive(:search).with('text text', classes: classes)
    Search.by_condition(condition, 'text text')
  end
end