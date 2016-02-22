#Durable

Durable is a very small (< 100 LOC) ruby gem that can make changes to objects and variables persistent. Usage is super easy and only few changes to your code are needed.
**Important: All data is only stored locally on disk.**

###Installation
```gem install durable```


###Minimal Example
```
require "durable"

x = Durable.new(:x => 1)
x.val += 1
p x.val
```

Result at first run ```2```

Result at second run ```3```

Result at third run ```4```
###Basic Usage

In order to use Durable just substitute your normal variable definition by following construct:

```
x = Durable.new(:x => 1)
```
or
```
hash = Durable.new(:hash => {"a"=>1, "b"=>2})
```





You can access the value by calling ```.val```
```
x.val #gives 1
```
```
hash.val["b"] #gives 2
```
Just use it as a normal variable
```
x.val += 1
```

**Commiting is automatically done (via exit hook) or can be explicitly forced via
```Durable.commit``` for all objects or via ```x.commit``` for a single object**

###Configuration
Turn off autocommit (by default turned on)

```Durable.config({:autocommit => false})```

Configure home directory for Durable to store the internal files

```Durable.config({:home => ".store"})```

###More Examples 
```
require 'durable'

Durable.config({:autocommit => true});

class Test
  attr_accessor :count
  def initialize
    @count = 1
  end
end


x = Durable.new(:x => Test.new)

x.val.count += 1

p x.val.count

Durable.commit #save changes
```

Result at first run ```2```

Result at second run ```3```

Result at third run ```4```

###Resetting
```rm -r .DURABLE_HOME``` should do it

###License
**MIT License**
