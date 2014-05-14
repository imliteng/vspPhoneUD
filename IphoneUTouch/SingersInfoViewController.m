//
//  SingersInfoViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingersInfoViewController.h"
#import "MySingerCell.h"
#import "RequestSingers.h"
#import "IphoneUTouchViewController.h"

extern NSString* stringLogin; 

@interface SingersInfoViewController ()

@end

@implementation SingersInfoViewController

@synthesize  singersType;
@synthesize mySingerTable;
@synthesize singersQueue;
@synthesize singersRecordArray;
@synthesize songInfoContrl;

@synthesize szABC;

@synthesize textField;
@synthesize searchButton;
@synthesize searchViewEx;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.singersType=type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    MySongTypeIndex=0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bSearchByABC=NO;
    
    myRecordCount=12;
    if(self.singersType==1)
    {
        self.navigationItem.title=@"华人男星";
    }
    else if (self.singersType==2)
    {
        self.navigationItem.title=@"华人女星";
    }
    else if (self.singersType==3)
    {
        self.navigationItem.title=@"华人组合";
    }
    else if (self.singersType==4)
    {
        self.navigationItem.title=@"欧美歌星";
    }
    else if (self.singersType==5)
    {
        self.navigationItem.title=@"日本歌星";
    }
    else if (self.singersType==6)
    {
        self.navigationItem.title=@"韩国歌星";
    }
    
    /*add by liteng for 搜索功能 20130414*/
    searchButton = [[UIBarButtonItem alloc]
                    initWithTitle:@"查找"
                    style:UIBarButtonItemStylePlain
                    target:self
                    action:@selector(loadSearchView)];
        [self.navigationItem setRightBarButtonItem:searchButton];
    
    searchViewEx=[[UIView alloc] initWithFrame:CGRectMake(0, -40, 320, 40)];
    [self.view addSubview:searchViewEx];
    
    UIImageView * searchView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Search" ofType:@"png"inDirectory:@"Images"] ]];
    searchView.frame=CGRectMake(0, 0, 320, 40);
//    [self.view addSubview:searchView];
    [searchViewEx addSubview:searchView];
    [searchView release];
    
    searchView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Search1" ofType:@"png"inDirectory:@"Images"] ]];
    searchView.frame=CGRectMake(20, 12, 20, 20);
//    [self.view addSubview:searchView];
    [searchViewEx addSubview:searchView];
    [searchView release];
    
    textField=[[UITextField alloc] initWithFrame:CGRectMake(40.0f,10.0f,260.0f,22.0f)]; 
    [textField setBorderStyle:UITextBorderStyleNone];//外框类型 
    textField.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    textField.placeholder=@"歌星名首字母 如:王菲为wf";//默认显示的字
    [textField setKeyboardType:UIKeyboardTypeDefault];//键盘样
    textField.textColor=[UIColor grayColor];
    textField.textAlignment = UITextAlignmentCenter;
    //textField.secureTextEntry=YES;//密码 
    textField.autocorrectionType=UITextAutocorrectionTypeNo; 
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone; 
    textField.returnKeyType=UIReturnKeyDone; 
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;//编辑时会出现个修改X 
    textField.delegate = self;
    
    textField.text=@"";
//    [self.view addSubview:textField];
    [searchViewEx addSubview:textField];
    searchViewShowFlag=NO;
    
    NSString * sendBuff=nil;
    if(self.singersType==1)
    {
         sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    else if(self.singersType==2)
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseGirl</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    else if (self.singersType==3)
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBand</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    else if (self.singersType==4)
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>europeAndUSA</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    else if (self.singersType==5)
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>japan</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    else if (self.singersType==6)
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>korea</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
    }
    
    //singersType:1 华人男星 
     myTrueRecordCount=[IphoneUTouchViewController GetRecordsCount:sendBuff];
    if(myTrueRecordCount<=0)
    {
        self.singersRecordArray = [[NSMutableArray alloc] initWithCapacity:40000];
        for(int i=0;i<40000;i++) 
        {
            [self.singersRecordArray addObject:[NSNull null]];
        }
    }
    else
    {
        self.singersRecordArray = [[NSMutableArray alloc] initWithCapacity:myTrueRecordCount];
        for(int i=0;i<myTrueRecordCount;i++) 
        {
            [self.singersRecordArray addObject:[NSNull null]];
        }
    }
    
    [sendBuff release];
    
    self.singersQueue = [[NSOperationQueue alloc] init];
    [self.singersQueue setMaxConcurrentOperationCount:12];
    if(myTrueRecordCount<12)
    {
        for(int i=0;i<myTrueRecordCount;i++)
        {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType Condition:@"" delegate:self];
            [singersQueue addOperation:parser];
            [parser release];
        }
    }
    else
    {
        for(int i=0;i<12;i++)
        {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType Condition:@"" delegate:self];
            [singersQueue addOperation:parser];
            [parser release];
        }
    }

    CGRect tableRect;
    tableRect=CGRectMake(0,0,320,480-44-50);
    mySingerTable=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    mySingerTable.backgroundColor=[UIColor clearColor];
    mySingerTable.dataSource=self;
    mySingerTable.delegate=self;
    mySingerTable.separatorStyle=NO;//去掉分割线
    mySingerTable.tag=1;
    mySingerTable.showsVerticalScrollIndicator=NO;//隐藏滚动条
    mySingerTable.rowHeight=49.5f;
    mySingerTable.UserInteractionEnabled=YES;
    [self.view addSubview:mySingerTable];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
}

