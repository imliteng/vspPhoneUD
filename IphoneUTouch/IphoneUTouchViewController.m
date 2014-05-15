//
//  IphoneUTouchViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IphoneUTouchViewController.h"
#import "CustomNavigationBar.h"

static NSString *kSongId   = @"id";
static NSString *kSinger   = @"singer";
static NSString *kSongName = @"songname";
static NSString *kLanguage = @"language";
static NSString *kisChange = @"ischange";
static NSString *kpid      = @"pid";
static NSString *kplOrder  = @"plorder";
static NSString *kprivatesongid  = @"privatesongid";
static NSString *kstarno  = @"starno";

extern NSString * HOST_IP;    
extern NSString * HOST_PORT;

extern NSString * stringLogin;

@interface IphoneUTouchViewController ()
{
    BOOL deallocFlag;
}

@end

@implementation IphoneUTouchViewController

@synthesize singerSelContrl;
@synthesize langugeSelContrl;
@synthesize songInfoContrller;
@synthesize workingEntry;
@synthesize workingPropertyString;

@synthesize elementsToParse;
@synthesize longConnClient;
@synthesize reConnTimer;

@synthesize ChangeDelegate;

@synthesize songSeledInfoContrller;

@synthesize closeRoomDelegate;

-(void)willAppearIn:(UINavigationController *)navigationController
{
    self.navigationController.navigationBar.backItem.title = @"Home";
    CustomNavigationBar* customNavigationBar = (CustomNavigationBar*)navigationController.navigationBar;
    customNavigationBar.tintColor = nil;
    [customNavigationBar clearBackground];
    MyIndex=0;
    MySeledIndex=0;
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    MyIndex=0;
    MySeledIndex=0;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.title=@"首页";
    
    self.edgesForExtendedLayout=UIRectEdgeNone; 

    deallocFlag=NO;
    
    mySqlite=[[LiteDateBase alloc]init];
    [mySqlite OpenDB:@"Song.db"];
    
    /*add by liteng for 增加私人曲库表与KTV信息表 20130508*/
    NSString *createSql=@"create table if not EXISTS personalSongInfo(songName text,language text,singerName text,songID text,IsHave text);";
    if ([mySqlite ExecSqlCmd:createSql])
        NSLog(@"create personalSongInfo is ok");
    else
        NSLog(@"create personalSongInfo is false");
    
    createSql=@"create table if not EXISTS ktvInfo(ktvID text);";
    if ([mySqlite ExecSqlCmd:createSql])
        NSLog(@"create ktvInfo is ok");
    else
        NSLog(@"create ktvInfo is false");
    
    //连接服务器，建立长连接
    longConnStat=NO;
    [self connectServer:HOST_IP port:[HOST_PORT intValue]];

    
    IsSeledShow=NO;
   //[self.navigationController. navigationBar addSubview:[UIImage imageNamed:@"Title.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0];
   
    //self.navigationItem.title=@"首页";
    
    /*UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Title" ofType:@"png"inDirectory:@"Images"]]];
	imgView.frame = CGRectMake(0, 0, 320, 44);
	[self.navigationController.navigationBar addSubview:imgView];
    [imgView release];*/
    
    /*add by liteng for 停用背景图 20130428*/
//    UIImageView * bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BG" ofType:@"jpg"inDirectory:@"Images"] ]];
//    bgView.frame=CGRectMake(0, 0, 320, 480);
//    [self.view addSubview:bgView];
//    [bgView release];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
   /* UIImageView * logoView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Logo" ofType:@"png"inDirectory:@"Images"] ]];
    logoView.frame=CGRectMake((320-90)/2, 0, 90, 39.5f);
    [self.navigationController.navigationBar addSubview:logoView];
    [logoView release];*/
    
    //歌星点歌
    CGRect rect= CGRectMake(21, 20, 83.5f, 98.5);
    UIImage * image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Singers" ofType:@"png"inDirectory:@"Images"]];
    MyButtonItem *item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:1];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];
    
    //语种点歌
    rect= CGRectMake(21+21+77.5f, 20, 83.5f, 98.5);
    image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Language" ofType:@"png"inDirectory:@"Images"]];
    item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:2];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];
    
    //拼音点歌
    rect= CGRectMake(21+21+77.5f+21+77.5f, 20, 83.5f, 98.5);
    image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PinYin" ofType:@"png"inDirectory:@"Images"]];
    item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:3];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];
    
    //新歌抢鲜
    rect= CGRectMake(21, 20+20+96, 83.5f, 98.5);
    image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewSong" ofType:@"png"inDirectory:@"Images"]];
    item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:4];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];
    
    //热门排行
    rect= CGRectMake(21+21+77.5f, 20+20+96, 83.5f, 98.5);
    image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HotSong" ofType:@"png"inDirectory:@"Images"]];
    item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:5];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];
    
    //私人收藏
    rect= CGRectMake(21+21+77.5f+21+77.5f, 20+20+96, 83.5f, 98.5);
    image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PrivateSong" ofType:@"png"inDirectory:@"Images"]];
    item1=[[MyButtonItem alloc]initWithFrameAndimage:rect Image:image Index:6];
    item1.touchdelegate=self;
    [self.view addSubview:item1];
    [item1 release];
    [image release];

    
   /* bgViewController=[[BGViewController alloc]initWithNibName:@"BGViewController" bundle:nil];
    bgViewController.view.frame=CGRectMake(0, 0, 320, 431);
    bgViewController.view.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgViewController.view];*/
    
    self.elementsToParse = [NSArray arrayWithObjects:kSongId,kSinger,kSongName,kLanguage,kisChange,kpid,kplOrder,kprivatesongid,kstarno,nil];
    self.workingPropertyString=[NSMutableString string];
    [self updateSongsNumber];
}

