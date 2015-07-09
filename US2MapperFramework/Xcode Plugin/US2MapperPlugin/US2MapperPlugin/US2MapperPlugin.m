//
//  US2MapperPlugin.m
//  US2MapperPlugin
//
//  Created by Anton on 7/9/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2MapperPlugin.h"

@interface US2MapperPlugin()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation US2MapperPlugin
+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    ///Users/anton/Developer/ExampleProject/ExampleProject
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *rebuildModelItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (rebuildModelItem) {
        [[rebuildModelItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Rebuild Model" action:@selector(doExample) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[rebuildModelItem submenu] addItem:actionMenuItem];
        
        NSMenuItem *undoMenuItem = [[NSMenuItem alloc] initWithTitle:@"Revert Model Changes" action:@selector(revertModel) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [undoMenuItem setTarget:self];
        [[rebuildModelItem submenu] addItem:undoMenuItem];
    }
}

// Sample Action, for menu item:
- (void)rebuildModoel {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    id workSpace;
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:[NSApp keyWindow]]) {
            workSpace = [controller valueForKey:@"_workspace"];
        }
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];

    NSArray * subpaths = [fm subpathsAtPath:@"/Users/anton/Developer/ustwo/US2Mapper/US2MapperFramework/"];
    NSString *pathString = @"";
    for (NSString* currentString in subpaths) {
          NSLog(@"%@",currentString );
   
        
        if ([currentString hasSuffix:@".xcodeproj"]) {
            [alert addButtonWithTitle:currentString.lastPathComponent];
            pathString = [pathString stringByAppendingFormat:@"\n%@", currentString];
        }
    }

    [alert setMessageText:pathString];
    [alert runModal];
}


- (void)revertModel {
    NSAlert *alert = [[NSAlert alloc] init];
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    id workSpace;
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:[NSApp keyWindow]]) {
            workSpace = [controller valueForKey:@"_workspace"];
        }
    }
    NSString* bundle = [[NSBundle mainBundle] bundlePath];
    NSString *workspacePath = [[workSpace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    NSString *path = [workspacePath stringByReplacingOccurrencesOfString:@".xcodeproj" withString:@"/"];
   // NSString *scriptCommand = [NSString stringWithFormat:@"python %@modelgen.py -i %@Mapping/ -o %@Classes/", path,path,path];
    
    [alert setMessageText:bundle];
    [alert runModal];
    //[self runCommand:scriptCommand];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Sample Action, for menu item:
- (void)doExample
{
   // NSAlert *alert = [[NSAlert alloc] init];
    
    /// NSString* bundle = [[NSBundle mainBundle] bundlePath];
    
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    id workSpace;
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:[NSApp keyWindow]]) {
            workSpace = [controller valueForKey:@"_workspace"];
        }
    }
    //WorkSpace Path : /Users/anton/Developer/ustwo/UTMapper/UTMapper/UTMapper.xcodeproj,   Path: /Users/anton/Developer/ustwo/UTMapper/UTMapper/
    NSString *workspacePath = [[workSpace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    // workspacePath.lastPathComponent
    NSString *path = [workspacePath stringByReplacingOccurrencesOfString:@".xcodeproj" withString:@"/"];
    
    //  python $PROJECT_DIR/$PROJECT_NAME/modelgen.py -i $PROJECT_DIR/UTMapper/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Classes/
 
    NSString *scriptCommand = [NSString stringWithFormat:@"python /Users/anton/Developer/ExampleProject/modelgen-swift.py -i /Users/anton/Developer/ExampleProject/ExampleProject/ExampleProject/Mapping/ -o /Users/anton/Developer/ExampleProject/ExampleProject/ExampleProject/Classes/ -p /Users/anton/Developer/ExampleProject/ExampleProject.xcodeproj/project.pbxproj"];
    
    //[alert setMessageText:scriptCommand];
    //[alert runModal];
    
    [self runCommand:scriptCommand];
}


- (NSString *)runCommand:(NSString *)commandToRun {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    NSLog(@"run command:%@", commandToRun);
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}


@end
