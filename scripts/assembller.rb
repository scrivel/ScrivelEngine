
dir = File.expand_path(File.dirname(__FILE__))
parser = File.expand_path(dir+"/../ScrivelEngine/SEScriptParser.m")

head = <<"HEAD"

//
//  SEScriptAssemblerDelegate.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/15.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>

@protocol SEScriptAssemblerDelegate <NSObject>
@optional

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

f = open(File.dirname(parser)+"/SEScriptAssemblerDelegate.h", "w")
f.write head + methods.join("\n") + tail
f.close