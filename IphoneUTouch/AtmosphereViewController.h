//
//  AtmosphereViewController.h
//  IphoneUTouch
//
//  Created by user on 13-4-22.
//
//

#import <UIKit/UIKit.h>
#import "GCDiscreetNotificationView.h"


@protocol  AtmosphereViewControllerDelegate<NSObject>

-(void)onAtmosphereViewControllerMessage:(int)type;

@end

@interface AtmosphereViewController : UIViewController
{
    UIButton *  hammer;
    UIButton *  applaudButton;
    UIButton *  applauseButton;
    UIButton *  whistleButton;
    UIButton *  catcalButton;
    GCDiscreetNotificationView *PromptView;
    id<AtmosphereViewControllerDelegate>myAtmosphereDelegate;
}
@property(nonatomic,retain) UIButton * hammer;
@property(nonatomic,retain) UIButton * applaudButton;
@property(nonatomic,retain) UIButton * applauseButton;
@property(nonatomic,retain) UIButton * whistleButton;
@property(nonatomic,retain) UIButton * catcalButton;
@property(nonatomic,retain) GCDiscreetNotificationView *PromptView;
@property(nonatomic,assign) id<AtmosphereViewControllerDelegate>myAtmosphereDelegate;

-(void) ShowPopPrompt:(int) buttonType;
@end