-(void) dealloc
{
    NSLog(@"dealloc IphoneUTouchViewController !!! ");
    deallocFlag=YES;
    
    if (reConnTimer) {
        [reConnTimer invalidate];
        [reConnTimer release];
    }
    
    [singerSelContrl release];
    [langugeSelContrl release];
    
    [songInfoContrller release];
    [songSeledInfoContrller release];
    
    [mySqlite CloseDB];
    [mySqlite release];
    
    [longConnClient release];
    
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

-(int)connectServer:(NSString *)hostIP port:(int)hostPort
{   
    if(longConnClient==nil)
    {   
        longConnClient=[[AsyncSocket alloc] initWithDelegate:self];   
        NSError *err=nil;   
        if(![longConnClient connectToHost:hostIP onPort:hostPort error:&err])
        {   
            NSLog(@"%@ %@",[err code],[err localizedDescription]);    
            return SRV_CONNECT_FAIL;   
        }
        else
        {
            return SRV_CONNECT_SUC;   
        }   
    }   
    else
    {   
        [longConnClient readDataWithTimeout:-1 tag:0];   
        return SRV_CONNECTED;   
    }   
}


- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{  
    if(longConnStat==NO)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000); 
        NSString* allStr = [[NSString alloc] initWithData:data encoding:enc];//NSUTF8StringEncoding];   
        
        NSString * secCode1=[[NSString alloc]initWithFormat:@"%@",[allStr substringWithRange:NSMakeRange(0,36)]];
        NSString * secCode2=[[NSString alloc]initWithFormat:@"%@",[allStr substringWithRange:NSMakeRange(36,32)]];
        NSString * secCode3=[[NSString alloc]initWithFormat:@"%@",[allStr substringWithRange:NSMakeRange(68,36)]];
        
        NSMutableString *String0 = [[NSMutableString alloc] initWithString:secCode1];
        [String0 appendFormat:[NSString stringWithFormat:secCode3]];
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:secCode3];
        [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
        [String1 appendFormat:[NSString stringWithFormat:secCode1]];
        
        NSData *senddata = [String1 dataUsingEncoding:NSUTF8StringEncoding];
        
        [longConnClient writeData:senddata withTimeout:-1 tag:1];
        
        [String0 release];
        [String1 release];
        [secCode1 release];
        [secCode2 release];
        [secCode3 release];
        [allStr release];  
        
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>longconn</which><validate>%@</validate></root>",stringLogin];
        
        NSLog(@"*****************%@",stringLogin);
        senddata = [sendBuff dataUsingEncoding:NSUTF8StringEncoding];
        longConnStat=YES;
        [longConnClient writeData:senddata withTimeout:-1 tag:1];
        [sendBuff release];
    }
    else
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000); 
        NSString* allStr = [[NSString alloc] initWithData:data encoding:enc]; 
        //NSLog(@"Hava received datas is :%@",allStr);   
        if([allStr length]>60)//有空的时侯
        {
            NSString *szOpt;
            NSString *param;
            NSString *param2;
            NSRange range1=[allStr rangeOfString:@"<opt>"];
            NSRange range2=[allStr rangeOfString:@"</opt>"];
            if(range1.length>=5 && range2.length>=6)
            {
                szOpt=[allStr substringWithRange:NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length)];
            }
            range1=[allStr rangeOfString:@"<param>"];
            range2=[allStr rangeOfString:@"</param>"];
            if(range1.length>=7 && range2.length>=8)
            {
                param=[allStr substringWithRange:NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length)];
            }
            range1=[allStr rangeOfString:@"<param2>"];
            range2=[allStr rangeOfString:@"</param2>"];
            if(range1.length>=7 && range2.length>=8)
            {
                param2=[allStr substringWithRange:NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length)];
            }
            if(szOpt && param && param2)
            {
                if([szOpt isEqualToString:@"muted"])
                {
                }
                else if([szOpt isEqualToString:@"selectsong"])
                {
                    [self ChangeSongsStat:param Type:0 Pid:param2];
                }
                else if([szOpt isEqualToString:@"delsong"])
                {
                    [self ChangeSongsStat:param Type:1 Pid:param2];
                }
                else if([szOpt isEqualToString:@"exchangesong"])//顶歌
                {
                    [self ChangeSongsStat:param Type:2 Pid:param2];
                }
                else if([szOpt isEqualToString:@"playstatus"])
                {
                    if([param isEqualToString:@"1"])
                    {
                        [self.ChangeDelegate ExChangePlayStat:YES];
                    }
                    if([param isEqualToString:@"2"])
                    {
                        [self.ChangeDelegate ExChangePlayStat:NO];
                    }
                }
                else if([szOpt isEqualToString:@"musicstatus"])
                {
                    if([param isEqualToString:@"0"])
                    {
                        [self.ChangeDelegate ExChangeMucStat:NO];
                    }
                    if([param isEqualToString:@"1"])
                    {
                        [self.ChangeDelegate ExChangeMucStat:YES];
                    }
                }
                else if ([szOpt isEqualToString:@"roomclose"])
                {
                    [self.closeRoomDelegate CloseRoom];
                }
            }
        }
        [allStr release];
    }
    [longConnClient readDataWithTimeout:-1 tag:0];   
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{   
    [longConnClient readDataWithTimeout:-1 tag:0];   
}   

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err   
{   
    NSLog(@"长连接willDisconnect"); 
    longConnStat=NO;
}   