-(void) dealloc
{
    [singersQueue cancelAllOperations];
    
    [mySingerTable release];
    [singersQueue release];
    [singersRecordArray release];
    
    [songInfoContrl release];
    
    [textField release];
    [szABC release];
    
    
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField 
{
	[aTextField resignFirstResponder];
    NSLog(@"%@",textField.text);
    self.szABC=textField.text;
    
    [self SearchSingersByABC:self.szABC];
 	return YES;
}

- (void)handleLoadedApps:(NSIndexPath *)indexpath
{
    if(self.mySingerTable!=nil)
    {
        MySingerCell *cell = (MySingerCell *)[self.mySingerTable cellForRowAtIndexPath:indexpath];
        SingerRecord *apprecord = (SingerRecord*)[self.singersRecordArray objectAtIndex:indexpath.row];
        if(apprecord!=nil && cell)
        {
            [cell setCell:apprecord.singerName];
        }
        
        [indexpath release];
    }
}

- (void)didFinishParsingSinger:(SingerRecord *)appRecord index:(NSIndexPath*)index 
{
    if(appRecord!=nil && index!=nil)
    {
        [index retain];

        [self.singersRecordArray replaceObjectAtIndex:index.row withObject:(SingerRecord*)appRecord];
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
    if(myTrueRecordCount>12)
        return myRecordCount;
    return myTrueRecordCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"MyCell";
    
    MySingerCell *cell = (MySingerCell*)[tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
            
    if (cell == nil)
    {
        cell = [[[MySingerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
       // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
            
    if(myRecordCount>indexPath.row && myTrueRecordCount>indexPath.row)
    {
        NSNull *null = (NSNull *)[self.singersRecordArray objectAtIndex:indexPath.row];
        if (![null isKindOfClass:[NSNull class]])
        {
            SingerRecord *appRecord = (SingerRecord*)[self.singersRecordArray objectAtIndex:indexPath.row];
            if(appRecord!=nil)
            {
                cell.SingerName=appRecord.singerName;
            }
            else
            {
                cell.SingerName=@"";
                
            }
        }
        else
        {
          /*  RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexPath Tyep:self.singersType Condition:@"" delegate:self];
            [singersQueue addOperation:parser];
            [parser release];*/
        }
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==myRecordCount-1 && indexPath.row<myTrueRecordCount)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite ];
        spinner.frame = CGRectMake(0, 0, 24, 24);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = spinner;
        [spinner startAnimating];
        self.mySingerTable.tableFooterView = spinner;
        [spinner release];
        //[self performSelectorOnMainThread:@selector(LoadMore) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(LoadMore) withObject:nil afterDelay:1.5];
    }
    else 
    {
//        self.mySingerTable.tableFooterView=nil;  // modify by liteng for 显示加载进度控制 20130513
    }
    
    if(indexPath.row==myTrueRecordCount-1)
    {
        self.mySingerTable.tableFooterView=nil;  // add by liteng for 控制加截进度的显示  20130513
    }
}

-(void)LoadMore
{
    //self.mySingerTable.tableFooterView=nil;

    for(int i=0;i<6;i++)
    {
        int n=myRecordCount+1;
        if(n<=myTrueRecordCount)
        {
            myRecordCount++;
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:myRecordCount-1 inSection:0];
            NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
            [indexPaths addObject:indexpath];
            [self.mySingerTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            [indexPaths release];
             if(bSearchByABC)
             {
                 RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType+6 Condition:self.szABC delegate:self];
                 [singersQueue addOperation:parser];
                 [parser release];
             }
             else
             {
                 RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType Condition:@"" delegate:self];
                 [singersQueue addOperation:parser];
                 [parser release];
             }
            n=i;
        }
        else
        {
            n=i;
            break;
        }
    }

    //[self.mySingerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:myRecordCount-13 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNull *null = (NSNull *)[self.singersRecordArray objectAtIndex:indexPath.row];
    if (![null isKindOfClass:[NSNull class]])
    {
        SingerRecord *appRecord = (SingerRecord*)[self.singersRecordArray objectAtIndex:indexPath.row];
        if(appRecord!=nil)
        {
            MySongTypeIndex=1;
            SongInViewController * songInfoTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:0 Id:appRecord.singerId Name:appRecord.singerName ];
            self.songInfoContrl=songInfoTmp;
            [songInfoTmp release];
            [self.songInfoContrl viewDidAppear:YES];
            // self.singersInfoContrl.singersType=tag;
            [self.navigationController pushViewController:self.songInfoContrl animated:YES];
        }
    }
}

-(void) SearchSingersByABC:(NSString*)strABC
{
    if([strABC length]>0)
    {
        bSearchByABC=YES;
    }
    else 
    {
        bSearchByABC=NO;
    }
    
    [self.singersQueue cancelAllOperations];
    
    [self.mySingerTable removeFromSuperview];
    [mySingerTable release];
    
     myRecordCount=12;
    
    NSString * sendBuff=nil;
    if(bSearchByABC)
    {
        if(self.singersType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
        else if(self.singersType==2)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseGirl</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
        else if (self.singersType==3)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBand</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
        else if (self.singersType==4)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>europeAndUSA</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
        else if (self.singersType==5)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>japan</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
        else if (self.singersType==6)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>korea</type><condition>0</condition><querycount>true</querycount><pinyin>%@</pinyin><position>1</position></query><validate>%@</validate></root>",strABC,stringLogin];
        }
    }
    else 
    {
        if(self.singersType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if(self.singersType==2)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseGirl</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if (self.singersType==3)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBand</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if (self.singersType==4)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>europeAndUSA</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if (self.singersType==5)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>japan</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }
        else if (self.singersType==6)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>korea</type><condition>0</condition><querycount>true</querycount><position>1</position></query><validate>%@</validate></root>",stringLogin];
        }

    }
    
    
    myTrueRecordCount=[IphoneUTouchViewController GetRecordsCount:sendBuff];
    if(myTrueRecordCount<=0)
    {
        self.singersRecordArray = [[NSMutableArray alloc] initWithCapacity:40000];
        for(int i=0;i<40000;i++) 
        {
            [self.singersRecordArray addObject:[NSNull null]];
        }
    }
    else
    {
        self.singersRecordArray = [[NSMutableArray alloc] initWithCapacity:myTrueRecordCount];
        for(int i=0;i<myTrueRecordCount;i++) 
        {
            [self.singersRecordArray addObject:[NSNull null]];
        }
    }
    [sendBuff release];
    
    if(myTrueRecordCount<12)
    {
        for(int i=0;i<myTrueRecordCount;i++)
        {
            if(bSearchByABC)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType+6 Condition:strABC delegate:self];
                [singersQueue addOperation:parser];
                [parser release];
            }
            else
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType Condition:@"" delegate:self];
                [singersQueue addOperation:parser];
                [parser release];
            }
        }
    }
    else
    {
        for(int i=0;i<12;i++)
        {
            if(bSearchByABC)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType+6 Condition:strABC delegate:self];
                [singersQueue addOperation:parser];
                [parser release];
            }
            else 
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                RequestSingers *parser=[[RequestSingers alloc] initWithIndex:indexpath Tyep:self.singersType Condition:@"" delegate:self];
                [singersQueue addOperation:parser];
                [parser release];
            }
        }
    }
    
    CGRect tableRect;
    tableRect=CGRectMake(0,40,320,480-44-40-50);
    mySingerTable=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    mySingerTable.backgroundColor=[UIColor clearColor];
    mySingerTable.dataSource=self;
    mySingerTable.delegate=self;
    mySingerTable.separatorStyle=NO;//去掉分割线
    mySingerTable.tag=1;
    mySingerTable.showsVerticalScrollIndicator=NO;//隐藏滚动条
    mySingerTable.rowHeight=49.5f;
    mySingerTable.UserInteractionEnabled=YES;
    [self.view addSubview:mySingerTable];

}

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid
{
    if(MySongTypeIndex!=0)
    {
        [self.songInfoContrl ChangeSongsStat:songId Type:type Pid:pid];
    }
}

/*add by liteng for 隐藏工具栏 20130502*/
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
        popupRect=CGRectMake(0,40,320,480-40-44-50);
    }else if(2==type){
        popupRect=CGRectMake(0,0,320,480-44-50);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //  [UIView setAnimationDuration:UIViewAnimationTransitionCurlUp];
    [mySingerTable setFrame:popupRect];
    [UIView commitAnimations];
}

@end
