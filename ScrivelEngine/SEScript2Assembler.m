//
//  SEScript2Assembler.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript2Assembler.h"
#import "Stack.h"

@implementation SEScript2Assembler
{
    Stack *_WsStack;
    Stack *_AnimateSymStack;
    Stack *_DoSymStack;
    Stack *_CreateSymStack;
    Stack *_DeleteSymStack;
    Stack *_SetSymStack;
    Stack *_WaitSymStack;
    Stack *_LayerSymStack;
    Stack *_CharacterSymStack;
    Stack *_TextSymStack;
    Stack *_AnimationSymStack;
    Stack *_TapSymStack;
    Stack *_WordsSymStack;
    Stack *_PxSymStack;
    Stack *_VpxSymStack;
    Stack *_PercentSymStack;
    Stack *_ScriptStack;
    Stack *_ElementStack;
    Stack *_WordsStack;
    Stack *_StepStack;
    Stack *_TargetStepStack;
    Stack *_AnimateStepStack;
    Stack *_AnonymousStepStack;
    Stack *_ObjectStepStack;
    Stack *_ObjectIdentifierStack;
    Stack *_SetStepStack;
    Stack *_DoStepStack;
    Stack *_WaitStepStack;
    Stack *_WaitIdentifierStack;
    Stack *_ArgumentsStack;
    Stack *_ArgumentStack;
    Stack *_ValueStack;
    Stack *_UnitValueStack;
    Stack *_UnitStack;
    Stack *_PointStack;
    Stack *_RectStack;
    Stack *_IdentifierStack;
}

- (id)init
{
    self = [super init];
    _WsStack = [Stack new];
    _AnimateSymStack = [Stack new];
    _DoSymStack = [Stack new];
    _CreateSymStack = [Stack new];
    _DeleteSymStack = [Stack new];
    _SetSymStack = [Stack new];
    _WaitSymStack = [Stack new];
    _LayerSymStack = [Stack new];
    _CharacterSymStack = [Stack new];
    _TextSymStack = [Stack new];
    _AnimationSymStack = [Stack new];
    _TapSymStack = [Stack new];
    _WordsSymStack = [Stack new];
    _PxSymStack = [Stack new];
    _VpxSymStack = [Stack new];
    _PercentSymStack = [Stack new];
    _ScriptStack = [Stack new];
    _ElementStack = [Stack new];
    _WordsStack = [Stack new];
    _StepStack = [Stack new];
    _TargetStepStack = [Stack new];
    _AnimateStepStack = [Stack new];
    _AnonymousStepStack = [Stack new];
    _ObjectStepStack = [Stack new];
    _ObjectIdentifierStack = [Stack new];
    _SetStepStack = [Stack new];
    _DoStepStack = [Stack new];
    _WaitStepStack = [Stack new];
    _WaitIdentifierStack = [Stack new];
    _ArgumentsStack = [Stack new];
    _ArgumentStack = [Stack new];
    _ValueStack = [Stack new];
    _UnitValueStack = [Stack new];
    _UnitStack = [Stack new];
    _PointStack = [Stack new];
    _RectStack = [Stack new];
    _IdentifierStack = [Stack new];
    return self;
}

- (void)parser:(PKParser*)parser didMatchWs:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchAnimateSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchDoSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchCreateSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchDeleteSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchSetSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchWaitSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchLayerSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchCharacterSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchTextSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchAnimationSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchTapSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchWordsSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchPxSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchVpxSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchPercentSym:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchTargetStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchAnimateStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchAnonymousStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchObjectStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchObjectIdentifier:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchSetStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchDoStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchWaitStep:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchWaitIdentifier:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchArgument:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchUnitValue:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchUnit:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchPoint:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchRect:(PKAssembly*)assembly
{
}

- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly
{
}


@end
