//
//  ApplicationCell.h
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplicationCell : UITableViewCell
{
    NSString *songName;
    NSString *language;
    NSString *singerName;
    NSString *singerIdString;
}

@property (retain) NSString *songName;
@property (retain) NSString *language;
@property (retain) NSString *singerName;
@property (retain) NSString *singerIdString;
@end
