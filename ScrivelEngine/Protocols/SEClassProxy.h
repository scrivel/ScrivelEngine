//
//  SEClassProxy.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SEClassProxy

// クラス名に対するobjc上でのクラスを返す
- (Class)classForClassIdentifier:(NSString*)classIdentifier;
// クラス名とメソッド名に対するobjc上でのセレクターを返す
- (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier classIdentifier:(NSString *)classIdentifier;

@end
