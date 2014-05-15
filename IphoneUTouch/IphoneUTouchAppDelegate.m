//
//  IphoneUTouchAppDelegate.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IphoneUTouchAppDelegate.h"

#import "IphoneUTouchViewController.h"
#import "CustomNavigationBar.h"



NSString * HOST_IP=@"192.100.110.254";    //114.132.246.131
NSString * HOST_PORT=@"8888";
NSString * stringLogin=@"00000000";//@"803621617";//@"00000000";

NSString * DEMO_HOST_IP=@"101.36.94.204";
NSString * DEMO_HOST_PORT=@"8888";

CGRect MainRect;

@implementation IphoneUTouchAppDelegate

@synthesize first;

@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize loginViewContrl;
@synthesize leadViewContrl;

@synthesize  lead_inViewContrl;
@synthesize connectFailedView;
@synthesize BKImageView;
@synthesize laodImageView;
@synthesize myUIImagePickerController;
-(BOOL) ConnectServer
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return NO;
    }
    
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        NSLog(@"连接服务器失败");
        [sock release];
        return NO;
    }
    
    [sock CloseSocket];
    [sock release];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [loginViewContrl release];
    [leadViewContrl release];
    [lead_inViewContrl release];
    
    [yuanButton release];
    [banButton release];
    
    [playButton release];
    [pauseButton release];
    
    [first release];
    
    [moreToolsView release];
    [rockView release];
    [mySqlite CloseDB];
    [mySqlite release];
    [super dealloc];
}

-(void)ExChangeMucStat:(BOOL)isYuanChang
{
    if(isYuanChang)
    {
        yuanButton.hidden=YES;
        banButton.hidden=NO;
    }
    else 
    {
        yuanButton.hidden=NO;
        banButton.hidden=YES;
    }
}

-(void)ExChangePlayStat:(BOOL)isPlaying
{
    if(isPlaying)
    {
        playButton.hidden=YES;
        pauseButton.hidden=NO;
    }
    else
    {
        playButton.hidden=NO;
        pauseButton.hidden=YES;
    }
}

-(void)initFistNavigationController
{
    IphoneUTouchViewController* tmIphoneUTouchViewController = [[IphoneUTouchViewController alloc] initWithNibName:@"IphoneUTouchViewController" bundle:nil];
    self.viewController = tmIphoneUTouchViewController;
    [tmIphoneUTouchViewController release];
    self.viewController.ChangeDelegate=self;
    self.viewController.closeRoomDelegate=self;
    [self.viewController viewDidAppear:YES];
    
    first=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    [self.window insertSubview:first.view atIndex:0];
    [self.first.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBarBG.png"]  forBarMetrics:UIBarMetricsDefault];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.first.navigationBar.titleTextAttributes = dict;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    MainRect=[[UIScreen mainScreen] bounds];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sIp=[defaults stringForKey:@"ServerIP"];
    NSString *sPort=[defaults stringForKey:@"ServerPort"];
    if(sIp)
    {
        HOST_IP=[sIp retain];
    }
    if(sPort)
    {
        HOST_PORT=[sPort retain];
    }
    //NSLog(@"服务器地址为%@,端口为%@",HOST_IP,HOST_PORT);
    
    if(![self ConnectServer])
    {
        self.connectFailedView = [[[ConnectServerFailedView alloc] initWithNibName:@"ConnectServerFailedView" bundle:nil] autorelease];
        self.connectFailedView.MyDelegate=self;
        self.connectFailedView.view.backgroundColor=[UIColor clearColor];
        self.window.rootViewController = self.connectFailedView;
        [self.window makeKeyAndVisible];
        return  YES;
    }

    [self initMainView];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"程序活动");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"程序将退出");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"测试!!!");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   //
}

/*add by liteng for 增加背景图片(未用) 20130424*/
-(void)addBackgroundPicture
{
#if TARGET_IPHONE_SIMULATOR
    BKImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, MainRect.size.width, MainRect.size.height)];
    [BKImageView setImage:[UIImage imageNamed:@"BK.PNG"]];
#else
    BKImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, MainRect.size.width, MainRect.size.height)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"background"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave)
    {
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [BKImageView setImage:img];
    }
    else
        [BKImageView setImage:[UIImage imageNamed:@"BK.PNG"]];
#endif
      [self.window insertSubview:BKImageView atIndex:0];
