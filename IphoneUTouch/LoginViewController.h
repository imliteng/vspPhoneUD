//
//  LoginViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppSelSocket.h"
#import "ZXingWidgetController.h"

@protocol LoginDelegate <NSObject>

-(void) Login:(BOOL)stat;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate,ZXingDelegate>
{
    UITextField *textField;
    UIButton* backButton; // add by liteng 
    
    id<LoginDelegate > loginDelegate;

}

@property (nonatomic,retain ) UITextField * textField;
@property (nonatomic,retain ) UIButton* backButton;
@property (nonatomic,assign )id<LoginDelegate>loginDelegate;

-(void) ButtonsPressed:(UIButton *) button;

-(NSString *)dataFilePath;

@end
