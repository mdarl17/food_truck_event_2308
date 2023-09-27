require 'pry-nav'

class FoodTruck
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    return 0 if !@inventory[item]
    @inventory[item]
  end

  def stock(item, qty)
    @inventory[item] += qty
  end

  def potential_revenue
    revenue = 0
    @inventory.each do |item, qty|
      revenue += item.price * qty
    end
    revenue
  end
end