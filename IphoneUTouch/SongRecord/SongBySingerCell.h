//
//  SongBySingerCell.h
//  VisionTouch
//
//  Created by v v on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ApplicationCell.h"
#import <UIKit/UIKit.h>

@interface SongBySingerCell : ApplicationCell
{
    UIView *cellContentView;
}

- (void)setCell:(NSString *)songname songLanguage:(NSString *)Language Singer:(NSString*) singer;
@end
