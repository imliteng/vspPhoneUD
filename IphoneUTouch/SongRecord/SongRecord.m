//
//  SongRecord.m
//  VisionTouch
//
//  Created by v v on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongRecord.h"

@implementation SongRecord

@synthesize songId;
@synthesize singer;
@synthesize songname;
@synthesize language;
@synthesize isChange;
@synthesize pid;
@synthesize plOrder;
@synthesize privateId;
@synthesize isReserve;
@synthesize singerString;
@synthesize isHave;

-(void)dealloc
{
    [songId release];
    [singer release];
    [songName release];
    [language release];
    [pid release];
    [plOrder release];
    [privateId release];
    [singerString release];
    [super dealloc];
}

@end
