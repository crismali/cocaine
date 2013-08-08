class Animal

  attr_accessor :name

  def initialize(name = nil)
    self.name = nil
  end

  def say_name
    @name
  end

  def sound
    "roar!"
  end

  def multiply a, b
    a * b
  end

  def add(a, b)
    1 + 2
  end

  def legs
    4
  end

  def self.count
    "There are some animals, probably"
  end

end

module Tail

  def wag
    "wagging tail"
  end

end

class Dog < Animal

  include Tail

  attr_writer :leash
  attr_reader :tail_state

  DOGHOUSE = "roomy"

  def initialize
    @tail_state = "tired"
  end

  def block_door &block
    yield
  end

  def bark *arguments
    arguments.size
    multiply *arguments
  end
end

dog = Dog.new

dog.wag

bark_results = dog.bark 2, 3

animals = []
animals << Animal.new
animals.push Animal.new

dog.multiply 4, 4

dog.leash = "a blue one"

dog.leash ||= "a red one"

house = DOGHOUSE

animals.each{ |animal| animal.sound }
animals.each do |animal|
  animal.say_name
end

hash = { dog: dog, animal: animals.first }

array = [1, 3,4,"what",'what']

lambda = -> x { x.inspect }

begin
  dog.meow

rescue NoMethodError
  puts "that's not a thing you're allowed to do"
end