- (void)onSocketDidDisconnect:(AsyncSocket *)sock   
{        
    longConnClient = nil;
    NSLog(@"长连接Disconnect");
    if (!deallocFlag) {
        reConnTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(OnReConnect) userInfo:nil repeats:YES];
    }
}   

- (void)onSocketDidSecure:(AsyncSocket *)sock
{   
    
}   

-(int)OnReConnect
{   
    NSLog(@"重新连接");
    int stat=[self connectServer:HOST_IP port:[HOST_PORT intValue]];  
    if(stat>=0)
    {
        [reConnTimer invalidate];
    }
    return stat;
}   



-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid
{
    if(MyIndex==1)//歌星点歌在显示中
    {
        [self.singerSelContrl ChangeSongsStat:songId Type:type Pid:pid];
    }
    else if(MyIndex==2)//语种点歌在显示中
    {
        [self.langugeSelContrl ChangeSongsStat:songId Type:type Pid:pid];
    }
    else if(MyIndex==3 || MyIndex==4 || MyIndex==5|| 6==MyIndex)
    {
        [self.songInfoContrller ChangeSongsStat:songId Type:type Pid:pid];
    }
    if (MySeledIndex==1)
    {
        [self.songSeledInfoContrller ChangeSongsStat:songId Type:type Pid:pid];
    }
}

