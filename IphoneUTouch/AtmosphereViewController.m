//
//  AtmosphereViewController.m
//  IphoneUTouch
//
//  Created by user on 13-4-22.
//
//

#import "AtmosphereViewController.h"

@interface AtmosphereViewController ()

@end

@implementation AtmosphereViewController

@synthesize hammer;
@synthesize applaudButton;
@synthesize applauseButton;
@synthesize whistleButton;
@synthesize catcalButton;
@synthesize PromptView;
@synthesize myAtmosphereDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"气氛";
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    UIImageView * bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BG" ofType:@"jpg"inDirectory:@"Images"] ]];
//    bgView.frame=CGRectMake(0, 0, 320, 480);
//    [self.view addSubview:bgView];
//    [bgView release];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen16"  ofType:@"png"inDirectory:@"newImages/"]];
    UIImage* ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen17" ofType:@"png"inDirectory:@"newImages/"]];
    hammer=[[UIButton alloc] initWithFrame:CGRectMake(25.0, 30.0, 69.0, 69.0)];
    [hammer setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [hammer setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
//    [hammer setBackgroundColor:[UIColor blackColor]];
//    [hammer setTitle:@"沙锤" forState:UIControlStateNormal];
    hammer.tag=0;
    [hammer addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hammer];
    [hammer release];

    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen00"  ofType:@"png"inDirectory:@"newImages/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen01" ofType:@"png"inDirectory:@"newImages/"]];
    applaudButton=[[UIButton alloc]  initWithFrame:CGRectMake(126.0, 30.0, 69.0, 69.0)];
    [applaudButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [applaudButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
//    [applaudButton setBackgroundColor:[UIColor blackColor]];
//    [applaudButton setTitle:@"鼓掌" forState:UIControlStateNormal];
    applaudButton.tag=1;
    [applaudButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applaudButton];
    [applaudButton release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen02"  ofType:@"png"inDirectory:@"newImages/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen03" ofType:@"png"inDirectory:@"newImages/"]];
    applauseButton=[[UIButton alloc]  initWithFrame:CGRectMake(226.0, 30.0, 69.0, 69.0)];
    [applauseButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [applauseButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
//    [applauseButton setBackgroundColor:[UIColor blackColor]];
//    [applauseButton setTitle:@"欢呼" forState:UIControlStateNormal];
    applauseButton.tag=2;
    [applauseButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applauseButton];
    [applauseButton release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen04"  ofType:@"png"inDirectory:@"newImages/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen05" ofType:@"png"inDirectory:@"newImages/"]];
    whistleButton=[[UIButton alloc]  initWithFrame:CGRectMake(25.0, 129.0, 69.0, 69.0)];
    [whistleButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [whistleButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
//    [whistleButton setBackgroundColor:[UIColor blackColor]];
//    [whistleButton setTitle:@"口哨" forState:UIControlStateNormal];
    whistleButton.tag=3;
    [whistleButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whistleButton];
    [whistleButton release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen06"  ofType:@"png"inDirectory:@"newImages/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qifen07" ofType:@"png"inDirectory:@"newImages/"]];
    catcalButton=[[UIButton alloc]  initWithFrame:CGRectMake(126.0, 129.0, 69.0, 69.0)];
    [catcalButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [catcalButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
//    [catcalButton setBackgroundColor:[UIColor blackColor]];
//    [catcalButton setTitle:@"倒彩" forState:UIControlStateNormal];
    catcalButton.tag=4;
    [catcalButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:catcalButton];
    [catcalButton release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    [hammer release];
    [applaudButton release];
    [applauseButton release];
    [whistleButton release];
    [catcalButton release];
    [PromptView release];
}

-(void) buttonPressed:(UIButton*) button
{
    int tag=button.tag;
    [self ShowPopPrompt:tag];
    [self.myAtmosphereDelegate onAtmosphereViewControllerMessage:tag];
}

-(void) ShowPopPrompt:(int) buttonType
{
    NSString * contentNSString;
    
    if (1==buttonType) {
        contentNSString=[[NSString alloc] initWithString:@"鼓掌"];
    }else if (2==buttonType) {
        contentNSString=[[NSString alloc] initWithString:@"欢呼"];
    }else if (3==buttonType) {
        contentNSString=[[NSString alloc] initWithString:@"口哨"];
    }else if (4==buttonType) {
        contentNSString=[[NSString alloc] initWithString:@"倒彩"];
    }else{
        return;
    }

    if(PromptView)
    {
        [PromptView removeFromSuperview];
        [PromptView release];
        PromptView=nil;
    }
    
    NSString *strToShow=[[NSString alloc]initWithFormat:@"发送 %@",contentNSString];
    PromptView = [[GCDiscreetNotificationView alloc] initWithText:strToShow
                                                     showActivity:NO
                                               inPresentationMode: GCDiscreetNotificationViewPresentationModeTop
                                                           inView:self.view];
    [strToShow release];
    [self.PromptView show:YES];
    [self.PromptView hideAnimatedAfter:1.0];
    [contentNSString release];
}


@end
