f = ARGV.shift
methods = "";
inherit = "NSObject";
open(f){|file|
  while l = file.gets
    if match = l.match(/([+-] ?\(.+\)[^;]+?);/)
      p match[1]
      methods += "#{match[1]}\n{\n\t\n}\n\n"
    end
    if match = l.match(/@protocol.+<(.+)>/)
      inherit = "SEConcret"+match[1].gsub("SE","")
      p inherit
    end
  end
}

# SEObject.h -> SEObject
fn = File.basename f, ".h"
# SEObject -> SEConcretObject
cn = "SEConcret"+fn.gsub("SE","")

h = <<"EOS"

//
//  _#{cn}.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "#{inherit}.h"
#import "#{fn}.h"

@interface #{cn} : #{inherit} <#{fn}>

@end

EOS

m = <<"EOS"

//
//  _#{cn}.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "#{cn}.h"

@implementation #{cn}

#{methods}

@end

EOS

b = "ScrivelEngine/"+ cn
p b
open(b+".h","w").write(h)
open(b+".m","w").write(m)
