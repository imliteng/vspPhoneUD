//
//  MySingerCell.h
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SingerCell.h"

@interface MySingerCell : SingerCell
{
    UIView *cellContentView;
}

- (void)setCell:(NSString*)szName;

@end
