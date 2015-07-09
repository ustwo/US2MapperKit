//
//  US2MapperPlugin.h
//  US2MapperPlugin
//
//  Created by Anton on 7/9/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import <AppKit/AppKit.h>

@class US2MapperPlugin;

static US2MapperPlugin *sharedPlugin;

@interface US2MapperPlugin : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end