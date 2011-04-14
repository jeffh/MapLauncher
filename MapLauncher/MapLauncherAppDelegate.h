//
//  MapLauncherAppDelegate.h
//  MapLauncher
//
//  Created by Jeff Hui on 4/11/11.
//  Copyright 2011 Jeff. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SC2Arguments.h"

@interface MapLauncherAppDelegate : NSWindowController <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSTextField *appPathLabel;
    NSTextField *mapPathLabel;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSTextField *appPathLabel;
@property (nonatomic, retain) IBOutlet NSTextField *mapPathLabel;

- (IBAction)browseForApp:(id)sender;
- (IBAction)browseForMap:(id)sender;
- (IBAction)play:(id)sender;

- (NSString*)findStarcraft2App;

@end
