//
//  IphoneUTouchAppDelegate.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreToolsView.h"
#import "IphoneUTouchViewController.h"

#import "LoginViewController.h"

#import "LeadViewController.h"
#import "Leading_inViewController.h"
#import "ConnectServerFailedView.h"
#import "AppSelSocket.h"
#import "AtmosphereViewController.h"
#import "RockViewController.h"
#import "WelcomeView.h"

@class IphoneUTouchViewController;


@interface IphoneUTouchAppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,ClickPopToolDelegate,ExChangeToolBarStat,LoginDelegate,LeadLoginDelegate,ShowMenuAndInfoDelegate,CloseRoomDelegate,RockViewControllerDelegate,AtmosphereViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ConnectServerDelegate,UIAlertViewDelegate>
{
    UIButton * yuanButton;
    UIButton * banButton;
    
    UIButton * playButton;
    UIButton * pauseButton;
    UIButton * moreButton;
    UIButton * loginButton;
    
    UINavigationController *first;
    
    
    MoreToolsView * moreToolsView;
    RockViewController * rockView;
    AtmosphereViewController * atmosphereViewController;
    
    
    LoginViewController * loginViewContrl;
    
    LeadViewController * leadViewContrl;
    
    Leading_inViewController * lead_inViewContrl;
    
    ConnectServerFailedView * connectFailedView;
    
    NSString *IP;
    NSString *PORT;
    
    UIImageView* BKImageView;
    UIImageView *laodImageView;
    
    LiteDateBase *mySqlite;
    
    UIImagePickerController *myUIImagePickerController;
}

@property (strong, nonatomic) UIWindow *window;

@property ( nonatomic,retain) IphoneUTouchViewController *viewController;
@property (nonatomic,retain) LoginViewController * loginViewContrl;
@property (nonatomic,retain) LeadViewController * leadViewContrl;

@property (nonatomic,retain) Leading_inViewController * lead_inViewContrl;

@property (nonatomic,retain) ConnectServerFailedView * connectFailedView;

@property (nonatomic , strong) UINavigationController *first;
@property (nonatomic , retain) UIImageView* BKImageView;
@property (nonatomic , retain) UIImageView *laodImageView;
@property (nonatomic , retain) UIImagePickerController *myUIImagePickerController;

-(void)ButtonsPressed:(UIButton*) button;
-(BOOL) ConnectServer;

-(void) SaveLoginString;

-(void)OnAtmosphereMessage;
-(void)onAtmosphereViewControllerMessage:(int)type;
-(void)OnAtmosphereSubMessage:(int)type;

-(void)addBackgroundPicture;
-(void)changeBackgroundPicture;
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
- (void)deleteImage:(NSString *)imageName;

@end
