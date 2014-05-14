//
//  RockViewController.h
//  IphoneUTouch
//
//  Created by user on 13-4-17.
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol RockViewControllerDelegate <NSObject>

-(void)onHammerMessage;

@end

@interface RockViewController : UIViewController<UIAccelerometerDelegate>
{
    UIAccelerometer *accelerometer;
    BOOL isLoadViewFlag;
    id<RockViewControllerDelegate>MyRockDelegate;
}
@property(nonatomic,assign) id<RockViewControllerDelegate>MyRockDelegate;
-(void)rockDoding;

@end
