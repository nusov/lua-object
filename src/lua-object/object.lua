--
-- Project: lua-object
-- objects for Lua
--
-- Copyright 2015 Alexander Nusov. Licensed under the MIT License.
-- See @license text at http://www.opensource.org/licenses/mit-license.php
--

local object = {}

function object:__getinstance(___instanceof)
  o = setmetatable({___instanceof=___instanceof or nil}, self)
  self.__index = self
  return o
end

function object:init()
end

function object:new(...)
  o = self:__getinstance(self)
  o:init(...)
  return o
end

function object:extend(...)
  cls = self:__getinstance(self)
  cls.init = function() end

  for k, f in pairs{...} do
    f(cls, self)
  end
  return cls
end

function object.is_typeof(instance, class)
  return instance ~= nil and (instance.___instanceof == class)
end

function object.is_instanceof(instance, class)
  return instance ~= nil and (instance.___instanceof == class or object.is_instanceof(instance.___instanceof, class))
end

return object
