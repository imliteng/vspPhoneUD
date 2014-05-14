//
//  SingersSelViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingersInfoViewController.h"

@interface SingersSelViewController : UIViewController
{
    UIBarButtonItem *pre;
    SingersInfoViewController * singersInfoContrl;
    int MySingerTypeIndex;
}

@property (nonatomic,retain)  SingersInfoViewController * singersInfoContrl;

-(void) buttonPressed:(UIButton*) button;
-(void) RefreshData;

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid;
@end