//    [self.window addSubview:BKImageView];
}

-(void)ButtonsPressed:(UIButton*) button
{
    if(button.tag==2)
    {
        yuanButton.hidden=YES;
        banButton.hidden=NO;
    }
    if(button.tag==3)
    {
        yuanButton.hidden=NO;
        banButton.hidden=YES;
    }
    if(button.tag==4)
    {
        playButton.hidden=YES;
        pauseButton.hidden=NO;
    }
    if(button.tag==5)
    {
        playButton.hidden=NO;
        pauseButton.hidden=YES;
    }
    
    if(button.tag==7)
    {
        if (moreToolsView.isPopup)
        {
            [moreToolsView hide];
        }
        else
        {
            [moreToolsView popup];
        }	
    }
    if(button.tag==20)
    {
        if(first)
        {
            //[self.viewController SelfDownView];
            [self.viewController.view removeFromSuperview];
            [_viewController release];
            _viewController=nil;
            
            [first.view removeFromSuperview];
            [first release];
            first=nil;
            
            loginViewContrl=[[LoginViewController alloc]initWithNibName:nil bundle:nil];
            loginViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width, MainRect.size.height);
            loginViewContrl.loginDelegate=self;
            [self.window addSubview:self.loginViewContrl.view];
        }
    }
    
    [self.viewController ToolBarClick:button.tag];
}

-(void)ClickPopTool:(int)tag
{
    int iTag=tag+7;
    if(iTag==16)
    {
        if (moreToolsView.isPopup)
        {
            [moreToolsView hide];
        }
        else
        {
            [moreToolsView popup];
        }	
    }
    else if(iTag==14)
    {
        [self.myUIImagePickerController dismissModalViewControllerAnimated:NO];// add by liteng for 解决换房页面切换的bug 20130514
        if (moreToolsView.isPopup)
        {
            [moreToolsView hide];
        }

        if(first)
        {
            //[self.viewController SelfDownView];
            [self.viewController.view removeFromSuperview];
            [_viewController release];
            _viewController=nil;
            
            [first.view removeFromSuperview];
            [first release];
            first=nil;
            
            loginViewContrl=[[LoginViewController alloc]initWithNibName:nil bundle:nil];
            loginViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width, MainRect.size.height);
            loginViewContrl.loginDelegate=self;
//            loginViewContrl.backButton.hidden=NO;  modify by liteng for 暂时禁用 20130426
            [self.window addSubview:self.loginViewContrl.view];
        }
    }
    else if(18==iTag)  //add by liteng for 增回换低图的响应
    {
        [self changeBackgroundPicture];
    }
    else 
    {
        [self.viewController ToolBarClick:iTag];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [picker dismissModalViewControllerAnimated:YES];
}

/*add by liteng for 更换底图 20130423*/
-(void)changeBackgroundPicture
{
    [moreToolsView hide];
    UIImagePickerController*imagePicker =   [[UIImagePickerController alloc] init];
    self.myUIImagePickerController=imagePicker;
    [imagePicker release];
    self.myUIImagePickerController.delegate = (id)self;
    self.myUIImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.myUIImagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.myUIImagePickerController.allowsEditing = NO;
    [self.viewController presentModalViewController:self.myUIImagePickerController animated:YES];
}

/*add by liteng for 选取图片代理函数 20130423*/
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //添加图片进入沙盒
    //    [self imageWithImageSimple:image scaledToSize:CGSizeMake(320, 480)];
    [self saveImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(MainRect.size.width, MainRect.size.height)] WithName:@"background"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
//    [self deleteImage:@"background"];
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"background"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
            NSData *data = [NSData dataWithContentsOfFile:uniquePath];
            UIImage *img = [[UIImage alloc] initWithData:data];
            UIColor *bgColor = [UIColor colorWithPatternImage:img];
            [self.window setBackgroundColor:bgColor];
    }else{
        return;
    }
}

/*add by liteng for 压缩图片 20130423*/

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/*add by liteng for 图片添入沙盒 20130423*/

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/*add by liteng for 响应气氛 2013040419*/
-(void)OnAtmosphereMessage
{
    [moreToolsView hide];
#if 0
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:(id)self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"沙锤"
                                  otherButtonTitles:@"鼓掌",@"欢呼", @"口哨",@"倒彩",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [actionSheet showInView:self.window];
#endif
    if([self.first.topViewController isKindOfClass:[AtmosphereViewController class]])
        return;
    [first pushViewController:atmosphereViewController animated:YES];
}

