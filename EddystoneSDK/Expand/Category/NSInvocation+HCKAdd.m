//
//  NSInvocation+HCKAdd.m
//  FitPolo
//
//  Created by aa on 17/7/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "NSInvocation+HCKAdd.h"

@implementation NSInvocation (HCKAdd)

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    return [[self class] invocationWithTarget:target selector:selector arguments:NULL];
}

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(void*)firstArgument,...
{
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invoction = [NSInvocation invocationWithMethodSignature:signature];
    [invoction setTarget:target];
    [invoction setSelector:selector];
    
    if (firstArgument)
        {
        va_list arg_list;
        va_start(arg_list, firstArgument);
        [invoction setArgument:firstArgument atIndex:2];
        
        for (NSUInteger i = 0; i < signature.numberOfArguments; i++) {
            void *argument = va_arg(arg_list, void *);
            [invoction setArgument:argument atIndex:i];
        }
        va_end(arg_list);
        }
    
    return invoction;
}

@end
