//
//  SC2Arguments.h
//  MapLauncher
//
//  Created by Jeff Hui on 4/11/11.
//  Copyright 2011 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SC2DisplayWindowedMode,
    SC2DisplayFullscreenWindowMode,
    SC2DisplayFullscreenMode,
    SC2DisplayDefaultMode,
} SC2DisplayMode;

/*
 Here's a dump of all command line arguments from strings (that I could find):
 
 I skimmed SC2 binary using: "strings StarCraft2 | grep \- | less"
 
 --test
 --alreadyrunning
 --patch=none
 --hiddenProcessing=1
 --hiddenPort=%d
 -component-dl
 -run
 --patch=succeeded
 --patch=failed
 --toolsPatching
 --patchlist
 --responsefile
 --hiddenProcessing
 --locale
 --nop2p
 --hiddenPort
 --saveas
 --logFolder
 --nopatchnotes
 -test
 --optout
 
 Other known arguments:
 
 -displaymode #num#:
    0 => windowed
    1 => fullscreen windowed
    2 => fullscreen
 
 ... Anything in variables.txt works like -displaymode ...
 
 For single player:
 
 -fixedseed => Fixed seed for randomness
 -affinity #num# => number of/which CPUs to use
 -graphicsQuality [low|medium|high|ultra]
 -texturesQuality [low|medium|high|ultra]
 -ScreenshotFormat [extension]
 -CachePath [directory]
 -speed #num#
    0 => Slower
    1 => Slow
    2 => Normal
    3 => Fast
    4 => Faster
 -difficulty #num#
    0 => Very Easy
    1 => Easy
    2 => Normal
    3 => Hard
    4 => Very Hard
    5 => Insane
 -tridebug => enables trigger debugging
 -preload 1 => enables map preloading
 
 */

@interface SC2Arguments : NSObject {
@private
    BOOL preload;
    BOOL reloadCheck;
    NSString *fileToRun;
    SC2DisplayMode displayMode;
}

@property (nonatomic, assign) BOOL preload;
@property (nonatomic, assign) BOOL reloadCheck;
@property (nonatomic, retain) NSString *fileToRun;
@property (nonatomic, assign) SC2DisplayMode displayMode;

- (NSArray*)commandLineArguments;

@end
