//
//  SongInViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongInViewController.h"
#import "IphoneUTouchViewController.h"

#import "IphoneUTouchAppDelegate.h"

#import "SongRecord.h"
#import "MyAppCell.h"

extern NSString *stringLogin;
extern BOOL IsSeledShow;

extern NSString *HOST_IP;
extern NSString *HOST_PORT;
extern CGRect MainRect;

@interface SongInViewController ()

@end

@implementation SongInViewController

@synthesize MySongsInfoQueue;
@synthesize MySongsInfoTable;
@synthesize songsInfoRecordArray;
@synthesize sID;
@synthesize sName;
@synthesize iType;
@synthesize textField;
@synthesize searchViewEx;
@synthesize searchButton;
@synthesize szSongABC;
@synthesize searchSongViewController;
@synthesize BKImageView;
@synthesize PromptView;
@synthesize privateSongsInfoArray;
@synthesize ktvID;
@synthesize threadCount;
@synthesize delegate;
@synthesize myRecordCount;
@synthesize myTrueRecordCount;

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    if(self.iType==11)
    {
        IsSeledShow=YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.iType==11)
    {
        IsSeledShow=NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type Id:(NSString*)iid Name:(NSString*)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sID=iid;
        self.sName=name;
        self.iType=type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    searchButton = [[UIBarButtonItem alloc]
               initWithTitle:@"查找"
               style:UIBarButtonItemStylePlain
               target:self
               action:@selector(loadSearchView)];
    if(self.iType!=11&&self.iType!=12) // 已选页面与私人曲库不加查询按钮
        [self.navigationItem setRightBarButtonItem:searchButton];

    
    mySqlite=[[LiteDateBase alloc]init];
    [mySqlite OpenDB:@"Song.db"];
    
    
    isSearchByABC=NO;
    isSeled=YES;
    myRecordCount=12;
    self.threadCount=0;
    self.navigationItem.title=self.sName;
    if(self.iType!=11)
    {
        searchViewEx=[[UIView alloc] initWithFrame:CGRectMake(0, -40, 320, 40)];
        
        UIImageView * searchView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Search" ofType:@"png"inDirectory:@"Images"] ]];
        searchView.frame=CGRectMake(0, 0, 320, 40);
        [searchViewEx addSubview:searchView];
        [searchView release];
    
        searchView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Search1" ofType:@"png"inDirectory:@"Images"] ]];
        searchView.frame=CGRectMake(20, 12, 20, 20);
        [searchViewEx addSubview:searchView];
        [searchView release];
        
        textField=[[UITextField alloc] initWithFrame:CGRectMake(40.0f,10.0f,260.0f,22.0f)]; 
        [textField setBorderStyle:UITextBorderStyleNone];        //外框类型 
        textField.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        textField.placeholder=@"歌曲名首字母 如:十年为sn";    //默认显示的字
        [textField setKeyboardType:UIKeyboardTypeDefault];  //键盘样式:数字键盘
        textField.textColor=[UIColor grayColor];
        textField.textAlignment = UITextAlignmentCenter;
        //textField.secureTextEntry=YES;//密码 
        textField.autocorrectionType=UITextAutocorrectionTypeNo; 
        textField.autocapitalizationType=UITextAutocapitalizationTypeNone; 
        textField.returnKeyType=UIReturnKeyDone; 
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;//编辑时会出现个修改X 
        textField.delegate = self;
        
        textField.text=@"";
        [searchViewEx addSubview:textField];
        searchViewShowFlag=NO;
        
    }
    else 
    {
        UIImageView * SeledBGImage=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SeledBG" ofType:@"png"inDirectory:@"Images"] ]];
        SeledBGImage.frame=CGRectMake(0, 0, 320, 40);
        [self.view addSubview:SeledBGImage];
        [SeledBGImage release];
        
        seledImage=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Seled" ofType:@"png"inDirectory:@"Images"] ]];
        seledImage.frame=CGRectMake((320-208)/2, 5, 208, 30);
        seledImage.hidden=NO;
        [self.view addSubview:seledImage]; 
        
        songedImage=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Songed" ofType:@"png"inDirectory:@"Images"] ]];
        songedImage.frame=CGRectMake((320-208)/2, 5, 208, 30);
        songedImage.hidden=YES;
        [self.view addSubview:songedImage];
    }
    
    [self getRecords];
    
    self.privateSongsInfoArray=[mySqlite getAllPrivateSongsInfo]; // add by liteng for 获得私人曲库所有数据 20130427
    
    CGRect tableRect;
    
    if(self.iType!=11)
        tableRect=CGRectMake(0,0,MainRect.size.width,MainRect.size.height-44-49);
    else
        tableRect=CGRectMake(0,40,MainRect.size.width,MainRect.size.height-44-49-40);
    
    MySongsInfoTable=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    MySongsInfoTable.backgroundColor=[UIColor clearColor];
    MySongsInfoTable.dataSource=self;
    MySongsInfoTable.delegate=self;
    MySongsInfoTable.separatorStyle=NO;//去掉分割线
    MySongsInfoTable.tag=1;
    MySongsInfoTable.showsVerticalScrollIndicator=NO;//隐藏滚动条
    MySongsInfoTable.rowHeight=49.5f;
    MySongsInfoTable.UserInteractionEnabled=YES;
    [self.view addSubview:MySongsInfoTable];
    
    if (searchViewEx) 
        [self.view addSubview:searchViewEx];
    
    /* add by liteng for 拼音查询自动载入搜索框 20130422*/
    if (8==iType) 
     [self loadSearchView];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    /*add by liteng for 获取KTVID 20130507*/
    NSString * tmpKTVIDString=[[NSString alloc] initWithString:[IphoneUTouchViewController GetKTVIDInfo]];
    self.ktvID=tmpKTVIDString;
    [tmpKTVIDString release];
    
}

