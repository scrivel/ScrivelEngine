//
//  SEScript2Assembler.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript2Assembler.h"
#import "SEWords2.h"
#import "Stack.h"
#import "SECreateStep.h"
#import "SEDeleteStep.h"
#import "SEAnimationStep.h"
#import "SESetStep.h"
#import "SEWaitStep.h"
#import "SEDoStep.h"
#import "SEScript2.h"

#define PUSH_STR(stack)\
id str = [[assembly pop] stringValue];\
[stack push:str];

#define PUSH_IF(from, to)\
if ((push = [from pop]) != nil){ [to push:push]; return; }

@interface NSString(Dequote)

- (NSString*)dequotedString;

@end

@implementation NSString(Dequote)

- (NSString*)dequotedString
{
    char f = [self characterAtIndex:0];
    char l = [self characterAtIndex:self.length-1];
    if ((f == '"' && l == '"') || (f == '\'' && l == '\'')){
        return [self substringWithRange:NSMakeRange(1, self.length-2)];
    }
    return self;
}

@end

@implementation SEScript2Assembler
{    
    Stack *_ScriptStack;
    Stack *_ElementStack;
    Stack *_WordsStack;
    Stack *_SpeakerStack;
    Stack *_StepStack;
    Stack *_AnimateStepStack;
    Stack *_CreateStepStack;
    Stack *_LabelIdentifierStack;
    Stack *_DeleteStepStack;
    Stack *_ObjectIdentifierStack;
    Stack *_SetStepStack;
    Stack *_DoStepStack;
    Stack *_WaitStepStack;
    Stack *_WaitIdentifierStack;
    Stack *_ArgumentsStack;
    Stack *_ArgumentStack;
    Stack *_ValueStack;
    Stack *_BoolStack;
    Stack *_UnitValueStack;
    Stack *_PointStack;
    Stack *_SizeStack;
    Stack *_IdentifierStack;
}

