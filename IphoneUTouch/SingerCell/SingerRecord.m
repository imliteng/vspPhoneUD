//
//  SingerRecord.m
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingerRecord.h"

@implementation SingerRecord

@synthesize singerId;
@synthesize singerName;

-(void) dealloc
{
    [singerId release];
    [singerName release];
    [super dealloc];
}
@end