/*add by liteng for 删除沙盒内原文件 20130502*/
- (void)deleteImage:(NSString *)imageName
{
    NSFileManager * fileManager=[NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    [fileManager removeItemAtPath:imageName error:nil];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"沙锤");
        [first pushViewController:rockView animated:YES];
    }else if (buttonIndex == 1) {
        NSLog(@"鼓掌");
        [self OnAtmosphereSubMessage:1];
    }else if(buttonIndex == 2) {
        NSLog(@"欢呼");
        [self OnAtmosphereSubMessage:2];
    }else if(buttonIndex == 3) {
        NSLog(@"口哨");
        [self OnAtmosphereSubMessage:3];
    }else if(buttonIndex == 4) {
        NSLog(@"倒彩");
        [self OnAtmosphereSubMessage:4];
    }else{
        NSLog(@"取消");
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


/*add by liteng for 代理消息 20130422*/
-(void)onAtmosphereViewControllerMessage:(int)type
{
    if (0==type) {
        [first pushViewController:rockView animated:YES];
    }else if (1==type) {
        [self OnAtmosphereSubMessage:1];
    }else if (2==type) {
        [self OnAtmosphereSubMessage:2];
    }else if (3==type) {
        [self OnAtmosphereSubMessage:3];
    }else if (4==type) {
        [self OnAtmosphereSubMessage:4];
    }else if (5==type) {
   //     [self OnAtmosphereSubMessage:1];
    }
}


/*add by liteng for 发送气氛消息 20130420*/
-(void)OnAtmosphereSubMessage:(int)type
{
    if (0==type) {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62566:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }else if(1==type){
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62550:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }else if(2==type){
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62551:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }else if(3==type){
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62552:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }else if(4==type){
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62553:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
}

/*add by liteng for 响应沙锤代理消息*/
-(void)onHammerMessage
{
    [self OnAtmosphereSubMessage:0];
}

-(void) SaveLoginString
{
    NSString * filepath=[IphoneUTouchViewController dataFilePath];
    NSString *path=[filepath stringByAppendingPathComponent:@"/Login"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret;
    [fileManager changeCurrentDirectoryPath:filepath];
    ret=[fileManager createFileAtPath:@"Login" contents:nil attributes:nil];
    if(ret)
    {
        NSMutableData *writer=[[NSMutableData alloc] init];
        [writer appendData:[stringLogin dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:path atomically:YES];
        [writer release];
    }
}

-(void) Login:(BOOL)stat
{
    if(stat)
    {
        if([stringLogin isEqualToString:@"00000000"])
        {
            moreButton.hidden=YES;
            loginButton.hidden=NO;
            if(!first)
            {
                [self initFistNavigationController];
                [self.window insertSubview:first.view atIndex:0];
            }
        }
        else
        {
            moreButton.hidden=NO;
            loginButton.hidden=YES;
            //[self.viewController SaveLoginString];
            [self SaveLoginString];
            
            LiteDateBase * liteDB=[[LiteDateBase alloc]init];
            [liteDB OpenDB:@"Song.db"];
            int count=[liteDB GetRecordsCount];
            [liteDB CloseDB];
            [liteDB release];
            
            if(count>0)
            {
                lead_inViewContrl=[[Leading_inViewController alloc]initWithNibName:@"Leading_inViewController" bundle:nil];
                lead_inViewContrl.view.frame=CGRectMake(0,0,MainRect.size.width,MainRect.size.height);
                lead_inViewContrl.showDelegate=self;
                [self.window addSubview:lead_inViewContrl.view];
            }
            else
            {
                if(!first)
                {
                    [self initFistNavigationController];
                    [self.window insertSubview:first.view atIndex:0];
                }
            }
        }
                
        [loginViewContrl.view removeFromSuperview];
        [loginViewContrl release];
    }
    else
    {
        [loginViewContrl.view removeFromSuperview];
        [loginViewContrl release];
        leadViewContrl =[[LeadViewController alloc]initWithNibName:@"LeadViewController" bundle:nil];
        leadViewContrl.view.frame=CGRectMake(0, 0, 320,480);
        leadViewContrl.leadDelegate=self;
        [self.window addSubview:leadViewContrl.view];
    }
}

-(void) Lead:(BOOL) stat
{
    if(stat)
    {
        stringLogin=@"00000000";
        [stringLogin retain];
        [leadViewContrl.view removeFromSuperview];
        [leadViewContrl release];
        
        if(!first)
        {
            [self initFistNavigationController];
            [self.window insertSubview:first.view atIndex:0];
        }
        
        moreButton.hidden=YES;
        loginButton.hidden=NO;
    }
    else
    {
        [leadViewContrl.view removeFromSuperview];
        [leadViewContrl release];
        loginViewContrl=[[LoginViewController alloc]initWithNibName:nil bundle:nil];
        loginViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width, MainRect.size.height);
        loginViewContrl.loginDelegate=self;
        [self.window addSubview:self.loginViewContrl.view];
    }
}

-(void)ShowMenuAndInfo
{
    if(lead_inViewContrl)
    {
        [lead_inViewContrl.view removeFromSuperview];
        lead_inViewContrl=nil;
    }
    
    if(!first)
    {
        [self initFistNavigationController];
        [self.window insertSubview:first.view atIndex:0];
    }
}

-(void)CloseRoom
{
    if (moreToolsView.isPopup)
    {
        [moreToolsView hide];
    }
    if(first)
    {
        //[self.viewController SelfDownView];
        [self.viewController.view removeFromSuperview];
        [_viewController release];
        _viewController=nil;
        
        [first.view removeFromSuperview];
        [first release];
        first=nil;
        
        LoginViewController* tmLoginViewController =[[LoginViewController alloc]initWithNibName:nil bundle:nil];
        self.loginViewContrl =tmLoginViewController;
        [tmLoginViewController release];
        loginViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width, MainRect.size.height);
        loginViewContrl.loginDelegate=self;
        [self.window addSubview:self.loginViewContrl.view];
    }
}

-(BOOL)didDemoLink
{
    HOST_IP=DEMO_HOST_IP;
    HOST_PORT=DEMO_HOST_PORT;
    
    if (![self ConnectServer])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法连接到演示服务器，请稍后再试"
                                                    delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }

    [self initMainView];
    
    [self.window makeKeyAndVisible];

    return YES;
}


-(void)initMainView
{
    NSString * filePath=[IphoneUTouchViewController dataFilePath];
    
    NSString *desDirectory=[filePath stringByAppendingFormat:@"/Song.db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:desDirectory])
    {
        NSString *srcDirectory =[[NSBundle mainBundle] pathForResource:@"Song" ofType:@"db"inDirectory:@"Images"];
        [[NSFileManager defaultManager] copyItemAtPath: srcDirectory toPath:desDirectory error:nil];
    }
    
    rockView=[[RockViewController alloc] init];
    rockView.MyRockDelegate=self;
    [rockView.view setBackgroundColor:[UIColor grayColor]];
    
    moreToolsView=[[MoreToolsView alloc]initWithFrame:CGRectMake(0, MainRect.size.height-49, MainRect.size.width, 111)];
    moreToolsView.delegate=self;
    [self.window addSubview:moreToolsView];
    
    atmosphereViewController=[[AtmosphereViewController alloc] init];
    atmosphereViewController.myAtmosphereDelegate=self;
    
    UIImageView * toolView=[[UIImageView alloc]initWithImage:
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ToolBar" ofType:@"png"inDirectory:@"Images"] ]];
    toolView.frame=CGRectMake(0,MainRect.size.height-49, 320, 49);
    [self.window addSubview:toolView];
    [toolView release];
    
    UIImage *ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cut1" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cut" ofType:@"png"inDirectory:@"Images/"]];
    UIButton *cutButton = [[UIButton alloc] init];
    [cutButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [cutButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
    cutButton.frame=CGRectMake(2, MainRect.size.height-48, 61.6f, 48);
    cutButton.tag=1;
    [cutButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:cutButton];
    [cutButton release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YuanChang" ofType:@"png"inDirectory:@"Images/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BanChang" ofType:@"png"inDirectory:@"Images/"]];
    yuanButton = [[UIButton alloc] init];
    [yuanButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    yuanButton.frame=CGRectMake(2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    yuanButton.tag=2;
    [yuanButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:yuanButton];
    
    banButton = [[UIButton alloc] init];
    [banButton setBackgroundImage:ButtonImage1 forState:UIControlStateNormal];
    banButton.frame=CGRectMake(2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    banButton.tag=3;
    [banButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    banButton.hidden=YES;
    [self.window addSubview:banButton];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Play" ofType:@"png"inDirectory:@"Images/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Pause" ofType:@"png"inDirectory:@"Images/"]];
    playButton = [[UIButton alloc] init];
    [playButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    playButton.frame=CGRectMake(2+61.6f+2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    playButton.tag=4;
    [playButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:playButton];
    
    pauseButton = [[UIButton alloc] init];
    [pauseButton setBackgroundImage:ButtonImage1 forState:UIControlStateNormal];
    pauseButton.frame=CGRectMake(2+61.6f+2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    pauseButton.tag=5;
    [pauseButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    pauseButton.hidden=YES;
    [self.window addSubview:pauseButton];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yixuan3"  ofType:@"png"inDirectory:@"newImages/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yixuan2" ofType:@"png"inDirectory:@"newImages/"]];
    UIButton *seledButton = [[UIButton alloc] init];
    [seledButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [seledButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
    seledButton.frame=CGRectMake(2+61.6f+2+61.6f+2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    seledButton.tag=6;
    [seledButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:seledButton];
    [seledButton release];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"More1" ofType:@"png"inDirectory:@"Images/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"More" ofType:@"png"inDirectory:@"Images/"]];
    moreButton = [[UIButton alloc] init];
    [moreButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [moreButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
    moreButton.frame=CGRectMake(2+61.6f+2+61.6f+2+61.6f+2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    moreButton.tag=7;
    [moreButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:moreButton];
    
    ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"controlbar_button_in_room_up" ofType:@"png"inDirectory:@"Images/"]];
    ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"controlbar_button_in_room_down" ofType:@"png"inDirectory:@"Images/"]];
    loginButton = [[UIButton alloc] init];
    [loginButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
    loginButton.frame=CGRectMake(2+61.6f+2+61.6f+2+61.6f+2+61.6f+2, MainRect.size.height-48, 61.6f, 48);
    loginButton.tag=20;
    loginButton.hidden=YES;
    [loginButton addTarget:self action:@selector(ButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:loginButton];
    
    NSString * strLogin=[IphoneUTouchViewController GetLoginString];
    if([strLogin length]>0)
    {
        stringLogin=strLogin;
        [stringLogin retain];
        
        int ret=[IphoneUTouchViewController GetLoginStat];
        if(ret<0)
        {
            if(ret==-1)
            {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败,请确认服务器IP及端口后重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else if(ret==-2)
            {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆失败,请确认验证码,重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            leadViewContrl =[[LeadViewController alloc]initWithNibName:@"LeadViewController" bundle:nil];
            leadViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width,MainRect.size.height);
            leadViewContrl.leadDelegate=self;
            [self.window addSubview:leadViewContrl.view];
        }
        else
        {
            [self initFistNavigationController];
            [self.window insertSubview:first.view atIndex:0];
        }
    }
    else {
        leadViewContrl =[[LeadViewController alloc]initWithNibName:@"LeadViewController" bundle:nil];
        leadViewContrl.view.frame=CGRectMake(0, 0, MainRect.size.width,MainRect.size.height);
        leadViewContrl.leadDelegate=self;
        [self.window addSubview:leadViewContrl.view];
    }
    
#if TARGET_IPHONE_SIMULATOR
    self.window.layer.contents=(id)[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BG" ofType:@"jpg"inDirectory:@"Images"]] CGImage];
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"background"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.window.layer.contents=(id)[img CGImage];
    }
    else
    {
        self.window.layer.contents=(id)[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BG" ofType:@"jpg"inDirectory:@"Images"]] CGImage];
    }
#endif

#if 0
    /*add by liteng for 增回底部窗口栏 20130501*/
    CGRect currentRect= [[UIScreen mainScreen] bounds];
    if (568==currentRect.size.height) {
        UIImageView * tmpview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 480, 320, 88)];
        [tmpview setBackgroundColor:[UIColor blackColor]];
        [self.window addSubview:tmpview];
    }
    WelcomeView * tmpview1=[[WelcomeView alloc] initWithFrame:CGRectMake(0, 480, 320, 88)];
    [self.window addSubview:tmpview1];
#endif
    
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            exit(1);
            break;
        default:
            break;
    }
}

@end
