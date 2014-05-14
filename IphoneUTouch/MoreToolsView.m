//
//  MoreToolsView.m
//  IphoneUTouch
//
//  Created by v v on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreToolsView.h"

@implementation MoreToolsView

@synthesize isPopup;
@synthesize isOpen;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setClipsToBounds:YES];//很重要哈
        hideRect=self.frame;
        self.backgroundColor=[UIColor grayColor];
        popupRect=CGRectMake(hideRect.origin.x, hideRect.origin.y-111, hideRect.size.width, hideRect.size.height);
        
		self.frame=hideRect;
		isPopup=NO;
        
//        UIImageView * BGImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PopToolBG" ofType:@"png"inDirectory:@"Images/"]]];
//        BGImage.frame=CGRectMake(0, 0, 320, 118);
//        [self addSubview:BGImage];
//        [BGImage release];
        
        UIImageView * BGImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rang" ofType:@"png"inDirectory:@"newImages/"]]];
        BGImage.frame=CGRectMake(0, 0, 320, 17);
        [self addSubview:BGImage];
        [BGImage release];
        
        
        [self setBackgroundColor:[UIColor colorWithRed:96.0f/255.0f green:119.0f/255.0f blue:149.0/255.0f alpha:1]];
        
        UIImage *ButtonImage;
        UIImage *ButtonImage1;
        
        //氛围  add by liteng for 增回氛围按钮 20130417
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen08" ofType:@"png"inDirectory:@"newImages/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen09" ofType:@"png"inDirectory:@"newImages/"]];
        AtmosphereButton = [[UIButton alloc] init];
        [AtmosphereButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [AtmosphereButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        AtmosphereButton.frame=CGRectMake(2.0f, 19.0f, 125.5f, 44.5f);
        AtmosphereButton.tag=10;
        [AtmosphereButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [AtmosphereButton setTitle:@"氛围" forState:UIControlStateNormal];
        [self addSubview:AtmosphereButton];
        [AtmosphereButton release];
        
        //底图
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen10" ofType:@"png"inDirectory:@"newImages/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen11" ofType:@"png"inDirectory:@"newImages/"]];
        blackPhotoButton = [[UIButton alloc] init];
        [blackPhotoButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [blackPhotoButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        blackPhotoButton.frame=CGRectMake(194.0f, 19.0f, 125.5f, 44.5f);
        blackPhotoButton.tag=11;
        [blackPhotoButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [blackPhotoButton setTitle:@"背景" forState:UIControlStateNormal];
        [self addSubview:blackPhotoButton];
        [blackPhotoButton release];
        
        //音量
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen12" ofType:@"png"inDirectory:@"newImages/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen13" ofType:@"png"inDirectory:@"newImages/"]];
        soundButton = [[UIButton alloc] init];
        [soundButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [soundButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        soundButton.frame=CGRectMake(130.0f, 19.0f, 61.5f, 91.0f);
        soundButton.tag=12;
        [soundButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [soundButton setTitle:@"音量" forState:UIControlStateNormal];
        [self addSubview:soundButton];
        [soundButton release];
        
        MucBGImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Muc" ofType:@"png"inDirectory:@"Images/"]]];
        MucBGImage.frame=CGRectMake(10, 35, 34, 16);
        [self addSubview:MucBGImage];
        [MucBGImage release];
        
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Add" ofType:@"png"inDirectory:@"Images/"]];
        mucAddButton = [[UIButton alloc] init]; 
        [mucAddButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        mucAddButton.frame=CGRectMake(104, 23, 50.f, 38);
        mucAddButton.tag=2;
        [mucAddButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mucAddButton];
        [mucAddButton release];
        
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sub" ofType:@"png"inDirectory:@"Images/"]];
        mucSubButton = [[UIButton alloc] init]; 
        [mucSubButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        mucSubButton.frame=CGRectMake(50, 23, 50.f, 38);
        mucSubButton.tag=1;
        [mucSubButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mucSubButton];
        [mucSubButton release];
        
        MicBGImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Mic" ofType:@"png"inDirectory:@"Images/"]]];
        MicBGImage.frame=CGRectMake(170, 35, 34, 16);
        [self addSubview:MicBGImage];
        [MicBGImage release];
        
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Add" ofType:@"png"inDirectory:@"Images/"]];
        micAddButton = [[UIButton alloc] init]; 
        [micAddButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        micAddButton.frame=CGRectMake(264, 23, 50.f, 38);
        micAddButton.tag=4;
        [micAddButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:micAddButton];
        [micAddButton release];
        
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sub" ofType:@"png"inDirectory:@"Images/"]];
        micSubButton = [[UIButton alloc] init]; 
        [micSubButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        micSubButton.frame=CGRectMake(210, 23, 50.f, 38);
        micSubButton.tag=3;
        [micSubButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:micSubButton];
        [micSubButton release];
        
        //重唱
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Rep1" ofType:@"png"inDirectory:@"Images/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Rep2" ofType:@"png"inDirectory:@"Images/"]];
        RepButton = [[UIButton alloc] init]; 
        [RepButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [RepButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        RepButton.frame=CGRectMake(2, 65, 61.5f, 44.5f);
        RepButton.tag=5;
        [RepButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:RepButton];
        [RepButton release];
        
        //静音
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Mute1" ofType:@"png"inDirectory:@"Images/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Mute2" ofType:@"png"inDirectory:@"Images/"]];
        MuteButton = [[UIButton alloc] init]; 
        [MuteButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [MuteButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        MuteButton.frame=CGRectMake(65.5f, 65, 61.5f, 44.5f);
        MuteButton.tag=6;
        [MuteButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:MuteButton];
        [MuteButton release];
        
        //换房
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ChangeRoom1" ofType:@"png"inDirectory:@"Images/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ChangeRoom2" ofType:@"png"inDirectory:@"Images/"]];
        ChangeButton = [[UIButton alloc] init]; 
        [ChangeButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [ChangeButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        ChangeButton.frame=CGRectMake(131.f+2+61.5f, 65, 61.5f, 44.5f);
        ChangeButton.tag=7;
        [ChangeButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ChangeButton];
        [ChangeButton release];
        
        //服务
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Service1" ofType:@"png"inDirectory:@"Images/"]];
        ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Service2" ofType:@"png"inDirectory:@"Images/"]];
        ServiceButton = [[UIButton alloc] init]; 
        [ServiceButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        [ServiceButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
        ServiceButton.frame=CGRectMake(131.f+2+61.5f+2+61.5f, 65, 61.5f, 44.5f);
        ServiceButton.tag=8;
        [ServiceButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ServiceButton];
        [ServiceButton release];
        
        //隐藏
        ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CloseTool" ofType:@"png"inDirectory:@"Images/"]];
        CloseToolButton = [[UIButton alloc] init]; 
        [CloseToolButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
        CloseToolButton.frame=CGRectMake((320-34)/2, 0, 34.f, 13.5f);
        CloseToolButton.tag=9;
        [CloseToolButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:CloseToolButton];
        [CloseToolButton release];
        
        isOpen=YES;
        [self soundButtonHiddenControl];
    }
    return self;
}


-(void) ButtonsPressed:(UIButton *) button
{
    if (10==button.tag)
        [self.delegate OnAtmosphereMessage];
    else if(12==button.tag)
        [self popupSoundBoard];
    else
        [self.delegate ClickPopTool:button.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)popupSoundBoard
{
    [UIView animateWithDuration:.3 animations:^{
//        self.alpha = 1;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+(isOpen ? -50 : 50), self.frame.size.width, self.frame.size.height+(isOpen ? 50 : -50));
        AtmosphereButton.frame=CGRectMake(AtmosphereButton.frame.origin.x, AtmosphereButton.frame.origin.y+(isOpen ? 50 : -50), AtmosphereButton.frame.size.width, AtmosphereButton.frame.size.height);
        blackPhotoButton.frame=CGRectMake(blackPhotoButton.frame.origin.x, blackPhotoButton.frame.origin.y+(isOpen ? 50 : -50), blackPhotoButton.frame.size.width, blackPhotoButton.frame.size.height);
        soundButton.frame=CGRectMake(soundButton.frame.origin.x, soundButton.frame.origin.y+(isOpen ? 50 : -50), soundButton.frame.size.width, soundButton.frame.size.height);
        RepButton.frame=CGRectMake(RepButton.frame.origin.x, RepButton.frame.origin.y+(isOpen ? 50 : -50), RepButton.frame.size.width, RepButton.frame.size.height);
        MuteButton.frame=CGRectMake(MuteButton.frame.origin.x, MuteButton.frame.origin.y+(isOpen ? 50 : -50), MuteButton.frame.size.width, MuteButton.frame.size.height);
        ChangeButton.frame=CGRectMake(ChangeButton.frame.origin.x, ChangeButton.frame.origin.y+(isOpen ? 50 : -50), ChangeButton.frame.size.width, ChangeButton.frame.size.height);
        ServiceButton.frame=CGRectMake(ServiceButton.frame.origin.x, ServiceButton.frame.origin.y+(isOpen ? 50 : -50), ServiceButton.frame.size.width, ServiceButton.frame.size.height);
        if (!isOpen)
           [self soundButtonHiddenControl];
    }completion:^(BOOL finished) {
        if (isOpen) {
            [UIView animateWithDuration:.3 animations:^{
                [self soundButtonShowControl];
            }];
        }
        isOpen=!isOpen;
    }];
}

-(void)soundButtonShowControl
{
    MicBGImage.hidden=NO;
    MucBGImage.hidden=NO;
    micAddButton.hidden=NO;
    micSubButton.hidden=NO;
    mucAddButton.hidden=NO;
    mucSubButton.hidden=NO;
    MicBGImage.alpha=1;
    MucBGImage.alpha=1;
    micAddButton.alpha=1;
    micSubButton.alpha=1;
    mucAddButton.alpha=1;
    mucSubButton.alpha=1;
}

-(void)soundButtonHiddenControl
{
    MicBGImage.hidden=YES;
    MucBGImage.hidden=YES;
    micAddButton.hidden=YES;
    micSubButton.hidden=YES;
    mucAddButton.hidden=YES;
    mucSubButton.hidden=YES;
    MicBGImage.alpha=0;
    MucBGImage.alpha=0;
    micAddButton.alpha=0;
    micSubButton.alpha=0;
    mucAddButton.alpha=0;
    mucSubButton.alpha=0;
}

-(void)popup
{
    if(isPopup)
    {
        return ;
    }
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //  [UIView setAnimationDuration:UIViewAnimationTransitionCurlUp];
	[self setFrame:popupRect];
	[UIView commitAnimations];
    isPopup = YES;
}

- (void)hide
{
    if(!isPopup)
    {
        return;
    }
    if (!isOpen) {
        [self popupSoundBoard];
    }
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self setFrame:hideRect];
	[UIView commitAnimations];
    isPopup = NO;
}


@end
