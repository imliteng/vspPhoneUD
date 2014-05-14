//
//  LeadViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeadLoginDelegate <NSObject>

-(void) Lead:(BOOL) stat;

@end

@interface LeadViewController : UIViewController
{
    id<LeadLoginDelegate> leadDelegate;
}

@property (nonatomic,assign) id<LeadLoginDelegate> leadDelegate;

@end
