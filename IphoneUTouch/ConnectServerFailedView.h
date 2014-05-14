//
//  ConnectServerFailedView.h
//  VisionTouch
//
//  Created by v v on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ConnectServerDelegate<NSObject>

-(BOOL)didDemoLink;

@end

@interface ConnectServerFailedView : UIViewController
{
    id<ConnectServerDelegate>MyDelegate;
}
@property(nonatomic,assign) id<ConnectServerDelegate>MyDelegate;

@end