- (id)init
{
    self = [super init];
    _ScriptStack = [Stack new];
    _ElementStack = [Stack new];
    _WordsStack = [Stack new];
    _SpeakerStack = [Stack new];
    _StepStack = [Stack new];
    _AnimateStepStack = [Stack new];
    _LabelIdentifierStack = [Stack new];
    _CreateStepStack = [Stack new];
    _DeleteStepStack = [Stack new];
    _ObjectIdentifierStack = [Stack new];
    _SetStepStack = [Stack new];
    _DoStepStack = [Stack new];
    _WaitStepStack = [Stack new];
    _WaitIdentifierStack = [Stack new];
    _ArgumentsStack = [Stack new];
    _ArgumentStack = [Stack new];
    _ValueStack = [Stack new];
    _BoolStack = [Stack new];
    _UnitValueStack = [Stack new];
    _PointStack = [Stack new];
    _SizeStack = [Stack new];
    _IdentifierStack = [Stack new];
    return self;
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine
{
    self = [self init];
    _engine = engine;
    return self;
}

- (SEScript2 *)assemble
{
    return [_ScriptStack pop];
}

- (void)parser:(PKParser *)parser didMatchArrow:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchAnimateSym:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchDoSym:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchCreateSym:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchDeleteSym:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchSetSym:(PKAssembly *)assembly{};
- (void)parser:(PKParser *)parser didMatchWaitSym:(PKAssembly *)assembly{};

- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly
{
    SEScript2 *script = [[SEScript2 alloc] init];
    SEElement2 *element;
    while ((element = [_ElementStack pop])) {
        [[script elements] insertObject:element atIndex:0];
    }
    [_ScriptStack push:script];
}

- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly
{
    id push;
    PUSH_IF(_WordsStack, _ElementStack);
    PUSH_IF(_StepStack, _ElementStack);
    NSAssert(NO, @"こない");
}

- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly
{
    SEWords2 *words = [[SEWords2 alloc] init];
    NSString *speaker = [_SpeakerStack pop];
    words.speaker = speaker;
    NSMutableString *text = [NSMutableString new];
    NSString *str;
    while ((str = [[assembly pop] stringValue]) != nil) {
        [text appendString:str];
    }
    words.text = text;
    [_WordsStack push:words];
}

- (void)parser:(PKParser *)parser didMatchSpeaker:(PKAssembly *)assembly
{
    NSString *identifier = [_IdentifierStack pop];
    [_SpeakerStack push:identifier];
}

- (void)parser:(PKParser*)parser didMatchStep:(PKAssembly*)assembly
{
    id push;
    PUSH_IF(_AnimateStepStack, _StepStack);
    PUSH_IF(_SetStepStack, _StepStack);
    PUSH_IF(_WaitStepStack, _StepStack);
    PUSH_IF(_DoStepStack, _StepStack);
    PUSH_IF(_CreateStepStack, _StepStack);
    PUSH_IF(_DeleteStepStack, _StepStack);
    NSAssert(NO, @"こない");
}

- (void)parser:(PKParser*)parser didMatchAnimateStep:(PKAssembly*)assembly
{
    NSDictionary *arguments = [_ArgumentsStack pop];
    SEAnimationStep *as = [[SEAnimationStep alloc] initWithArguments:arguments];
    [_AnimateStepStack push:as];
}

- (void)parser:(PKParser *)parser didMatchCreateStep:(PKAssembly *)assembly
{
    NSDictionary *arguments = [_ArgumentsStack pop];
    SECreateStep *cs = [[SECreateStep alloc] init];
    cs.arguments = arguments;
    [_CreateStepStack push:cs];
}

- (void)parser:(PKParser *)parser didMatchDeleteStep:(PKAssembly *)assembly
{
    NSString *key = [_IdentifierStack pop];
    SEDeleteStep *ds = [[SEDeleteStep alloc] init];
    ds.targetKey = key;
    [_DeleteStepStack push:ds];
}

- (void)parser:(PKParser*)parser didMatchSetStep:(PKAssembly*)assembly
{
    NSDictionary *arguments = [_ArgumentsStack pop];
    SESetStep *ss = [[SESetStep alloc] init];
    ss.toKeyValues = arguments;
    [_SetStepStack push:ss];
}

- (void)parser:(PKParser*)parser didMatchDoStep:(PKAssembly*)assembly
{
    NSString *name = [_IdentifierStack pop];
    NSDictionary *arguments = [_ArgumentsStack pop];
    SEDoStep *dos = [[SEDoStep alloc] initWithName:name arguments:arguments];
    [_DoStepStack push:dos];
}

- (void)parser:(PKParser*)parser didMatchWaitStep:(PKAssembly*)assembly
{
    id waitIdentifier = [_WaitIdentifierStack pop];
    SEWaitStep *wait = [[SEWaitStep alloc] initWithWaitIdentifier:waitIdentifier];
    [_WaitStepStack push:wait];
}

- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly
{
    id arg;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    while ((arg = [_ArgumentStack pop]) != nil) {
        dict[arg[@"key"]] = arg[@"value"];
    }
    [_ArgumentsStack push:dict];
}

- (void)parser:(PKParser*)parser didMatchArgument:(PKAssembly*)assembly
{
    id key = [_IdentifierStack pop];
    id val = [_ValueStack pop];
    [_ArgumentStack push:@{@"key": key, @"value": val}];
}

- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly
{
    PKToken *push;
    PUSH_IF(_SizeStack, _ValueStack);
    PUSH_IF(_PointStack, _ValueStack);
    PUSH_IF(_UnitValueStack, _ValueStack);
    PUSH_IF(_BoolStack, _ValueStack);
    push = [assembly pop];
    if (push.isNumber) {
        [_ValueStack push:@([push floatValue])];
        return;
    }else if (push.isQuotedString){
        [_ValueStack push:[push.stringValue dequotedString]];
        return;
    }
    NSAssert(NO, @"こない");
}

- (void)parser:(PKParser *)parser didMatchBool:(PKAssembly *)assembly
{
    id str = [[assembly pop] stringValue];
    if ([str isEqualToString:@"yes"]) {
        [_BoolStack push:@(YES)];
        return;
    }else if ([str isEqualToString:@"no"]){
        [_BoolStack push:@(NO)];
        return;
    }
    NSAssert(NO, @"こない");
}

- (void)parser:(PKParser*)parser didMatchUnitValue:(PKAssembly*)assembly
{
    PKToken *tok = [assembly pop];
    NSString *unit = [_IdentifierStack pop];
    id uv = SEUnitValueMake([NSString stringWithFormat:@"%f%@",(CGFloat)[tok floatValue], unit]);
    [_UnitValueStack push:uv];
}

- (void)parser:(PKParser*)parser didMatchPoint:(PKAssembly*)assembly
{
    SEUnitValue *y = [_UnitValueStack pop];
    SEUnitValue *x = [_UnitValueStack pop];
    SEUnitPoint *point = [SEUnitPoint pointWithX:x y:y];
    [_PointStack push:point];
}

- (void)parser:(PKParser*)parser didMatchSize:(PKAssembly *)assembly
{
    SEUnitValue *h = [_UnitValueStack pop];
    SEUnitValue *w = [_UnitValueStack pop];
    SEUnitSize *size = [SEUnitSize sizeWithWidth:w height:h];
    [_SizeStack push:size];
}

- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly
{
    PUSH_STR(_IdentifierStack);
}


@end
