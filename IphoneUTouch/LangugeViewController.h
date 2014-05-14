//
//  LangugeViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongInViewController.h"

@interface LangugeViewController : UIViewController
{
    SongInViewController * songInfoByLangugeContrl;
    int MylanguageIndex;
}

@property (nonatomic,retain)  SongInViewController * songInfoByLangugeContrl;

-(void)buttonPressed:(UIButton *) button;

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid;

@end
