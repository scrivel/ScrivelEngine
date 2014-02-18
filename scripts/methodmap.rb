require "json"

out = File.expand_path(File.dirname(__FILE__)+"/../Resources/map.json")
path = File.expand_path(File.dirname(__FILE__)+"/../ScrivelEngine/Protocols")
# p path
hash = {}
Dir.chdir path
Dir.glob("*.h"){|f|
  name = File.basename f, ".h"
  p f
  method = /@method[^a-z]*([a-z]+)\n/i
  selector = /[+-] ?(.+);/
  str = open(f).read

  methods = []
  selectors = []

  str.gsub(method){|m|
    methods << m.match(method)[1]
  }

  str.gsub(selector){|m|
    s = m.match(selector)[1]
    _s = ""
    unless s.match ":"
      _s = s.match(/\(.+\)([a-z]+)/)[1]
    else
      s.gsub(/[a-z]+:/i){|n|
        _s += n
      }
    end
    selectors << _s
  }

  # p methods
  # p selectors

  # p "#{methods.length} methods, #{selectors.length} selectors"

  if methods.length == selectors.length
    ary = [methods,selectors].transpose
    hash[name] = Hash[*[ary].flatten]
  else
    $stderr << "syntax error"
    exit 2
  end
}
open(out ,"w"){|f| f.write JSON.pretty_generate hash }
p "#{out} generated."
exit 0
