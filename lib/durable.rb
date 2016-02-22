###################################
#Durable Version 1.0
#Copyright (c) 2016 Philipp Sippl
#Released under MIT License (MIT)
###################################

at_exit do
  Durable.commitAndExit
end

class Durable
  @@DURABLE_HOME = ".DURABLE_HOME"
  @@DURABLE_PREFIX = "."
  @@AUTOCOMMIT_MODE = true
  @@instances = []

  @key = nil
  @val = nil
  @initial = nil
  attr_accessor :val

  def self.config(config)
    @@AUTOCOMMIT_MODE = config[:autocommit] if config[:autocommit] != nil
    @@DURABLE_HOME = config[:home] if config[:home] != nil
  end

  def self.commitAndExit
    self.commit if @@AUTOCOMMIT_MODE
  end

  def self.commit
    @@instances.map{|x| x.commit}
  end

  def commit
    tmp = {:initial => @initial, :new => @val}
    self.store_helper(@key, tmp)
  end

  def store_helper(key, val)
    Dir.mkdir(@@DURABLE_HOME) if !Dir.exists? @@DURABLE_HOME
    f = File.new(@@DURABLE_HOME+"/"+@@DURABLE_PREFIX+key.to_s, "w")
    f.print(Marshal::dump(val));
    f.close
  end

  def load_helper(key)
    if(self.key_exists(key))
        Marshal::load(File.read(@@DURABLE_HOME+"/"+@@DURABLE_PREFIX+key.to_s))
    else
      nil
    end
  end

  def key_exists(key)
    File.exist? @@DURABLE_HOME+"/"+@@DURABLE_PREFIX+key.to_s
  end

  def compare_helper(o1, o2)
    return Marshal::dump(o1) == Marshal::dump(o2)
  end

  def clone_helper(o)
    begin
      #will fail on fixnums
      o.clone
    rescue
      o
    end
  end

  def initialize(obj)
    @@instances << self
    @key = obj.keys[0]

    if(self.key_exists(@key) && compare_helper(self.load_helper(obj.keys[0])[:initial], obj[@key]) )
      loaded = self.load_helper(obj.keys[0])
      @val = loaded[:new]
      @initial = loaded[:initial]
    else
      @val = obj[@key]
      @initial = clone_helper(obj[@key])
      tmp = {:initial => @initial, :new => @val}
      self.store_helper(@key, tmp)
    end
  end

end
