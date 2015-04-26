# lua-object
Prototype-based OOP library for Lua (compatible with LuaJIT)

The project is aimed to provide easy to use library for objects in Lua.

Main features
* Single inheritance
* Traits
* LuaJIT support

## extend(traits..., initializer) method

This is the core method of lua-object library, it extends the existing object by applying traits and initializer.
Actually, the "classes" bellow are objects in terms of Prototype-base object oriented programming.

```lua
-- require object module
local object = require("object")

-- define simple class
local HelloClass = object:extend(function(class)
 -- class constructor
 function class:init(name)
  self.name = name
 end
 
 -- class method
 function class:sayHello()
  print("Hello " .. self.name)
 end
end)

local hello = HelloClass:new("John")
hello:sayHello()
```

## Object variables and constants ##
You can define your variables or constants in the beginning of initializer.

```lua
local object = require("object")
local Status = object:extend(function(status)
 status.HTTP_200_OK = {200, "OK"}
 status.HTTP_405_METHOD_NOT_ALLOWED = {404, "Method not allowed"}
end)

print(Status.HTTP_200_OK[2])
```

## Static methods ###
A static method does not receive an implicit first argument. To declare a static method, use this idiom
```lua
local object = require("object")
local MathUtils = object:extend(function(class)
 function class.square(x)
  return x * x
 end
end)

-- call static method from class
print(MathUtils.square(10))

-- call the same method from class instance
print(MathUtils:new().square(10)) -- 100
```

## Instantiation and Constructor ##
An object instance is created from a class through the a process called instantiation.

Using lua-object this takes place through the new() method. This methods creates a new instance of specified class and calls constructor if it's defined

```lua
local Counter = object:extend(function(class)
 -- class constructor
 function class:init(initial)
  self.ticks = initial or 0
 end
 
 function class:tick()
  self.ticks = self.ticks + 1
 end
 
 function class:getTicks()
  return self.ticks
 end
end)

local c = Counter:new()
c.tick()
c.tick()
print(c.getTicks() == 2)
```

## Inheritance and method overriding ##
The library provides single inheritance paradigm for objects, a common form of inheritance, classes have only one base class.

In terms of lua-object the base class is object.
```lua
local Shape = object:extend(function(class)
 function class:getArea()
  return 0
 end
end)

local Square = object:extend(function(class)
 function class:init(side)
  self.side = side
 end
 
 -- override getArea method
 function class:getArea()
  return self.side * self.side
 end
end)

local sq = Square:new(10)
print("Area = " .. sq:getArea())
```

## Calling parent class methods ##
You are able to call parent class methods using the secondary argument in your class initializer

```lua
local Foo = object:extend(function(class)
 function class:init(value)
  self.value = value
 end
 
 function class:say()
  print("Hello " .. self.value)
 end
end)

class Bar = Foo:extend(function(class, parent)
 function class:init(value)
  -- call parent constructor
  parent.init(self, value)
 end
end)

local foo = Foo:new("World")
foo:say() -- prints "Hello World"

local bar = Bar:new("World")
bar:say() -- prints "Hello World"
```

## Traits ##
In computer programming, a trait is a concept used in object-oriented programming: a trait represents a collection of methods, that can be used to extend the functionality of a class. Essentially a trait is similar to a class made only of concrete methods that is used to extend another class with a mechanism similar to multiple inheritance, but paying attention to name conflicts, hence with some support from the language for a name-conflict resolution policy to use when merging. (from Wikipedia)

lua-object supports traits which have to be defined as functions passed to extend method

```lua
local TraitX = function(trait)
  function trait:setX(x)
   self.x = x
   return self
  end
  function trait:getX()
   return self.x
  end
end

local A = object:extend(TraitX, function(class)
  function class:say()
    print(self.x)
  end
end)

A:new():setX(10):say()
```

## is_instanceof(instance, class) method ##

is_instanceof(instance, class)

Returns true if the instance argument is an instance of the class argument, or of a (direct or indirect) subclass thereof.

```lua
local ClassA = object:extend()
local ClassB = object:extend()

local obj_a = ClassA:new()
local obj_b = ClassB:new()

print(obj_a:is_instanceof(ClassA)) -- true
print(obj_a:is_instanceof(object)) -- true
print(obj_a:is_instanceof(ClassB)) -- false
```

## is_typeof(instance, class) method ##

is_typeof(instance, class)

Returns true if the instance argument is a direct instance of the class argument.

```lua
local ClassA = object:extend()
local ClassB = object:extend()

local obj_a = ClassA:new()
local obj_b = ClassB:new()

print(obj_b:is_typeof(ClassA)) -- false
print(obj_b:is_typeof(ClassB)) -- true
```