-(void) getRecords
{
    if(!isSearchByABC)
    {
        NSString * sendBuff=nil;
        if(self.iType==0)//按歌星名查询歌曲
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>star</type><querycount>true</querycount><position>1</position></query><validate>%@</validate><condition>%@</condition></root>",stringLogin,self.sID];
        }
        //语种查询歌曲
        else if(self.iType==1 || self.iType==2 ||self.iType==3 || self.iType==4 || self.iType==5 || self.iType==6 ||self.iType==7)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>%d</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",self.iType-1, stringLogin];
        }
        else if(self.iType==8)//拼音点歌
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if(self.iType==9)//新歌抢鲜
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if(self.iType==10)//热门排行
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if(self.iType==11)//已选歌曲
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>playlist</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        
        /*modify by liteng for 从私人曲库获取记录数 201304047*/
        if (12==self.iType)
        {
            myTrueRecordCount=[mySqlite getPersonalSongCount];
        }
        else
        {
            //singersType:1 华人男星
            myTrueRecordCount=[IphoneUTouchViewController GetRecordsCount:sendBuff];
            [sendBuff release];
        }
        
        if(myTrueRecordCount<=0)
        {
            self.songsInfoRecordArray = [[NSMutableArray alloc] initWithCapacity:80000];
            for(int i=0;i<80000;i++)
            {
                [self.songsInfoRecordArray addObject:[NSNull null]];
            }
        }
        else
        {
            self.songsInfoRecordArray = [[NSMutableArray alloc] initWithCapacity:myTrueRecordCount];
            for(int i=0;i<myTrueRecordCount;i++)
            {
                [self.songsInfoRecordArray addObject:[NSNull null]];
            }
        }
    
        self.MySongsInfoQueue = [[NSOperationQueue alloc] init];
        [self.MySongsInfoQueue setMaxConcurrentOperationCount:12];
        
        if(myTrueRecordCount<12)
        {
            for(int i=0;i<myTrueRecordCount;i++)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:0 Condition:@"" SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
        }
        else
        {
            for(int i=0;i<12;i++)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:0   Condition:@"" SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
        }
    }
    else
    {
        NSString * sendBuff=nil;
        if(self.iType==0)//按歌星名查询歌曲
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>star</type><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate><condition>%@</condition></root>",self.szSongABC,stringLogin,self.sID];
        }
        //语种查询歌曲
        else if(self.iType==1 || self.iType==2 ||self.iType==3 || self.iType==4 || self.iType==5 || self.iType==6 ||self.iType==7)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>%d</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",self.iType-1,self.szSongABC, stringLogin];
        }
        else if (self.iType==8)//拼音点歌
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",self.szSongABC, stringLogin];
        }
        else if(self.iType==9)//新歌抢鲜
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",self.szSongABC, stringLogin];
        }
        else if(self.iType==10)//热门排行
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",self.szSongABC,stringLogin];
        }
        else if(self.iType==11)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>sung</type><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        
        //singersType:1 华人男星 
        myTrueRecordCount=[IphoneUTouchViewController GetRecordsCount:sendBuff];
        if(myTrueRecordCount<=0)
        {
            self.songsInfoRecordArray = [[NSMutableArray alloc] initWithCapacity:80000];
            for(int i=0;i<80000;i++) 
            {
                [self.songsInfoRecordArray addObject:[NSNull null]];
            }
        }
        else
        {
            self.songsInfoRecordArray = [[NSMutableArray alloc] initWithCapacity:myTrueRecordCount];
            for(int i=0;i<myTrueRecordCount;i++) 
            {
                [self.songsInfoRecordArray addObject:[NSNull null]];
            }
        }
        
        [sendBuff release];
        
        self.MySongsInfoQueue = [[NSOperationQueue alloc] init];
        [self.MySongsInfoQueue setMaxConcurrentOperationCount:12];
        if(myTrueRecordCount<12)
        {
            for(int i=0;i<myTrueRecordCount;i++)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:1 Condition:self.szSongABC SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
        }
        else
        {
            for(int i=0;i<12;i++)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:1   Condition:self.szSongABC SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
        }
    }
}

