
dir = File.expand_path(File.dirname(__FILE__))

Dir.chdir("ScrivelEngine")
Dir.glob("*Parser.m"){|parser|
  head = <<"HEAD"

@class PKParser, PKAssembly;
@protocol #{File.basename(parser,".m")}Delegate <NSObject>
@required

HEAD

  tail = <<"TAIL"


@end

TAIL

  methods = []
  open(parser){|f|
    while l = f.gets
      m = l.match /@selector\((parser:did(.+):)\)/
      if m
        # p m[1] if m
        p m[2] if m
        methods << "- (void)parser:(PKParser*)parser did#{m[2]}:(PKAssembly*)assembly;"
      end
    end
    # p methods
  }
  h = File.basename(parser,".m") + ".h"
  a = open(File.expand_path(h), "a")
  p a
  a.write head + methods.join("\n") + tail
  a.close
  p parser
}
