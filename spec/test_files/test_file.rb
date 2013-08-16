class Animal

  attr_accessor :name

  def initialize(name = "Steve")
    self.name = name
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
    a + b
  end

  def add_two(a)
    a = a + 2
    a
  end

  def legs
    4
  end

  def owner
    @owner
  end

  def owner?
    owner ? true : false
  end

  def fight
    "fighting!"
  end

  def fight!
    @fighting = true
    "fighting!"
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

4 < 5

class Dog < Animal

  include Tail

  attr_writer :leash
  attr_reader "tail_state"

  DOGHOUSE = "roomy"

  def initialize name
    @tail_state = "tired"
    super
  end

  def block_door &block
    yield
  end

  def bark *args
    args.size
    multiply *args
  end

  def rename name
    self.name = name
  end

  def name_via_method
    name
  end
end

dog = Dog.new

dog.name

dog.wag

bark_results = dog.bark 2, 3

animals = []
animals << Animal.new
animals.push Animal.new

dog.multiply 4, 4

dog.leash = "a blue one"

dog.leash ||= "a red one"

house = Dog::DOGHOUSE

animals.each{ |animal| animal.sound }
animals.each do |animal|
  animal.say_name
end

hash = { dog: dog, animal: animals.first }
hash = { "dog" => dog, "animal" => animals.first() }
hash = { 5 => dog, "animal" => animals.first() }
hash2 = { dog => animals.first() }

array = [1, 3,4,"what",'what']

lambda = -> x { x.inspect }
proc = Proc.new { |x| x.inspect }

begin
  dog.meow
rescue
  "that's not a thing you're allowed to do"
ensure
  "please don't do that again"
end

nil if dog

cat unless dog

if dog.respond_to? :meow
  dog.meow
elsif dog.kind_of? Dog
  dog.bark
else
  dog.wag
end

unless dog
  cat
end

animals.map(&:fight)
animals.map &:fight
