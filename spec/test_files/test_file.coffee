class Animal

  name: =>
    @_name

  constructor: (name) ->
    name ?= "Steve"
    @_name = name

  say_name: =>
    @_name

  sound: =>
    "roar!"

  multiply: (a, b) =>
    a * b

  add: (a, b) =>
    a + b

  add_two: (a) =>
    a = a + 2
    a

  legs: =>
    4

  owner: =>
    @_owner

  owner_present: =>
    `this.owner() ? true : false`

  fight: =>
    "fighting!"

  fight_bang: =>
    @_fighting = true
    "fighting!"

  @count: =>
    "There are some animals, probably"

class Tail

  wag: =>
    "wagging tail"

4 < 5

class Dog extends Animal

  @include(Tail)

  tail_state: =>
    @_tail_state

  @DOGHOUSE = "roomy"

  constructor: (name) ->
    @tail_state = "tired"
    super(args...)

  block_door: (block) =>
    block()

  bark: (sound, args...) =>
    args.size()
    @multiply(args...)
    sound

  rename: (name) =>
    @_name = name

  name_via_method: =>
    @_name

dog = Dog.new

dog.name

dog.wag()

bark_results = dog.bark 2, 3

animals = []
animals.push(Animal.new)
animals.push(Animal.new)

dog.multiply(4, 4)

dog.leash = "a blue one"

dog.leash ?= "a red one"

house = Dog.DOGHOUSE

animals.each (animal) -> animal.sound
animals.each((animal) ->
  animal.say_name
)

hash = { dog: dog, animal: animals.first() }
hash = { "dog": dog, "animal": animals.first() }
hash = { "5": dog, "animal": animals.first() }
hash2 = {}
hash2[dog] = animals.first()

array = [1, 3,4,"what",'what']

lambda = (x) -> x.inspect
proc = (x) ->  x.inspect

try
  dog.meow()
catch
  "that's not a thing you're allowed to do"
finally
  "please don't do that again"

null if dog?

cat unless dog?

if (dog.respond_to_present(meow))?
  dog.meow()
else if (dog.kind_of_present(Dog))?
  dog.bark()
else
  dog.wag()

unless dog?
  cat

animals.map((x) -> x["fight"]())
animals.map((x) -> x["fight"]())









