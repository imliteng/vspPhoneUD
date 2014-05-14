//
//  Leading_inViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Leading_inViewController.h"
#import "MyAppCell.h"
#import "IphoneUTouchViewController.h"
extern NSString * stringLogin;

@interface Leading_inViewController ()

@end

@implementation Leading_inViewController

@synthesize myLeading_inTable;
@synthesize leadingRecordSArray;
@synthesize showDelegate;

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
    
    leading_inLiteDB=[[LiteDateBase alloc]init];
    [leading_inLiteDB OpenDB:@"Song.db"];

    UIImageView * bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ToolBar" ofType:@"png"inDirectory:@"Images"] ]]; 
    bgView.frame=CGRectMake(0,0,320, 84);
    [self.view addSubview:bgView];
    [bgView release];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 315, 20)];
    Label.backgroundColor = [UIColor clearColor];
    Label.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    Label.text =@"以下是您试选的歌曲，是否导入到预约歌曲列表";
    Label.textColor=[UIColor whiteColor];
    [self.view addSubview:Label];
    [Label release];
    
    UIButton *okButton = [[UIButton alloc] init]; 
    okButton.tag=10;
    [okButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Lead" ofType:@"png"inDirectory:@"Images/"]];
    
    okButton.frame=CGRectMake(215,44, 50, 38);
    [okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:okButton];
    [okButton release];
    
    UIButton *cancelButton = [[UIButton alloc] init]; 
    cancelButton.tag=11;
    [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    buttonImage =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Clear" ofType:@"png"inDirectory:@"Images/"]];
    
    cancelButton.frame=CGRectMake(265,44, 50,38);
    [cancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    [cancelButton release];
    
    recordsCount=[leading_inLiteDB GetRecordsCount];
    if(recordsCount>20)
    {
        recordsCount=20;
    }
    
    leadingRecordSArray = [[NSMutableArray alloc] initWithCapacity:recordsCount];
    
    [leading_inLiteDB GetRecords:leadingRecordSArray];
    
    CGRect tableRect;
    tableRect=CGRectMake(0,84, 320, 480-84);
    myLeading_inTable=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    myLeading_inTable.backgroundColor=[UIColor clearColor];
    myLeading_inTable.dataSource=self;
    myLeading_inTable.delegate=self;
    myLeading_inTable.separatorStyle=NO;//去掉分割线
    myLeading_inTable.tag=1;
    myLeading_inTable.showsVerticalScrollIndicator=NO;//隐藏滚动条
    myLeading_inTable.rowHeight=49.5f;
    myLeading_inTable.UserInteractionEnabled=YES;
    [self.view addSubview:myLeading_inTable];
    
    /*add by liteng for 导入列表增加底色 20130530*/
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

}

-(void) dealloc
{
    [leading_inLiteDB CloseDB];
    [leading_inLiteDB release];
    
    [leadingRecordSArray release];
    [myLeading_inTable release];
    [super dealloc];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplicationCell";
    
    MyAppCell *cell = (MyAppCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        cell = [[[MyAppCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone; //cell选中时候背景不变蓝 
        
        UIButton *delButton ;
        UIImage* toolimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Del" ofType:@"png"inDirectory:@"Images/"]];
        delButton=[UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame=CGRectMake(275.0,7.0,toolimage.size.width/2,toolimage.size.height/2);
        delButton.frame=frame;
        delButton.tag=2;
        [delButton addTarget:self action:@selector(DelPressed:Event:)forControlEvents:UIControlEventTouchUpInside];
        [delButton setBackgroundImage:toolimage forState:UIControlStateNormal];
        delButton.backgroundColor=[UIColor clearColor];
        [cell addSubview:delButton];
    }
    
    if(self.leadingRecordSArray && indexPath.row<recordsCount && indexPath.row>=0)
    {
        SongRecord *appRecord = (SongRecord*)[self.leadingRecordSArray objectAtIndex:indexPath.row];
        if(appRecord!=nil)
        {
            cell.songName = appRecord.songname;
            cell.singerName = appRecord.singer;
            cell.language=appRecord.language;
        }
    }
    return cell;
}

-(void)DelPressed:(UIButton *)button Event:(id)event
{
    NSSet *touches=[event allTouches];
    UITouch *touch=[touches anyObject];
    CGPoint currentTouchPosition=[touch locationInView:self.myLeading_inTable];
    NSIndexPath *indexPath=[self.myLeading_inTable indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        int tag;
        tag=button.tag;
        if(tag==2)
        {
            SongRecord *apprecord = (SongRecord*)[self.leadingRecordSArray objectAtIndex:indexPath.row];
            NSString *strSql=[NSString stringWithFormat:@"delete from SongInfo where tkid='%@'",apprecord.pid];
            [leading_inLiteDB DelRecord:strSql];
            
            [self.leadingRecordSArray removeObjectAtIndex:indexPath.row];
            recordsCount--;
            [self.myLeading_inTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    if(recordsCount<=0)
    {
        [leading_inLiteDB DoClearRecords];
        [self.showDelegate ShowMenuAndInfo];
    }
}


-(void)buttonPressed:(UIButton *)button
{
    int tag=button.tag;
    if(tag==11)
    {
        [leading_inLiteDB DoClearRecords];
        [self.showDelegate ShowMenuAndInfo];
    }
    else if(tag==10)
    {
        int count=recordsCount;
        for(int i=0;i<count;i++)
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            SongRecord *apprecord = (SongRecord*)[self.leadingRecordSArray objectAtIndex:path.row];
            
            NSString *sendBuff=[[NSString alloc]initWithFormat:@"<root><which>operation</which><operation><opt>selectsong</opt><param>%@</param><ispid>0</ispid><userid>0</userid></operation><validate>%@</validate></root>",apprecord.songId,stringLogin];
            
            [IphoneUTouchViewController SendCmdToServer:sendBuff];
            [sendBuff release];
            
            NSString *strSql=[NSString stringWithFormat:@"delete from SongInfo where tkid='%@'",apprecord.pid];
            [leading_inLiteDB DelRecord:strSql];
            
            [self.leadingRecordSArray removeObjectAtIndex:path.row];
            recordsCount--;
            [self.myLeading_inTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        //if(recordsCount<=0)
        {
            [leading_inLiteDB DoClearRecords];
            [self.showDelegate ShowMenuAndInfo];
        }
    }
}



@end
