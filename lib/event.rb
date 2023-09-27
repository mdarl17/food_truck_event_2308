require './lib/item'
require './lib/food_truck'
require './lib/event'
require 'date'

class Event
  attr_reader :name, :food_trucks, :date

  def initialize(name)
    @name = name
    @food_trucks = []
    @date = create_date
  end

  def add_food_truck(truck)
    @food_trucks << truck
  end

  def food_truck_names
    @food_trucks.map do |truck|
      truck.name
    end
  end

  def food_trucks_that_sell(item_str)
    @food_trucks.find_all do |truck|
      truck.check_stock(item_str) > 0
    end
  end

  def get_item_qty(item)
    count = 0
    food_trucks_that_sell(item).each do |truck|
      count += truck.check_stock(item)
    end
    count
  end

  def total_inventory
    item_qty_trucks = {}
    @food_trucks.each do |truck|
      truck.inventory.each do |item, qty|
        qty_trucks = {
          quantity: get_item_qty(item),
          food_trucks: food_trucks_that_sell(item)
        }
        item_qty_trucks[item] = qty_trucks
      end
    end
    item_qty_trucks
  end

  def overstocked_items
    overstocked_items = []
    total_inventory.each do |item, qty_trucks_hash|
      if  qty_trucks_hash[:quantity] > 50
        overstocked_items << item
      end
    end
    overstocked_items
  end

  def sorted_items_list
    sorted_item_names = total_inventory.keys.sort do |item1, item2|
      item1.name <=> item2.name
    end.map do |item|
      item.name
    end
    sorted_item_names
  end

  def create_date
    today = Date.today
    today.strftime('%d/%m/%Y')
  end

  def sell(item, qty)
    trucks_selling_item = food_trucks_that_sell(item)
    
    return false if trucks_selling_item.length == 0 || total_inventory[item][:quantity] < qty

    def fill_order(qty, trucks, item)

      return false if trucks.length == 0

      cur_truck = trucks[0]
      qty_in_stock = cur_truck.inventory[item]

      if qty_in_stock >= qty
        cur_truck.inventory[item] -= qty
        return true
      else
        order_unfilled = qty - qty_in_stock
        cur_truck.inventory[item] = 0
        fill_order(order_unfilled, trucks[1..-1], item)
      end
    end
    fill_order(qty, trucks_selling_item, item)
  end
end
