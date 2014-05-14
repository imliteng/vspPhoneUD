//
//  ApplicationCell.m
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApplicationCell.h"

@implementation ApplicationCell

@synthesize singerName;
@synthesize songName;
@synthesize language;
@synthesize singerIdString;

- (void)dealloc
{
    [songName release];
    [singerName release];
    [language release];
    [singerIdString release];
    [super dealloc];
}

@end
