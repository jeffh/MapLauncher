//
//  MapLauncherAppDelegate.h
//  MapLauncher
//
//  Created by Jeff Hui on 4/11/11.
//  Copyright 2011 Jeff. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MapLauncherAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
