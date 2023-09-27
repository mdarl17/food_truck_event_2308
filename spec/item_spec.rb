require './lib/item'

RSpec.describe Item do
    before(:each) do 
      @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
      @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    end
  describe '#initialize' do 
    it 'exists' do 
      expect(@item1).to be_a(Item)
    end
  end

  describe '#attributes' do
    it 'has attributes' do 
      expect(@item1.name).to eq('Peach Pie (Slice)')
      expect(@item2.price).to eq(2.50)
    end
  end
end