-(void)TouchUpDegate:(NSInteger)index
{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//    temporaryBarButtonItem.title = @"首页";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    if(index==1)
    {
       MyIndex=1;
        
       SingersSelViewController * singerSelContrlTmp=[[SingersSelViewController alloc]initWithNibName:@"SingersSelViewController" bundle:nil];
        
        self.singerSelContrl=singerSelContrlTmp;
        [singerSelContrlTmp release];

        [self.navigationController pushViewController:self.singerSelContrl animated:YES];
    }
    else if(index==2)
    {
        MyIndex=2;
        
        LangugeViewController * langugeSelContrlTmp=[[LangugeViewController alloc]initWithNibName:@"LangugeViewController" bundle:nil];
        self.langugeSelContrl=langugeSelContrlTmp;
        [langugeSelContrlTmp release];
        [self.navigationController pushViewController:self.langugeSelContrl animated:YES];
    }
    else if (index==3)
    {
        MyIndex=3;
        SongInViewController * ContrlTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:8 Id:@"" Name:@"拼音点歌" ];
        self.songInfoContrller=ContrlTmp;
        [ContrlTmp release];
        [self.navigationController pushViewController:self.songInfoContrller animated:YES];
    }
    else if(index==4)
    {
        MyIndex=4;
        
        SongInViewController * ContrlTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:9 Id:@"" Name:@"新歌抢鲜" ];
        self.songInfoContrller=ContrlTmp;
        [ContrlTmp release];

        [self.navigationController pushViewController:self.songInfoContrller animated:YES];
    }
    else if(index==5)
    {
        MyIndex=5;
        
        SongInViewController * ContrlTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:10 Id:@"" Name:@"热门排行" ];
        self.songInfoContrller=ContrlTmp;
        [ContrlTmp release];
        
        [self.navigationController pushViewController:self.songInfoContrller animated:YES];
    }
    /*add by liteng for 添加私人曲库界面 20130407*/
    else if(6==index)
    {
        MyIndex=6;
        
        SongInViewController * ContrlTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:12 Id:@"" Name:@"私人曲库" ];
        self.songInfoContrller=ContrlTmp;
        [ContrlTmp release];
        [self.navigationController pushViewController:self.songInfoContrller animated:YES];
    }
    
    //int conut=self.navigationController.childViewControllers.count ;
   // NSLog(@"%d",conut);
}

-(void) ToolBarClick:(int) tag
{
    //if(MyIndex==1)
    //{
    //    [self.singerSelContrl RefreshData];
    //}
    if(tag==1)//切歌
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61520:0:0</param><userid>0</userid><ispid>0</ispid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==2)//原唱
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61514:0:0</param><userid>0</userid><ispid>0</ispid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if (tag==3)//伴唱
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61515:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if (tag==4)//播放
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61521:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==5)//暂停
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61522:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==6)//已选
    {
        if(MyIndex==0)
        {
            UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//            temporaryBarButtonItem.title = @"首页";
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            [temporaryBarButtonItem release];
        }
        
        MySeledIndex=1;
        if(!IsSeledShow)
        {
            SongInViewController * ContrlTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:11 Id:@"" Name:@"已选歌曲" ];
            self.songSeledInfoContrller=ContrlTmp;
            [self.songSeledInfoContrller viewDidAppear:YES];
            [ContrlTmp release];
            [self.navigationController pushViewController:self.songSeledInfoContrller animated:YES];
            //self.songSeledInfoContrller.delegate=self;
            
           // [self presentModalViewController:self.songSeledInfoContrller  animated:YES];
        }
       // else
        //{
       //     [self dismissModalViewControllerAnimated:YES];
       // }
    }
    else if(tag==8)//音乐减
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62041:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==9)//音乐加
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62040:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==10)//麦克减
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62021:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==11)//麦克加
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62020:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==12)// 重唱
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61517:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==13)//静音
    {
        static int n=0;
        if(n==0)
        {
            NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61527:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
            [IphoneUTouchViewController SendCmdToServer:sendBuff];
            [sendBuff release];
            n=1;
        }
        else if(n==1)
        {
            NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>61528:0:0</param><userid>0</userid><ispid>0</ispid></operation><validate>%@</validate></root>",stringLogin];
            [IphoneUTouchViewController SendCmdToServer:sendBuff];
            [sendBuff release];
            n=0;
        }
    }
    else if(tag==14)//换房
    {
        
    }
    else if(tag==15)//服务
    {
        NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>purecmd</opt><param>62490:0:0</param><ispid>0</ispid><userid>0</userid></operation><validate>%@</validate></root>",stringLogin];
        [IphoneUTouchViewController SendCmdToServer:sendBuff];
        [sendBuff release];
    }
    else if(tag==16)
    {
        
    }
}


