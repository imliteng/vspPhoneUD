//
//  MoreToolsView.h
//  IphoneUTouch
//
//  Created by v v on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickPopToolDelegate <NSObject>

-(void)ClickPopTool:(int)tag;
-(void)OnAtmosphereMessage;
@end

@interface MoreToolsView : UIView
{
    CGRect   popupRect;
	CGRect   hideRect;
	BOOL     isPopup;
    BOOL     isOpen;
    id<ClickPopToolDelegate> delegate;
    
    UIButton * AtmosphereButton;
    UIButton * blackPhotoButton;
    UIButton * soundButton;
    UIButton * mucAddButton;
    UIButton * mucSubButton;
    UIButton * micAddButton;
    UIButton * micSubButton;
    UIButton * RepButton;
    UIButton * MuteButton;
    UIButton * ChangeButton;
    UIButton * ServiceButton;
    UIButton * CloseToolButton;
    
    UIImageView * MucBGImage;
    UIImageView * MicBGImage;
    
    
}

@property BOOL isPopup;
@property BOOL isOpen;
@property (nonatomic,assign) id<ClickPopToolDelegate> delegate;

-(void)popup;
-(void)hide;

-(void) ButtonsPressed:(UIButton *) button;
-(void)popupSoundBoard;
-(void)soundButtonShowControl;
-(void)soundButtonHiddenControl;

@end