-(void) dealloc
{

    [mySqlite CloseDB];
    [mySqlite release];
    
    [MySongsInfoQueue cancelAllOperations];
    [MySongsInfoQueue release];
    [MySongsInfoTable release];
    [sID release];
    [sName release];
    [textField release];
    [songsInfoRecordArray release];
    [szSongABC release];
    [seledImage release];
    [songedImage release];
    [searchSongViewController release];
    [ktvID release];

    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField 
{
	[aTextField resignFirstResponder];
    NSLog(@"%@",textField.text);
    //[self loadSearchView];
    self.szSongABC =textField.text;
    [self SearchSongsByABC:self.szSongABC];
 	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)handleLoadedApps:(NSIndexPath *)indexpath
{
    if(self.MySongsInfoTable!=nil)
    {
        MyAppCell *cell = (MyAppCell *)[self.MySongsInfoTable cellForRowAtIndexPath:indexpath];
        SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexpath.row];
        if(apprecord!=nil && cell)
        {
            [cell setCell:apprecord.songname songLanguage:apprecord.language Singer:apprecord.singer SingerIdString:apprecord.singerString];  // modify by liteng for 增加歌手编号字符串
            /*add by liteng for 增加对私人歌曲的处理 20130427*/
            if (12!=iType) {
                if ([self isPrivateHaveSongInfo:apprecord]) {
                    UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
                    UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
                    [cell.collectButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                    [cell.collectButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
                    cell.collectButton.tag=102;
                }else{
                    UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                    UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                    [cell.collectButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                    [cell.collectButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
                    cell.collectButton.tag=100;
                }
            }
        }
        [indexpath release];
    }
}

- (void)didFinishParsing:(SongRecord *)appRecord index:(NSIndexPath*)index 
{
    if(appRecord!=nil && index!=nil)
    {
        [index retain];
        
        [self.songsInfoRecordArray replaceObjectAtIndex:index.row withObject:(SongRecord*)appRecord];
        self.threadCount--;
        [self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:index waitUntilDone:NO];
    }
}


- (void)handleError:(NSError *)error
{
    /* NSString *errorMessage = [error localizedDescription];
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Record"
     message:errorMessage
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alertView show];
     [alertView release];*/
}

- (void)parseErrorOccurred:(NSError *)error
{
    //[self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(myTrueRecordCount>12||myTrueRecordCount==12)
        return myRecordCount;
    return myTrueRecordCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"MyCell";
    MyAppCell *cell = (MyAppCell*)[tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[MyAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCellIdentifier] autorelease];
        ((SubviewBasedApplicationCellContentView*)cell.cellContentView).myAppCellDelegate=(id)self;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if(self.iType==11 && !isSearchByABC )
        {
            UIButton *topButton ;
            UIImage *toolimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up1" ofType:@"png"inDirectory:@"newImages/"]];
           // UIImage *toolimage1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Top1" ofType:@"png"inDirectory:@"Images/"]];
            topButton = [[UIButton alloc] init];
            [topButton setBackgroundImage:toolimage forState:UIControlStateNormal];
           // [topButton setBackgroundImage:toolimage1 forState:UIControlStateHighlighted];
            CGRect frame=CGRectMake(230.0,7.0,toolimage.size.width/2,toolimage.size.height/2);
            topButton.frame=frame;
            topButton.tag=1;
            [topButton addTarget:self action:@selector(topOrDelPressed:Event:)forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:topButton];
            [topButton release];
            
            UIButton *delButton ;
            toolimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"de0" ofType:@"png"inDirectory:@"newImages/"]];
           // toolimage1=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Del1" ofType:@"png"inDirectory:@"Images/"]];
            delButton=[[UIButton alloc] init];
            frame=CGRectMake(275.0,7.0,toolimage.size.width/2,toolimage.size.height/2);
            [delButton setBackgroundImage:toolimage forState:UIControlStateNormal];
            //[delButton setBackgroundImage:toolimage1 forState:UIControlStateHighlighted];
            delButton.frame=frame;
            delButton.tag=2;
            [delButton addTarget:self action:@selector(topOrDelPressed:Event:)forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:delButton];
            [delButton release];
        }
        else{
            /*add by liteng for 增加收藏按钮 20130403*/
            UIButton *saveButton =[[UIButton alloc] init];// [UIButton buttonWithType:UIButtonTypeCustom];
            cell.collectButton=saveButton;
//            [saveButton setBackgroundColor:[UIColor blackColor]];
            CGRect frame = CGRectMake(275.0 ,5.0 , 40.0, 40.0);
            saveButton.frame=frame;
            if (12==iType)
            {
                saveButton.tag=101;
                UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"de0" ofType:@"png"inDirectory:@"newImages/"]];
                UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"de1" ofType:@"png"inDirectory:@"newImages/"]];
                [saveButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                [saveButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
            }
            else
            {
                saveButton.tag=100;
                UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                [saveButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                [saveButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
            }
            [saveButton addTarget:self action:@selector(topOrDelPressed:Event:)forControlEvents:UIControlEventTouchUpInside];
//            saveButton.backgroundColor=[UIColor blackColor];
            [cell addSubview:saveButton];
        }
    }
    
    if(myRecordCount>indexPath.row && myTrueRecordCount>indexPath.row)
    {
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]])
        {
            SongRecord *appRecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
            if(appRecord!=nil)
            {
                cell.songName=appRecord.songname;
                NSLog(@"%@",appRecord.songname);
                cell.language=appRecord.language;
                NSLog(@"%@",appRecord.language);
                cell.singerName=appRecord.singer;
                NSLog(@"%@",appRecord.singer);
                cell.singerIdString=appRecord.singerString;
                NSLog(@"%@",appRecord.singerString);
                if (12!=iType) {
                    if ([self isPrivateHaveSongInfo:appRecord]) {
                        UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
                        UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
                        [cell.collectButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                        [cell.collectButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
                        cell.collectButton.tag=102;
                    }else{
                        UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                        UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
                        [cell.collectButton setBackgroundImage:ButtonImage forState:UIControlStateNormal];
                        [cell.collectButton setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
                        cell.collectButton.tag=100;
                    }
                }
            }
            else
            {
                cell.songName=@"";
                cell.language=@"";
                cell.singerName=@"";
                cell.singerIdString=@"";
            }
        }
        else
        {
            /*RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexPath Tyep:self.singersType Condition:@"" delegate:self];
             [singersQueue addOperation:parser];
             [parser release];*/
            cell.songName=@"";
            cell.language=@"";
            cell.singerName=@"";
            cell.singerIdString=@"";
        }
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==myRecordCount-1 && indexPath.row<myTrueRecordCount)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite ];
        spinner.frame = CGRectMake(0, 0, 24, 24);
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell *cell=[[[UITableViewCell alloc] init] autorelease];
        cell.accessoryView = spinner;
        [spinner startAnimating];
        self.MySongsInfoTable.tableFooterView = spinner;
        [spinner release];
        //[self performSelectorOnMainThread:@selector(LoadMore) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(LoadMore) withObject:nil afterDelay:1.5];
    }
    else 
    {
//        self.MySongsInfoTable.tableFooterView=nil;  // modify by liteng for 控制加截进度的显示 20130513
    }

    if(indexPath.row==myTrueRecordCount-1)
    {
        self.MySongsInfoTable.tableFooterView=nil;  // add by liteng for 控制加截进度的显示  20130513
    }
}

