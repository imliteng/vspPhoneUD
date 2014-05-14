    //
//  PopoverController.m
//  Demo
//
//  Created by v v on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopoverController.h"

@implementation UINavigationController(background)

-(void)addBackgroundView:(NSString*)image Title:(NSString*)myTitle 
{
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
	imgView.frame = CGRectMake(0, 0, 320, 44);
	[self.navigationBar addSubview: imgView];
    [imgView release];
}

@end
