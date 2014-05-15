//
//  LoginViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "IphoneUTouchViewController.h"

#import "QRCodeReader.h"

extern NSString *stringLogin;

extern NSString * HOST_IP;    //114.132.246.131
extern NSString * HOST_PORT;

extern CGRect MainRect;

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize textField;
@synthesize backButton;
@synthesize loginDelegate;

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
	// Do any additional setup after loading the view.
    
    UIImageView * bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_bg" ofType:@"png"inDirectory:@"Images"] ]]; 
    bgView.frame=CGRectMake(0,0,MainRect.size.width, MainRect.size.height);
    [self.view addSubview:bgView];
    [bgView release];
     
    textField=[[UITextField alloc] initWithFrame:CGRectMake(40.0f,210.0f,190.0f,32.0f)]; 
    [textField setBorderStyle:UITextBorderStyleRoundedRect];//外框类型 
    textField.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    textField.placeholder=@"您的验证码";//默认显示的字
    [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];//键盘样式
    textField.textColor=[UIColor grayColor];
    textField.textAlignment = UITextAlignmentCenter;
    //textField.secureTextEntry=YES;//密码 
    textField.autocorrectionType=UITextAutocorrectionTypeNo; 
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone; 
    textField.returnKeyType=UIReturnKeyDone; 
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;//编辑时会出现个修改X 
    textField.delegate=self;
    
    textField.text=[IphoneUTouchViewController GetLoginString];
    [self.view addSubview:textField];
    
    UIImage *ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_inroom_up" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_inroom_down" ofType:@"png"inDirectory:@"Images/"]]; 
    UIButton *LoginButton = [[UIButton alloc] init]; 
    [LoginButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [LoginButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
    LoginButton.frame=CGRectMake(235, 209.5f, 62.f, 32.0f);
    LoginButton.tag=1;
    [LoginButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginButton];
    [LoginButton release];

    bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_capture_string" ofType:@"png"inDirectory:@"Images"] ]]; 
    bgView.frame=CGRectMake(30,260,258, 14.5f);
    [self.view addSubview:bgView];
    [bgView release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Camera" ofType:@"png"inDirectory:@"Images/"]];
    UIButton *camButton = [[UIButton alloc] init]; 
    [camButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    camButton.frame=CGRectMake(135, 272, ButtonImage.size.width*2/5, ButtonImage.size.height*2/5);
    camButton.tag=2;
    [camButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:camButton];
    [camButton release];
    
    /*add by liteng for 增回返回按钮 20130423*/
    backButton = [[UIButton alloc] init];
    [backButton setBackgroundColor:[UIColor blackColor]];
    backButton.frame=CGRectMake(15.0f, 209.5f, 20.0f, 32.0f);
    backButton.tag=1;
    [backButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton release];
    backButton.hidden=YES;
                                                                                            
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField 
{
	[textField resignFirstResponder];

 	return YES;
}

-(NSString *)dataFilePath
{
#if TARGET_IPHONE_SIMULATOR
    return @"/Users/vv/Documents/IphoneUTouch/IphoneUTouch/IphoneUTouch/Images";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#endif
}

-(void) ButtonsPressed:(UIButton *) button
{
    [textField resignFirstResponder];
    int tag=button.tag;
    if(tag==1)
    {
        stringLogin=textField.text;
        [stringLogin retain];
            
        if([stringLogin length]<=0)//登陆验证码为空
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不能为空，请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        int ret=[IphoneUTouchViewController GetLoginStat];
        /*add by liteng for 解决首次入房失败的问题 20130516*/
        if (ret<0) {
            ret=[IphoneUTouchViewController GetLoginStat];
        }
        if(ret>0)
        {
            [self.loginDelegate Login:YES];
        }
        else if(ret==-1)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败,请确认服务器IP及端口后重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
             [self.loginDelegate Login:NO];
        }
        else if(ret==-2)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆失败,请确认验证码,重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
             [self.loginDelegate Login:NO];
        }
    }
    else if(tag==2)
    {
        ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
        QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
        NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
        [qrcodeReader release];
        widController.readers = readers;
        [readers release];

        [self presentModalViewController:widController animated:YES];
        [widController release];
    }
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    if (self.isViewLoaded)
    {
        //NSLog(@"二维码Code======%@",result);
        
        NSString *szCode;
        NSString *szCode2;
        NSRange range1=[result rangeOfString:@"/"];
        if(range1.length>=1)
        {
            szCode=[result substringWithRange:NSMakeRange(range1.location+range1.length, [result length]-1-range1.location )];
            range1=[szCode rangeOfString:@"/"];
            if(range1.length>=1)
            {
                szCode2=[szCode substringWithRange:NSMakeRange(range1.location+range1.length, [szCode length]-1-range1.location )];
            }
           // NSLog(@"Code======%@",szCode2);
        }
        
        [textField setText:szCode2];
        [textField setNeedsDisplay];
        
        stringLogin=szCode2;
        [stringLogin retain];
    }
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller 
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}

-(void) dealloc
{
    [textField release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