+(NSString*) md5:(NSString*) str
{  
    const char *cStr = [str UTF8String];  
    unsigned char result[32];  
    CC_MD5(cStr,strlen(cStr),result);  
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",  
            result[0],result[1],result[2],result[3],  
            result[4],result[5],result[6],result[7],  
            result[8],result[9],result[10],result[11],  
            result[12],result[13],result[14],result[15]
            ];  
} 

+(NSData*)RequestFromServer:(NSString*)sendBuff
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return nil;
    }
    
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        [sock release];
        return nil;
    }
    
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];  
    NSMutableString* readString3 = [[NSMutableString alloc] init];
    
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [sock CloseSocket];
        [sock release];
        return nil;
    }

    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [sock CloseSocket];
        [sock release];
        return nil;
    }

    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    //NSLog(@"验证码3：%s",readString);
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:5];
    if(ret<0)
    {
        [String0 release];
        [String1 release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];//114.132.246.134
    [readString3 release];
  
    
    //NSLog(@"发送数据：%@",sendBuff);
    ret=[sock SendNS:[sendBuff UTF8String] SendSize:[sendBuff length] SendTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    
    char readBuff[9]={0};
    ret=[sock ReadN:readBuff ReadSize:8 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    int xmlLen=atoi(readBuff);
    
    char* readxml = (char *)malloc(xmlLen+30000);
    memset(readxml,0, xmlLen+30000);
    ret=[sock ReadN:readxml ReadSize:xmlLen ReadTimeOut:5];
    if(ret<0)
    {
        free(readxml);
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    NSString *str=[NSString stringWithFormat:@"%s",readxml];
    
    NSString* sc = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"转码后:%@",sc);
    
    NSData* data = [sc dataUsingEncoding: NSUTF8StringEncoding];
    free(readxml);
    
    NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *contentString = [str1 stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    NSData * data1=[contentString dataUsingEncoding:NSUTF8StringEncoding];
    
    [str1 release];
    
    [sock CloseSocket];
    [sock release];
    return data1;
}

+(int)GetRecordsCount:(NSString *) sendBuff
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return -11;
    }
        
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        /*modify by liteng for 连接失败重新连接 20130426*/
        ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
        NSLog(@"the test servers address is %@:%@",HOST_IP,HOST_PORT);
        if(ret<0)
        {
            NSLog(@"链接错误");
            [sock release];
            return -1;
        }
//        NSLog(@"链接错误");
//        [sock release];
//        return -1;
    }
        
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];
    NSMutableString* readString3 = [[NSMutableString alloc] init];
        
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
            
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -2;
    }
    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -3;
    }
    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -4;
    }
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
        
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    //ret=[sock SendN:String1 SendSize:104 SendTimeOut:5];
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [String0 release];
        [String1 release];
        return -5;
    }
        
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];
    [readString3 release];
   
    ret=[sock SendNS:[sendBuff UTF8String] SendSize:[sendBuff length] SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -6;
    }
        
    char readBuff[9]={0};
    ret=[sock ReadN:readBuff ReadSize:8 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -7;
    }
    int count=atoi(readBuff);
        
    memset(readBuff,0, 9);
        
    ret=[sock ReadN:readBuff ReadSize:8 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -8;
    }
    int iABCLen=atoi(readBuff);
    char stringABCBuff[27]={0};
    ret=[sock ReadN:stringABCBuff ReadSize:iABCLen ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -9;
    }
        
    [sock CloseSocket];
    [sock release];
    return count;
}

+(int)SendCmdToServer:(NSString *)strCMD
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return -1;
    }
    
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        [sock release];
        NSLog(@"%@",@"链接错误");
        return -1;
    }
    
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];
    NSMutableString* readString3 = [[NSMutableString alloc] init];
    
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        return -1;
    }
    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -1;
    }
    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -1;
    }
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    //ret=[sock SendN:String1 SendSize:104 SendTimeOut:5];
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [String0 release];
        [String1 release];
        return -1;
    }
    
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];
    [readString3 release];
    
    //NSLog(@"################################%@",strCMD);
    //ret=[sock SendN:strCMD SendSize:[strCMD length] SendTimeOut:5];
    ret=[sock SendNS:[strCMD UTF8String] SendSize:[strCMD length] SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -1;
    }
    [sock CloseSocket];
    [sock release];
    return 0;

}