/*add by liteng for 查询在私人曲库中是否存在 20130427*/
-(BOOL)isPrivateHaveSongInfo:(SongRecord*)songRecord
{
    if(!privateSongsInfoArray||0==[privateSongsInfoArray count])
        return NO;
    for (SongRecord * tmpSongRecord in privateSongsInfoArray) {
        if ([self compareSongsInfo:songRecord SongRecord2:tmpSongRecord]) {
            return YES;
        }
    }
    return NO;
}

//待测
/*add by liteng for 用于对比歌曲信息 20130427*/  
-(BOOL)compareSongsInfo:(SongRecord*)songRecord1 SongRecord2:(SongRecord*)songRecord2
{
    NSString * songname1=[self filterSongName:songRecord1.songname];
    [songname1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * songname2=[songRecord2.songname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [songname2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * language1 =[self translateLanguageClassNo:songRecord1.language];
    [language1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * language2 =songRecord2.language;
    [songRecord2.language stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * singer1=songRecord1.singer;
    [singer1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * singer2=[songRecord2.singer stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [singer2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([songname1 isEqualToString:songname2]&&[language1 isEqualToString:language2]&&[singer1 isEqualToString:singer2])
        return YES;
    return NO;
}

-(void)LoadMore
{
    //self.mySingerTable.tableFooterView=nil;
    //  [self.mySingerTable beginUpdates];
    self.threadCount=0;
    for(int i=0;i<6;i++)
    {
        int n=myRecordCount+1;
        if(n<=myTrueRecordCount)
        {
            myRecordCount++;
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:myRecordCount-1 inSection:0];
            NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
            [indexPaths addObject:indexpath];
            [self.MySongsInfoTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            [indexPaths release];
            if(!isSearchByABC)
            {
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:0 Condition:@"" SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
            else
            {
                RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:indexpath Tyep:self.iType SubType:1 Condition:self.szSongABC SingerId:self.sID delegate:self];
                [MySongsInfoQueue addOperation:parser];
                [parser release];
            }
            self.threadCount++;
        }
        else {
            break;
        }
        
    }
    // [self.mySingerTable endUpdates];
}

-(void)DownPressed:(UIButton *)button
{
    if(button.tag==20)
    {
        [self.delegate DownView];
    }
}

-(void)topOrDelPressed:(UIButton *)button Event:(id)event
{
    NSSet *touches=[event allTouches];
    UITouch *touch=[touches anyObject];
    CGPoint currentTouchPosition=[touch locationInView:self.MySongsInfoTable];
    NSIndexPath *indexPath=[self.MySongsInfoTable indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        if(iType==11)
        {
            int tag;
            tag=button.tag;
            
            NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
            if(![null isKindOfClass:[NSNull class]])
            {
                SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
                if(tag==1)
                {
                    NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>prisong</opt><param>%@</param><ispid>1</ispid><userid>0</userid></operation><validate>%@</validate></root>",apprecord.pid,stringLogin];
                    
                    //[IphoneUTouchAppDelegate SendCmdToServer:sendBuff];
                    //[self SongInfoSendCmdToServer:sendBuff];
                    
                    NSThread * sendThread=[[[NSThread alloc] initWithTarget:self selector:@selector(SongInfoSendCmdToServer:) object:sendBuff] autorelease];
                    [sendThread start];
                    
                    [sendBuff release];

                }
                if(tag==2)
                {
                    NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>delsong</opt><param>%@</param><ispid>1</ispid><userid>0</userid></operation><validate>%@</validate></root>",apprecord.pid,stringLogin];
                    //[IphoneUTouchAppDelegate SendCmdToServer:sendBuff];
                    //[self SongInfoSendCmdToServer:sendBuff];
                    NSThread * sendThread=[[[NSThread alloc] initWithTarget:self selector:@selector(SongInfoSendCmdToServer:) object:sendBuff]autorelease];
                    [sendThread start];
                    
                    [sendBuff release];

                }
            }
        }
    }
    /*add by liteng for 响应收藏歌曲消息 20130403*/
    if (100 ==button.tag)
    {
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]])
        {
            SongRecord *appRecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
//            appRecord.songname=[self filterSongName:appRecord.songname];
//            appRecord.language=[self translateLanguageClassNo:appRecord.language];
            
            NSString *songName=[NSString stringWithString:[self filterSongName:appRecord.songname]];
            NSString *language=[NSString stringWithString:[self translateLanguageClassNo:appRecord.language]];
            NSString *singerName=[NSString stringWithString:appRecord.singer];
            NSString *songId=[NSString stringWithString:appRecord.songId];
            
            NSString * utf8String=[appRecord.songname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
//            NSLog(@"utf8====%@",utf8String);
            /*用于转换UTF8至GBK*/
            
            NSLog(@"gbk====%@",[utf8String stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            NSString * cmdSqlString=[[NSString alloc] initWithFormat:@"INSERT INTO personalSongInfo(songName,singerName,language,songID,IsHave) VALUES('%@','%@','%@','%@','1')",
                                     [songName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     [singerName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     language,songId];
            NSLog(@"%@",cmdSqlString);
            if ([mySqlite ExecSqlCmd:cmdSqlString])
                NSLog(@"INSERT INTO personalSongInfo SQL OK");
            else
                NSLog(@"INSERT INTO personalSongInfo SQL ERROR");
            
            /*add by liteng for 增加收藏的响应 20130427*/
            UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
            UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang0" ofType:@"png"inDirectory:@"newImages/"]];
            [button setBackgroundImage:ButtonImage forState:UIControlStateNormal];
            [button setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
            button.tag=102;
            SongRecord * tmpSongRecord =[[SongRecord alloc] init];
            tmpSongRecord.songname=[songName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            tmpSongRecord.singer=[singerName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            tmpSongRecord.language=language;
            [self.privateSongsInfoArray addObject:tmpSongRecord];
            [tmpSongRecord release];
            [self ShowPopPrompt:[songName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] RowWithIndexPath:indexPath PopType:1];
        }
        else
        {
            NSLog(@"1===无");
            NSLog(@"2===无");
            NSLog(@"3===无");
        } 
    }
    /*add by liteng for 增加删除私人曲库的消息响应 20130410*/
    else if (101 ==button.tag)
    {
        if(self.threadCount>0)
        {
            NSLog(@"截入中不响应 %d",self.threadCount);
            return;
        }
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]])
        {
            SongRecord *appRecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
            if([mySqlite deletePersonalSongInfo:appRecord.privateId]);
            {
                if(myTrueRecordCount>12||myTrueRecordCount==12)
                {
                    myRecordCount--;
                    myTrueRecordCount--;
                }
                else
                {
                    myTrueRecordCount--;
                }
                [self.songsInfoRecordArray removeObjectAtIndex:indexPath.row];
                [self.MySongsInfoTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    /*add by liteng for 增加对已存歌曲的处理*/
    else if(102 ==button.tag)
    {
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]])
        {
             SongRecord *appRecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
            NSString *songName=[[NSString stringWithString:[self filterSongName:appRecord.songname]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *language=[NSString stringWithString:[self translateLanguageClassNo:appRecord.language]];
            NSString *singerName=[[NSString stringWithString:appRecord.singer] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * cmdSqlString=[[NSString alloc] initWithFormat:@"delete from personalSongInfo where songName='%@' and singerName='%@' and language='%@'",
                                     songName,singerName,language];
            if ([mySqlite ExecSqlCmd:cmdSqlString])
                NSLog(@"delete personalSongInfo SQL OK");
            else
                NSLog(@"delete personalSongInfo SQL ERROR");
            UIImage* ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
            UIImage* ButtonImage1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoucang1" ofType:@"png"inDirectory:@"newImages/"]];
            [button setBackgroundImage:ButtonImage forState:UIControlStateNormal];
            [button setBackgroundImage:ButtonImage1 forState:UIControlStateHighlighted];
            button.tag=100;
            int songIndex=0;
            for (SongRecord * tmpSongRecord in privateSongsInfoArray) {
                if([tmpSongRecord.songname isEqualToString:songName]&&
                   [tmpSongRecord.singer isEqualToString:singerName]&&
                   [tmpSongRecord.language isEqualToString:language])
                {
                    [privateSongsInfoArray removeObjectAtIndex:songIndex];
                    break;
                }
                else
                    songIndex++;
            }
            [self ShowPopPrompt:[songName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] RowWithIndexPath:indexPath PopType:2];
        }
        else
        {
            NSLog(@"处理取消收藏时出错!!!"); 
        }
    }
    else
    {
    
    }
}


/*add by liteng for 处理歌曲反查*/
-(void)searchSingerSong:(NSString*)singerId SingerName:(NSString *)singerName
{
    NSLog(@"SingerId ==%@  SingerName ==%@",singerId,singerName);
    if (iType!=0) {
        SongInViewController * songInfoTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:0 Id:singerId Name:singerName ];
        // self.singersInfoContrl.singersType=tag;
        self.searchSongViewController=songInfoTmp;
        [songInfoTmp release];
        [self viewDidAppear:YES];
        [self.navigationController pushViewController:self.searchSongViewController animated:YES];
    }else
        NSLog(@"歌星界面不弹出歌曲反查界面!!!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    static int selRow=-1;
    if(iType==11 && !isSearchByABC)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    /*add by liteng for 处理私人曲库点歌消息(预留) 20130412*/
    else if(120==iType)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]]) {
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
        if(![null isKindOfClass:[NSNull class]])
        {
           // if(selRow==row)
            //    return;
            selRow=row;
        
            SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:indexPath.row];
            if([stringLogin isEqualToString:@"00000000"])
            {
                 NSString *strSql=[NSString stringWithFormat:@"insert into SongInfo (songid,songname,songlanguage,singer) values('%@','%@','%@','%@')",apprecord.songId,apprecord.songname,apprecord.language,apprecord.singer];
                 [mySqlite InsertRecord:strSql];
            }
            else
            {
                NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>selectsong</opt><param>%@</param><ispid>0</ispid><userid>0</userid></operation><validate>%@</validate></root>",apprecord.songId,stringLogin];

                //[IphoneUTouchAppDelegate SendCmdToServer:sendBuff];
                //[self SongInfoSendCmdToServer:sendBuff];
                NSThread * sendThread=[[[NSThread alloc] initWithTarget:self selector:@selector(SongInfoSendCmdToServer:) object:sendBuff]autorelease];
                [sendThread start];
                [sendBuff release];
            }
            [self ShowPopPrompt:apprecord.songname RowWithIndexPath:indexPath PopType:0];
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint targetPoint = [[touches anyObject] locationInView:self.view];
    if(targetPoint.y>=seledImage.frame.origin.y && targetPoint.y<=seledImage.frame.origin.y+seledImage.frame.size.height
           && targetPoint.x>=seledImage.frame.origin.x && targetPoint.x<=seledImage.frame.origin.x+seledImage.frame.size.width/2)
    {
        seledImage.hidden=NO;
        songedImage.hidden=YES;
        [self SearchSongsByABC:@""];
    }
    if(targetPoint.y>=seledImage.frame.origin.y && targetPoint.y<=seledImage.frame.origin.y+seledImage.frame.size.height
       && targetPoint.x>=seledImage.frame.origin.x+seledImage.frame.size.width/2 && targetPoint.x<=seledImage.frame.origin.x+seledImage.frame.size.width)
    {
        seledImage.hidden=YES;
        songedImage.hidden=NO;
        [self SearchSongsByABC:@"strABC"];
    }
}


-(void) SearchSongsByABC:(NSString*)strABC
{
    if([strABC length]>0)
    {
        isSearchByABC=YES;
    }
    else 
    {
        isSearchByABC=NO;
    }
    
    [self.MySongsInfoQueue cancelAllOperations];
    
    [self.MySongsInfoTable removeFromSuperview];
    [MySongsInfoTable release];
    
    myRecordCount=12;
    
    [self getRecords];
    
    CGRect tableRect;
    
    // modify by liteng for 自动调整tableview的大小 20130422
//    tableRect=CGRectMake(0,40,320,480-44-40-50);
    if(self.iType!=11)
    {
        if(searchViewShowFlag)
            tableRect=CGRectMake(0,40,320,480-44-40-50);
        else
            tableRect=CGRectMake(0,0,320,480-44-50);
    }
    else
        tableRect=CGRectMake(0,40,320,480-44-40-50);
    
    MySongsInfoTable=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    MySongsInfoTable.backgroundColor=[UIColor clearColor];
    MySongsInfoTable.dataSource=self;
    MySongsInfoTable.delegate=self;
    MySongsInfoTable.separatorStyle=NO;//去掉分割线
    MySongsInfoTable.tag=1;
    MySongsInfoTable.showsVerticalScrollIndicator=NO;//隐藏滚动条
    MySongsInfoTable.rowHeight=49.5f;
    MySongsInfoTable.UserInteractionEnabled=YES;
//    [self.view addSubview:MySongsInfoTable];
    [self.view insertSubview:MySongsInfoTable atIndex:1];
    
}

-(void) ShowPopPrompt:(NSString*) songName RowWithIndexPath:(NSIndexPath *)indexPath PopType:(int)popType
{
    if(PromptView)
    {
        [PromptView removeFromSuperview];
        [PromptView release];
        PromptView=nil;
    }
    NSString *strToShow;
    if (0==popType) {
        strToShow=[[NSString alloc]initWithFormat:@"%@ 发送预约",songName];
    }else if(1==popType){
        strToShow=[[NSString alloc]initWithFormat:@"%@ 已添加收藏",songName];
    }else{
        strToShow=[[NSString alloc]initWithFormat:@"%@ 已取消收藏",songName];
    }
    
    PromptView = [[GCDiscreetNotificationView alloc] initWithText:strToShow 
                                                         showActivity:NO 
                                                   inPresentationMode: GCDiscreetNotificationViewPresentationModeTop
                                                               inView:self.view];
    [strToShow release];
    [self.PromptView show:YES];
    [self.PromptView hideAnimatedAfter:1.0];
}

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid
{
    if(iType==11 && !isSearchByABC)
    {
        if(type==2)//置顶
        {
            for(int i=0;i<myTrueRecordCount;i++)
            {
                NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:i];
                if(![null isKindOfClass:[NSNull class]])
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    RequestSongs *parser=[[RequestSongs alloc] initWithIndex:path Tyep:self.iType SubType:0 Condition:@"" delegate:self];
                    [MySongsInfoQueue addOperation:parser];
                    [parser release];
                }
            }
        }
        else if(type==1 || type==3)//删除
        {
            for(int i=0;i<myTrueRecordCount;i++)
            {
                NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:i];
                if(![null isKindOfClass:[NSNull class]])
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:i];
                    if([pid isEqualToString:apprecord.pid] || [songId isEqualToString:apprecord.songId])
                    {
                        if(myTrueRecordCount>=12)
                        {
                            myRecordCount--;
                            myTrueRecordCount--;
                        }
                        else
                        {
                            myTrueRecordCount--;
                        }
                        [self.songsInfoRecordArray removeObjectAtIndex:i];
                        [self.MySongsInfoTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade]; 
                    }
                }
            }
            for(int i=0;i<myTrueRecordCount;i++)
            {
                NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:i];
                if(![null isKindOfClass:[NSNull class]])
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:i];
                    if(apprecord!=nil)
                    {
                        RequestSongs *parser=[[RequestSongs alloc] initWithIndex:path Tyep:self.iType SubType:0 Condition:@"" delegate:self];
                        [MySongsInfoQueue addOperation:parser];
                        [parser release]; 
                    }
                }
            }
        }
        else if(type==0)//选歌
        {
          /*  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:RecordsCount-1 inSection:0];
            NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
            [indexPaths addObject:indexpath];
            [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            [indexPaths release];
            
            for(int i=0;i<RecordsCount;i++)
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                if(SearchByABD)
                {
                    RequestSongs *parser=[[RequestSongs alloc] initWithIndex:path Tyep:3 SubType:SortTypes Condition:searchString delegate:self];
                    [queue addOperation:parser];
                    [parser release];
                }
                else
                {
                    NSString *CellIdentifier = @"ApplicationCell";
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    MyAppCell *cell = (MyAppCell *)[self.myTableView cellForRowAtIndexPath:path];
                    if (cell == nil)
                    {
                        cell = [[[MyAppCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:CellIdentifier] autorelease];
                    }
                    cell.useDarkBackground = (path.row % 2 == 0);
                    
                    RequestSongs *parser=[[RequestSongs alloc] initWithIndex:path Tyep:QueryTypes SubType:SortTypes Condition:searchString delegate:self];
                    [queue addOperation:parser];
                    [parser release];
                }
            }*/
        }
    }
    else
    {
        for(int i=0;i<myTrueRecordCount;i++)
        {
            NSNull *null = (NSNull *)[self.songsInfoRecordArray objectAtIndex:i];
            if(![null isKindOfClass:[NSNull class]])
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                SongRecord *apprecord = (SongRecord*)[self.songsInfoRecordArray objectAtIndex:i];
                if(apprecord.isChange || [songId isEqualToString:apprecord.songId])
                { 
                    if(!isSearchByABC)
                    {
                        RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:path Tyep:self.iType SubType:0 Condition:@"" SingerId:self.sID delegate:self];
                        [MySongsInfoQueue addOperation:parser];
                        [parser release];
                    }
                    else
                    {
                        RequestSongs *parser=[[RequestSongs alloc] initWithIndexS:path Tyep:self.iType SubType:1 Condition:self.szSongABC SingerId:self.sID delegate:self];
                        [MySongsInfoQueue addOperation:parser];
                        [parser release];
                    }
                }
            }
        }
    }
}


-(int)SongInfoSendCmdToServer:(NSString *)strCMD
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
    [String1 appendFormat:[NSString stringWithFormat:[self md5:String0]]];
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
    
    NSLog(@"指令：%@",strCMD);
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


-(NSString*) md5:(NSString*) str
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

/*add by liteng for 过滤歌名中的预约信息 20130412*/

-(NSString*) filterSongName:(NSString *)songName
{
    NSString * stringTem=[NSString stringWithFormat:@"(预约"];
    NSRange range = [songName rangeOfString:stringTem];
    int location = range.location;
    if (NSNotFound!=range.location) 
        songName=[songName substringToIndex:location];
    return [songName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/*add by liteng for 转换语种编号 20120417*/

-(NSString*)translateLanguageClassNo:(NSString*)languageStr
{
    [languageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([languageStr isEqualToString:@"国语" ]) 
       return  [NSString stringWithFormat:@"0"];
    else if ([languageStr isEqualToString:@"粤语" ])
        return  [NSString stringWithFormat:@"1"];
    else if ([languageStr isEqualToString:@"闽南语" ])
        return  [NSString stringWithFormat:@"2"];
    else if ([languageStr isEqualToString:@"韩语" ])
        return  [NSString stringWithFormat:@"3"];
    else if ([languageStr isEqualToString:@"日语" ])
        return  [NSString stringWithFormat:@"4"];
    else return  [NSString stringWithFormat:@"6"]; //english
}

/*add by liteng for 转换UTF8至GBK 20130415*/

-(NSString*)translateUTF8toGBK:(NSString *)tmpString
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [tmpString dataUsingEncoding:encoding];
    return [[[NSString alloc]initWithData:gb2312data encoding:encoding] autorelease];
}


/*add by liteng for 处理搜索框弹出 20130416*/

-(void)loadSearchView
{
    CGRect popupRect;
    if (searchViewShowFlag){
        popupRect=CGRectMake(0.0, -40.0, 320.0, 40.0);
        [searchButton setTitle:@"查找"];
        [textField resignFirstResponder];
        searchViewShowFlag=NO;
        [self moveTableView:2];
    }
    else {
        popupRect=CGRectMake(0.0, 0.0, 320.0, 40.0);
        [searchButton setTitle:@"隐藏"];
        searchViewShowFlag=YES;
        [self moveTableView:1];
    }
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //  [UIView setAnimationDuration:UIViewAnimationTransitionCurlUp];
	[searchViewEx setFrame:popupRect];
	[UIView commitAnimations];
}


/*add by liteng for 移动tableview 20130422*/

-(void)moveTableView:(int)type
{
    CGRect popupRect;
    if (1==type) {
        popupRect=CGRectMake(0,40,MainRect.size.width,MainRect.size.height-40-44-50);
    }else if(2==type){
        popupRect=CGRectMake(0,0,MainRect.size.width,MainRect.size.height-44-50);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //  [UIView setAnimationDuration:UIViewAnimationTransitionCurlUp];
    [MySongsInfoTable setFrame:popupRect];
    [UIView commitAnimations];
}


@end
