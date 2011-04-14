//
//  MapLauncherAppDelegate.m
//  MapLauncher
//
//  Created by Jeff Hui on 4/11/11.
//  Copyright 2011 Jeff. All rights reserved.
//

#import "MapLauncherAppDelegate.h"

@implementation MapLauncherAppDelegate

@synthesize window, appPathLabel, mapPathLabel;

#define MISSING_APP_STR @"Cannot find StarCraft II.app"

- (void)dealloc
{
    self.appPathLabel = nil;
    self.mapPathLabel = nil;
    [super dealloc];
}

#pragma mark - Application Hooks

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    // Exe: C:\Program Files (x86)\StarCraft II\Versions\Base16939\SC2.exe Parameters: -run "Test/EditorTest.SC2Map" -displaymode 2 -preload 1 -NoUserCheats -reloadcheck -difficulty 2 -speed 2
    [self.appPathLabel setStringValue:[self findStarcraft2App]];
    [self.window registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

#pragma mark - IBActions

- (IBAction)play:(id)sender
{
    NSAlert *alert = nil;
    if ([[self.mapPathLabel stringValue] isEqualToString:@""]){
        alert = [NSAlert alertWithMessageText:@"No map specified to load"
                                defaultButton:@"OK"
                              alternateButton:nil
                                  otherButton:nil
                    informativeTextWithFormat:@"Select map or drag-and-drop the StarCraft II map to play"];
    }
    if ([[self.appPathLabel stringValue] isEqualToString:MISSING_APP_STR]){
        alert = [NSAlert alertWithMessageText:@"Could not find 'StarCraft II.app'"
                                defaultButton:@"OK"
                              alternateButton:nil
                                  otherButton:nil
                    informativeTextWithFormat:@"Select 'Change SC2 App' or drag-and-drop the StarCraft II.app"];
    }
    
    if (alert != nil){
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return;
    }
    
    
    NSTask *task = [NSTask new];
    [task setLaunchPath:[NSString stringWithFormat:@"%@/Contents/MacOS/StarCraft II", [self.appPathLabel stringValue]]];
    
    SC2Arguments *args = [SC2Arguments new];
    args.displayMode = SC2DisplayWindowedMode;
    args.fileToRun = [self.mapPathLabel stringValue];
    
    [task setArguments:[args commandLineArguments]];
    [args release];
    
    [task launch];
}

- (IBAction)browseForApp:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.directoryURL = [NSURL URLWithString:@"/Applications"];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelCancelButton) {
            return;
        }
        [self.appPathLabel setStringValue:[panel filename]];
    }];
}

- (IBAction)browseForMap:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    //panel.directoryURL = [NSURL URLWithString:@"~/Library/Application Support/Blizzard/StarCraft II/"];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"SC2Map"]];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelCancelButton) {
            return;
        }
        [self.mapPathLabel setStringValue:[panel filename]];
    }];
}

#pragma mark - Dragging Events

- (BOOL)ignoreModifierKeysWhileDragging
{
    return YES;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]){
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        if ([files count] != 1)
            return NSDragOperationNone;
        NSString *file = [[files objectAtIndex:0] lowercaseString];
        
        if ([file hasSuffix:@".sc2map"] || [file hasSuffix:@".app"])
            return NSDragOperationGeneric;
    }
    
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]){
        NSString *file = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex:0];
        NSString *lcFile = [file lowercaseString];
        if ([lcFile hasSuffix:@".sc2map"]){
            [self.mapPathLabel setStringValue:file];
        } else if ([lcFile hasSuffix:@".app"]){
            [self.appPathLabel setStringValue:file];
        }
        [self play:sender];
        return YES;
    }
    return NO;
}

#pragma mark - Custom Methods

#define APP_NAME @"StarCraft II.app"

- (NSString*)searchForSC2AppIn:(NSString*)directory
{
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
    if (error != nil){
        return nil;
    }
    for (NSString *file in files){
        NSString *fullpath = [NSString stringWithFormat:@"%@/%@", directory, file];

        if ([file isEqualToString:APP_NAME]){
            return fullpath;
        }
        
        if ([[file lowercaseString] hasSuffix:@".app"])
            continue;
        
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath isDirectory:&isDir] && isDir){
            NSString *result = [self searchForSC2AppIn:fullpath];
            if (result != nil)
                return result;
        }
    }
    return nil;
}

#define DEFAULT_PATH @"/Applications/StarCraft II/StarCraft II.app"

- (NSString*)findStarcraft2App
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSFileManager *fm = [NSFileManager defaultManager];
    // this is faster than manually scanning
    if ([fm fileExistsAtPath:DEFAULT_PATH]){
        [pool drain];
        return DEFAULT_PATH;
    }
    // scan /Applications directory for starcraft 2 app (includes subdirectory)
    NSString *result = [self searchForSC2AppIn:@"/Applications"];
    if (result == nil){
        NSLog(@"Could not find SC2 App :(");
        [pool drain];
        return MISSING_APP_STR;
    }
    [result retain];
    [pool drain];
    return result;
}


@end