+(NSString *) dataFilePath
{
#if TARGET_IPHONE_SIMULATOR
    return @"/Users/vv/Documents/IphoneUTouch/IphoneUTouch/IphoneUTouch/Images1";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#endif
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

+(NSString *)GetLoginString
{
    NSError *error=nil;
    NSString *sFileContents;
    NSString* sFilePath=[IphoneUTouchViewController dataFilePath]; 
    NSString *path=[sFilePath stringByAppendingPathComponent:@"/Login"];
    NSFileManager *file_manager=[NSFileManager defaultManager];
    BOOL ret=[file_manager fileExistsAtPath:path];
    if(!ret)
    {
        return nil;
    }
    sFileContents=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return sFileContents;
}

+(int) GetLoginStat
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return -2;
    }
    
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        NSLog(@"链接错误");
        [sock release];
        return -1;
    }
    
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];
    NSMutableString* readString3 = [[NSMutableString alloc] init];
    
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -2;
    }
    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -2;
    }
    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return -2;
    }
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    //ret=[sock SendN:String1 SendSize:104 SendTimeOut:5];
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [String0 release];
        [String1 release];
        
        return -2;
    }
    
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];
    [readString3 release];
    NSString *sendBuff;
    sendBuff=[[NSString alloc]initWithFormat:@"<root><which>validate</which><query><class>song</class><type>playlist</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    
    ret=[sock SendNS:[sendBuff UTF8String] SendSize:[sendBuff length] SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [sendBuff release];
        return -2;
    }
    
    [sendBuff release];
    
    char readBuff[3]={0};
    ret=[sock ReadN:readBuff ReadSize:1 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return -2;
    }
    
    //NSLog(@"返回为%s",readBuff);
    
    [sock CloseSocket];
    [sock release];
    
    int iRet=atoi(readBuff);
    if(iRet==1)
    {
        return 1;
    }
    else if(iRet==2)
    {
        return -2;
    }
    return 1;
    
}

/*add by liteng for 获取KTVID信息 20130507*/

+(NSString*)GetKTVIDInfo
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return nil;
    }
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        NSLog(@"链接错误    1");
        [sock release];
        return nil;
    }
    
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];
    NSMutableString* readString3 = [[NSMutableString alloc] init];
    
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    //ret=[sock SendN:String1 SendSize:104 SendTimeOut:5];
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [String0 release];
        [String1 release];
        return nil;
    }
    
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];
    [readString3 release];
    
    NSString *sendBuff=nil;
    sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>system</class><type>ktvid</type><querycount>false</querycount><order></order><position>1</position><pagesize>1</pagesize><pinyin></pinyin><condition></condition></query><validate>%@</validate></root>",stringLogin];
    
    ret=[sock SendNS:[sendBuff UTF8String] SendSize:[sendBuff length] SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [sendBuff release];
        
        return nil;
    }
    
    [sendBuff release];
    
    char readBuff[9]={0};
    memset(readBuff, 0, 9);
    ret=[sock ReadN:readBuff ReadSize:8 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    
    //    NSLog(@"接受的字符串为[%s]",readBuff);
    [sock CloseSocket];
    [sock release];
    NSString *  ktvIdString=[NSString stringWithFormat:@"%s",readBuff];
    return ktvIdString;
}

-(void)DownView
{
    if(IsSeledShow)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) SelfDownView
{
    if(IsSeledShow)
    {
        [self dismissModalViewControllerAnimated:YES];
    }  
}

