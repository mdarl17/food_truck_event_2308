require './lib/item'
require './lib/food_truck'
require './lib/event'
require 'date'

RSpec.describe Event do
  before(:each) do 
    @event = Event.new("South Pearl Street Farmers Market")
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: "Matt\'s Frozen Treats", price: "$10.25"})
    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")
    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)
  end

  describe '#initialize' do 
    it 'exists' do
      expect(@event).to be_a(Event)
    end
    it 'has a name' do 
      expect(@event.name).to eq("South Pearl Street Farmers Market")
    end
  end

  describe '#add_food_truck' do
    it 'adds food trucks to the event' do
      expect(@event.food_trucks).to eq([])

      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)

      expect(@event.food_trucks).to eq([@food_truck1, @food_truck2, @food_truck3])
    end
  end

  describe '#food_truck_names' do 
    it 'keeps a list of the names of food trucks at the event' do
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)

      expect(@event.food_truck_names).to eq(["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
  end
  describe '#food_trucks_that_sell' do
    it 'keeps track of what the food trucks sell' do
      event = Event.new("South Pearl Street Farmers Market")
      item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
      item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
      item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
      item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
      food_truck1 = FoodTruck.new("Rocky Mountain Pies")
      food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
      food_truck3 = FoodTruck.new("Palisade Peach Shack")
      food_truck1.stock(item1, 35)
      food_truck1.stock(item2, 7)
      food_truck2.stock(item4, 50)
      food_truck2.stock(item3, 25)
      food_truck3.stock(item1, 65)
      event.add_food_truck(food_truck1)
      event.add_food_truck(food_truck2)
      event.add_food_truck(food_truck3)

      expect(event.food_trucks_that_sell(item1)).to eq([food_truck1, food_truck3])
    end
  end

    describe 'total_inventory' do 
      it 'keeps track of the food trucks and the total inventory among the trucks' do

        @event.add_food_truck(@food_truck1)
        @event.add_food_truck(@food_truck2)
        @event.add_food_truck(@food_truck3)

        expected = {
          @item1 => {
            quantity: 100,
            food_trucks: [@food_truck1, @food_truck3]
          },
          @item2 => {
            quantity: 7,
            food_trucks: [@food_truck1]
          },
          @item4 => {
            quantity: 50,
            food_trucks: [@food_truck2]
          },
          @item3 => {
            quantity: 25,
            food_trucks: [@food_truck2]
          }
        }

        expect(@event.total_inventory).to eq(expected)
      end
    end

  describe '#overstocked_items' do 
    it 'calculates overstocked inventory' do
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)

      expect(@event.overstocked_items).to eq([@item1])
    end
  end

  describe '#sorted_item_list' do
    it 'keeps a sorted list of food item names' do 
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)

      expect(@event.sorted_items_list).to eq(['Apple Pie (Slice)', "Banana Nice Cream", 'Peach Pie (Slice)', "Peach-Raspberry Nice Cream"])
    end
  end

  describe '#date' do
    it 'records the date when an instance of event is created' do
      event = Event.new("South Pearl Street Farmers Market")

      date_mock = double(event.date)

      allow(date_mock).to receive(:today).and_return('24/02/2023')
    end
  end
    
  describe 'sell' do
    it 'can keep track of sold items and update inventory' do
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)
      @event.sell(@item1, 40)
      expect(@event.sell(@item1, 200)).to eq(false)
      expect(@event.sell(@item5, 1)).to eq(false)
      expect(@event.sell(@item4, 5)).to eq(true)
      expect(@food_truck2.check_stock(@item4)).to eq(45)
      @food_truck1.stock(@item1, 35)
      @food_truck3.stock(@item1, 5)
      expect(@event.sell(@item1, 40)).to eq(true)
      expect(@food_truck1.check_stock(@item1)).to be(0)
      expect(@food_truck3.check_stock(@item1)).to be(60)
    end
  end
end