//
//  SC2Arguments.m
//  MapLauncher
//
//  Created by Jeff Hui on 4/11/11.
//  Copyright 2011 Jeff. All rights reserved.
//

#import "SC2Arguments.h"


@implementation SC2Arguments

@synthesize displayMode, fileToRun, preload, reloadCheck;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        displayMode = SC2DisplayDefaultMode;
        preload = YES;
        reloadCheck = YES;
    }
    
    return self;
}

- (void)dealloc
{
    self.fileToRun = nil;
    [super dealloc];
}

- (NSArray*)commandLineArguments
{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"-run", self.fileToRun, nil];
    
    if (displayMode != SC2DisplayDefaultMode){
        [arr addObject:@"-displaymode"];
        [arr addObject:[NSString stringWithFormat:@"%d", displayMode]];
    }
    
    if (preload){
        [arr addObject:@"-preload"];
        [arr addObject:@"1"];
    }
    
    if (reloadCheck){
        [arr addObject:@"-reloadcheck"];
    }
    
    return arr;
}

@end