/*add by liteng for 更新歌号 20130508*/
-(void)updateSongsNumber
{
  if ([mySqlite getKTVCountRows]==0)
  {
      NSString * cmdSqlString=[[NSString alloc] initWithFormat:@"INSERT INTO ktvInfo(ktvID) VALUES('%@')",
                               [IphoneUTouchViewController GetKTVIDInfo]];
      NSLog(@"%@",cmdSqlString);
      if ([mySqlite ExecSqlCmd:cmdSqlString])
          NSLog(@"INSERT INTO ktvInfo(ktvID) SQL OK");
      else
          NSLog(@"INSERT INTO ktvInfo(ktvID) SQL ERROR");
      [self doUpdateSongsNumber];
  }
  if ([mySqlite getKTVCountRows]>0)
  {
      NSString * lastKtvID=[mySqlite getLastKtvID];
      NSString * currentKtvID=[IphoneUTouchViewController GetKTVIDInfo];
      [lastKtvID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      [currentKtvID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      if (![lastKtvID isEqualToString:currentKtvID]) {
          NSString * cmdSqlString=[[NSString alloc] initWithFormat:@"UPDATE ktvInfo SET ktvID='%@'",
                                   [IphoneUTouchViewController GetKTVIDInfo]];
          NSLog(@"%@",cmdSqlString);
          if ([mySqlite ExecSqlCmd:cmdSqlString])
              NSLog(@"INSERT INTO ktvInfo(ktvID) SQL OK");
          else
              NSLog(@"INSERT INTO ktvInfo(ktvID) SQL ERROR");
          [self doUpdateSongsNumber];
      }
  }
}

/*add by liteng for 更新歌号 20130508*/
-(void)doUpdateSongsNumber
{
    NSMutableArray * personalSongArray=[mySqlite getAllPrivateSongsInfo];
    for (SongRecord * tmpRecord in personalSongArray) {
        NSString * songInfoString=[NSString stringWithFormat:@"%@_%@_%@_%@",tmpRecord.privateId,tmpRecord.songname,tmpRecord.singer,tmpRecord.language];
        NSString * songNumber=[self getSongNumFromCurrentServer:songInfoString];
        if([songNumber isEqualToString:@"00000000"])
        {
            NSString *cmdSqlString=[NSString stringWithFormat:@"UPDATE personalSongInfo SET IsHave='0' WHERE songName='%@' AND singerName='%@' AND language='%@'",tmpRecord.songname,tmpRecord.singer,tmpRecord.language];
            if ([mySqlite ExecSqlCmd:cmdSqlString])
                NSLog(@"INSERT INTO ktvInfo(ktvID) SQL OK");
            else
                NSLog(@"INSERT INTO ktvInfo(ktvID) SQL ERROR");
        }
        else
        {
            NSString *cmdSqlString=[NSString stringWithFormat:@"UPDATE personalSongInfo SET IsHave='1',songID='%@' WHERE songName='%@' AND singerName='%@' AND language='%@'",songNumber,tmpRecord.songname,tmpRecord.singer,tmpRecord.language];
            if ([mySqlite ExecSqlCmd:cmdSqlString])
                NSLog(@"INSERT INTO ktvInfo(ktvID) SQL OK");
            else
                NSLog(@"INSERT INTO ktvInfo(ktvID) SQL ERROR");
        }
    }
}

/*add by liteng for 更新歌号 20130508*/
-(NSString *)getSongNumFromCurrentServer:(NSString *)songInfo
{
    haveSongFlag=YES;
    NSData *data=[self requestSong:songInfo];
    if (!haveSongFlag) {
        return @"00000000";
    }
    else{
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
        return self.workingEntry.songId;
    }
}

-(NSData*)requestSong:(NSString *)songInfo
{
    int ret=0;
    AppSelSocket *sock=[[AppSelSocket alloc]init];
    ret=[sock initSocket];
    if(ret<0)
    {
        [sock release];
        return nil;
    }
    ret=[sock TcpCall:HOST_IP HostPort:[HOST_PORT intValue]];
    if(ret<0)
    {
        NSLog(@"链接错误    1");
        [sock release];
        return nil;
    }
    
    NSMutableString* readString1 = [[NSMutableString alloc] init];
    NSMutableString* readString2 = [[NSMutableString alloc] init];
    NSMutableString* readString3 = [[NSMutableString alloc] init];
    
    char readString[37]={0};
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString1 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:32 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString2 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    ret=[sock ReadN:readString ReadSize:36 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        return nil;
    }
    [readString3 appendFormat:[NSString stringWithFormat:@"%s",readString]];
    memset(readString, 0, 37);
    
    NSMutableString *String0 = [[NSMutableString alloc] initWithString:readString1];
    [String0 appendFormat:[NSString stringWithFormat:readString3]];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:readString3];
    [String1 appendFormat:[NSString stringWithFormat:[IphoneUTouchViewController md5:String0]]];
    [String1 appendFormat:[NSString stringWithFormat:readString1]];
    //ret=[sock SendN:String1 SendSize:104 SendTimeOut:5];
    ret=[sock SendNS:[String1 UTF8String] SendSize:104 SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        [readString1 release];
        [readString2 release];
        [readString3 release];
        
        [String0 release];
        [String1 release];
        return nil;
    }
    
    [String0 release];
    [String1 release];
    [readString1 release];
    [readString2 release];
    [readString3 release];
    

    NSString *sendBuff=nil;
   
    sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>privatesong</class><type>querysong</type><condition>%@</condition><querycount>false</querycount><position>1</position></query><validate>%@</validate></root>",songInfo,stringLogin];
    NSLog(@"发送XML=====%@",sendBuff);
    
    ret=[sock SendNS:[sendBuff UTF8String] SendSize:[sendBuff length] SendTimeOut:3];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        [sendBuff release];
        
        return nil;
    }
    
    [sendBuff release];
    
    char readBuff[9]={0};
    memset(readBuff, 0, 9);
    ret=[sock ReadN:readBuff ReadSize:8 ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        return nil;
    }
    
//    NSLog(@"+++++++++接受的字符串为[%s]",readBuff);
    
    /* add by liteng for 预约号与歌曲信息获取的处理 20130418*/

    if(!strcmp("00000000", readBuff)){
        NSLog(@"未找歌曲信息");
        haveSongFlag=NO;
        return nil;
    }
    reserveNO=atoi(readBuff);
    
    int xmlLen=atoi(readBuff);
    char* readxml = (char *)malloc(xmlLen+10000);
    memset(readxml,0, xmlLen+10000);
    ret=[sock ReadN:readxml ReadSize:xmlLen ReadTimeOut:5];
    if(ret<0)
    {
        [sock CloseSocket];
        [sock release];
        
        free(readxml);
        return nil;
    }
    
//    NSLog(@"接受的字符串为[%s]",readxml);
    
    NSString *str=[NSString stringWithFormat:@"%s",readxml];
    
    NSString* sc = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"转码后:%@",sc);
    
    NSData* data = [sc dataUsingEncoding: NSUTF8StringEncoding];
    free(readxml);
    
    NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *contentString = [str1 stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    NSData * data1=[contentString dataUsingEncoding:NSUTF8StringEncoding];
    [str1 release];
    
    [sock CloseSocket];
    [sock release];
    return data1;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"song"])
	{
        self.workingEntry =[[[SongRecord alloc] init] autorelease];
    }
    storingCharacterData = [elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData)
    {
        [workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.workingEntry)
	{
        if (storingCharacterData)
        {
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [workingPropertyString setString:@""];
            /*if([elementName isEqualToString:kCount])
             {
             count=[trimmedString intValue];
             NSLog(@"************************************%@",trimmedString);
             }*/
            if([elementName isEqualToString:kSongId])
            {
                //NSLog(@"歌曲ID%@",trimmedString);
                self.workingEntry.songId= trimmedString;
            }
            else if ([elementName isEqualToString:kSinger])
            {
                //NSLog(@"演唱者%@",trimmedString);
                trimmedString=[trimmedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                self.workingEntry.singer = trimmedString;
                //NSLog(@"演唱者%@",trimmedString);
            }
            else if ([elementName isEqualToString:kSongName])
            {
                //NSLog(@"歌名%@",trimmedString);
                trimmedString=[trimmedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                self.workingEntry.songname = trimmedString;
            }
            else if ([elementName isEqualToString:kLanguage])
            {
                self.workingEntry.language = trimmedString;
            }
            else if([elementName isEqualToString:kisChange])
            {
                if([trimmedString isEqualToString:@"true"])
                {
                    self.workingEntry.isChange=YES;
                }
                if([trimmedString isEqualToString:@"false"])
                {
                    self.workingEntry.isChange=NO;
                }
            }
            else if ([elementName isEqualToString:kpid])
            {
                self.workingEntry.pid = trimmedString;
            }
            else if ([elementName isEqualToString:kplOrder])
            {
                self.workingEntry.plOrder = trimmedString;
            }
            else if([elementName isEqualToString:kprivatesongid])
            {
                self.workingEntry.privateId=trimmedString;
            }
            else if([elementName isEqualToString:kstarno])
            {
                self.workingEntry.singerString=trimmedString;
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
//    [delegate parseErrorOccurred:parseError];
}

@end
