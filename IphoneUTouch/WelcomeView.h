//
//  WelcomeView.h
//  IphoneUTouch
//
//  Created by user on 13-5-17.
//
//

#import <UIKit/UIKit.h>
#import "AppSelSocket.h"
#import "IphoneUTouchViewController.h"

@interface WelcomeView : UIView<NSXMLParserDelegate>
{
    NSString * KTVName;
    NSString * node;
    UILabel * ktvNameLabel;
    UIImageView * backgroundview;
}

@property(nonatomic,retain) NSString * KTVName;
@property(nonatomic,retain) NSString * node;
@property(nonatomic,retain) UILabel * ktvNameLabel;
@property(nonatomic,retain) UIImageView * backgroundview;

-(NSData*)requestKTVInfo;
@end
