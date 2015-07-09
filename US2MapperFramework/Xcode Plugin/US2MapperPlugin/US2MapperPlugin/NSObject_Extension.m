//
//  NSObject_Extension.m
//  US2MapperPlugin
//
//  Created by Anton on 7/9/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//


#import "NSObject_Extension.h"
#import "US2MapperPlugin.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[US2MapperPlugin alloc] initWithBundle:plugin];
        });
    }
}
@end
