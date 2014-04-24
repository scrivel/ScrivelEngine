
dir = File.expand_path(File.dirname(__FILE__))
parser = File.expand_path(dir+"/../ScrivelEngine/SEScript2Parser.m")

head = <<"HEAD"

@class PKParser, PKAssembly;
@protocol SEScript2ParserDelegate <NSObject>
@required

HEAD

tail = <<"TAIL"


@end

TAIL

methods = []
elements = []
open(parser){|f|
  while l = f.gets
    m = l.match /@selector\((parser:did(.+):)\)/
    if m
      # p m[1] if m
      p m[2] if m
      elements << m[2]
      methods << "- (void)parser:(PKParser*)parser did#{m[2]}:(PKAssembly*)assembly;"
    end
  end
  # p methods
}

f = open(File.dirname(parser)+"/SEScript2Parser.h", "a")
f.write head + methods.join("\n") + tail
f.close



