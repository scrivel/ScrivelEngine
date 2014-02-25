require "json"

out = File.expand_path(File.dirname(__FILE__)+"/../Resources/map.json")
path = File.expand_path(File.dirname(__FILE__)+"/../ScrivelEngine/Protocols")
proxy_path = File.expand_path("./ScrivelEngine/SEBasicClassProxy.m")

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
      _s = s.match(/\(.+\)([a-z]+)/i)[1]
    else
      s.gsub(/[a-z_]+:/i){|n|
        _s += n
      }
    end
    selectors << _s
  }

  # p methods
  # p selectors

  # p "#{methods.length} methods, #{selectors.length} selectors"
  clazz = str.match(/\/\*.*@class ([a-z]+)/im)[1]
  if methods.length == selectors.length
    ary = [methods,selectors].transpose
    hash[clazz] = Hash[*[ary].flatten]
  else
    $stderr << "syntax error"
    exit 2
  end
}
open(out ,"w"){|f| f.write JSON.pretty_generate hash }
p "#{out} generated."


class_for_class = ""
sel_for_method = ""

hash.each do |cls, methods|
  # sel_for_method += "if ([classIdentifier isEqualToString:@\"#{cls}\"]) {\n\n"
  sel_for_method += "\n\t// #{cls}\n\n"
  methods.each do |key, val|
    sel_for_method += "\tSEL_FOR_METHOD(@\"#{key}\",#{val});\n"
  end
  # sel_for_method += "\n}\n"
end


tmp = <<"EOS"

#import "SEBasicClassProxy.h"
#import "SEBasicApp.h"
#import "SEBasicObject.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"

@implementation SEBasicClassProxy

#define SEL_FOR_METHOD(_m,_s) if([methodIdentifier isEqualToString:_m]) return @selector(_s)

- (Class)classForClassIdentifier:(NSString *)classIdentifier
{
    if ([classIdentifier isEqualToString:@"app"]) {
        return [SEBasicApp class];
    }else if ([classIdentifier isEqualToString:@"layer"]) {
        // レイヤー
        return [SEBasicLayerClass class];
    }else if ([classIdentifier isEqualToString:@"chara"]){
        // キャラ
    }else if ([classIdentifier isEqualToString:@"bg"]){
        // 背景
    }else if ([classIdentifier isEqualToString:@"text"]){
        // テクストフレーム
        return [SEBasicTextLayerClass class];
    }else if ([classIdentifier isEqualToString:@"ui"]){
        // UI
    }else if ([classIdentifier isEqualToString:@"bgm"]){
        // BGM
    }else if ([classIdentifier isEqualToString:@"se"]){
        // SE
    }
    return nil;
}

- (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier
{
#{sel_for_method}

    return nil;
}

@end

EOS

open(proxy_path,"w").write(tmp)
exit 0