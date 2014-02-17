//
//  SEClassProxy.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

// sescriptのクラスメソッドコールをobjcにプロクシーするクラス
// サブクラス化して使う

@class SEMethod;
@interface SEClassProxy : NSObject

- (Class)classForClassIdentifier:(NSString*)classIdentifier;

@end
