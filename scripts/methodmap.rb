require "json"
require "plist"

out = File.expand_path("Resources/map.json")
path = File.expand_path("ScrivelEngine/Protocols")
proxy_path = File.expand_path("ScrivelEngine/SEBasicClassProxy.m")
plist_path = File.expand_path("External/Fragaria/Syntax Definitions/sescript.plist")

plist = Plist::parse_xml(plist_path)

# p path
hash = {}
hierarchy = {}

["SEObject.h","SEApp.h","SELayer.h","SETextLayer.h","SECharacterLayer.h"].each{|h|
  f = File.expand_path(path+"/"+h)
  name = File.basename f, ".h"
  str = open(f).read

  clazz = str.match(/\/\*.*@class ([a-z]+)/im)[1]
  extends = str.match(/@extends[^a-z]*([a-z]+)\n/i)
  extends = extends[1] if extends
  method = /@method[^a-z]*([a-z]+)\n/i
  selector = /[+-] ?(.+);/

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
  if methods.length == selectors.length
    ary = [methods,selectors].transpose
    hash[clazz] = {}
    hash[clazz]["methods"] = Hash[*[ary].flatten]
    hash[clazz]["extends"] = extends ? extends : ""
  else
    $stderr << "syntax error"
    exit 2
  end
}

open(out ,"w"){|f| f.write JSON.pretty_generate hash }
p "#{out} generated."

hash.each do |c,props|
  plist["autocompleteWords"] << c unless plist["autocompleteWords"].index(c)
  props["methods"].each do |method,sel|
      plist["autocompleteWords"] << method unless plist["autocompleteWords"].index(method)
  end
end

plist.save_plist plist_path

class_for_class = ""
sel_for_method = ""

hash.each do |cls, obj|
  sel_for_method += "\tif ([classIdentifier isEqualToString:@\"#{cls}\"]) {\n"
  sel_for_method += "\t\t// #{cls}\n\n"
  # 継承先を追加
  ext = obj
  ce = cls
  while ext
    sel_for_method += "\t\t// inherited from #{ce}\n"
    ext["methods"].each do |key, val|
      sel_for_method += "\t\tSEL_FOR_METHOD(@\"#{key}\",#{val});\n"
    end
    ce = ext["extends"]
    ext = hash[ce]
  end
  sel_for_method += "\n\t}\n"
end


tmp = <<"EOS"

#import "SEBasicClassProxy.h"
#import "SEBasicApp.h"
#import "SEBasicObject.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"
#import "SEBasicCharacterLayer.h"

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
        return [SEBasicCharacterLayerClass class];
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

- (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier classIdentifier:(NSString *)classIdentifier
{
#{sel_for_method}

    return nil;
}

@end

EOS

open(proxy_path,"w").write(tmp)
exit 0