//
//  SingerCell.m
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingerCell.h"

@implementation SingerCell

@synthesize SingerName;

-(void) dealloc
{
    [SingerName release];
    
    [super dealloc];
}

@end
