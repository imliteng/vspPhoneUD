//
//  RequestSongs.m
//  VisionTouch
//
//  Created by v v on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestSongs.h"
#import "SongRecord.h"
#import "AppSelSocket.h"
#import "IphoneUTouchViewController.h"

static NSString *kSongId   = @"id";
static NSString *kSinger   = @"singer";
static NSString *kSongName = @"songname";
static NSString *kLanguage = @"language";
static NSString *kisChange = @"ischange";
static NSString *kpid      = @"pid";
static NSString *kplOrder  = @"plorder";
static NSString *kprivatesongid  = @"privatesongid";
static NSString *kstarno  = @"starno";

extern NSString * stringLogin;
extern NSString * HOST_IP;
extern NSString * HOST_PORT;

@implementation RequestSongs

@synthesize delegate;
@synthesize workingEntry;
@synthesize workingPropertyString;
@synthesize elementsToParse;
@synthesize storingCharacterData;
@synthesize indexPathInTableView;
@synthesize singerId;
@synthesize songInfo;
@synthesize songPrivateId;
@synthesize ncondition;
@synthesize ktvID;
@synthesize songID;

- (id)initWithIndex:(NSIndexPath*)index Tyep:(int)type SubType:(int) subType Condition:(NSString*)condition delegate:(id <ParseSongsDelegate>)theDelegate;
{
    self = [super init];
    if (self != nil)
    {
        itype=type;
        iSubType=subType;
        self.ncondition=condition;
        self.indexPathInTableView=index;
        self.delegate = theDelegate;
        self.elementsToParse = [NSArray arrayWithObjects:kSongId,kSinger,kSongName,kLanguage,kisChange,kpid,kplOrder,kprivatesongid,kstarno,nil];
    }
    return self;
}

- (id)initWithIndexS:(NSIndexPath*)index Tyep:(int)type SubType:(int) subType Condition:(NSString*)condition SingerId:(NSString*)singerid delegate:(id <ParseSongsDelegate>)theDelegate
{
    self = [super init];
    if (self != nil)
    {
        itype=type;
        iSubType=subType;
        self.ncondition=condition;
        self.singerId=singerid;
        self.indexPathInTableView=index;
        self.delegate = theDelegate;
        self.elementsToParse = [NSArray arrayWithObjects:kSongId,kSinger,kSongName,kLanguage,kisChange,kpid,kplOrder,kprivatesongid,kstarno,nil];
        
        NSString *tmpKtvID=[[NSString alloc] initWithString:[IphoneUTouchViewController GetKTVIDInfo]];
        self.ktvID=tmpKtvID;
        [tmpKtvID release];
        mySqlite=[[LiteDateBase alloc]init];
        [mySqlite OpenDB:@"Song.db"];
    }
    return self;
}

- (void)dealloc
{
    [workingEntry release];

    [workingPropertyString release];
    [indexPathInTableView release];
    if(singerId)
    {
        [singerId release];
    }
    [ncondition release];
    [elementsToParse release];
    [mySqlite CloseDB];
    [super dealloc];
}

- (void)main
{
    /*add by liteng for 增加对私人曲库的处理 20130408*/
    if (12==itype) {
        stat=YES;
        recvFlag=YES;
        callReserve=NO;
        [NSThread sleepForTimeInterval:0.2];
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        self.workingPropertyString = [NSMutableString string];
        //workingEntry =[[[SongRecord alloc] init] autorelease];
        workingEntry.isReserve=NO;
        self.workingEntry=[mySqlite getPersonalSongInfo:indexPathInTableView];
        self.songPrivateId=workingEntry.privateId;
        self.songInfo=[NSString stringWithString:workingEntry.songId];
        NSData *data=[self requestSong:indexPathInTableView];
        if (recvFlag&&workingEntry.isHave) {
            if(data==nil)
            {
                data=[self requestSong:indexPathInTableView ];//重新获取一次
                if(data==nil)
                {
                    [pool release];
                    stat=NO;
                    return;
                }
            }
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
            
            
            [self requestSong:indexPathInTableView];
            self.workingEntry.songname= [workingEntry.songname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.workingEntry.singer= [workingEntry.singer stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (recvFlag) {
//                self.workingEntry.songname=[NSString stringWithFormat:@"%@<预约%d>",self.workingEntry.songname,reserveNO];  暂时停用
            }
            
            if((![self isCancelled]) && self.delegate && stat)
            {
                [self.delegate didFinishParsing:self.workingEntry index:indexPathInTableView];
            }
            [parser release];
        }else{
            self.workingEntry.songname= [workingEntry.songname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.workingEntry.singer= [workingEntry.singer stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.workingEntry.songname=[NSString stringWithFormat:@"%@<无曲目>",self.workingEntry.songname];
            [self.delegate didFinishParsing:self.workingEntry index:indexPathInTableView];
        }
        
        self.workingPropertyString = nil;
        [pool release];
        
    }else{
        stat=YES;
        
        [NSThread sleepForTimeInterval:0.2];
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        self.workingPropertyString = [NSMutableString string];
        
        NSData *data=[self requestSong:indexPathInTableView ];
        if(data==nil)
        {
            data=[self requestSong:indexPathInTableView ];//重新获取一次
            if(data==nil)
            {
                /*self.indexPathInTableView = [[[SongRecord alloc] init] autorelease];
                self.workingEntry.songId=@"900001";
                self.workingEntry.singer =@"未知";
                self.workingEntry.songname =@"加载错误";
                self.workingEntry.language =@"未知";
                self.workingEntry.isChange=NO;
                [self.delegate didFinishParsing:self.workingEntry index:indexPathInTableView ];*/
                [pool release];
                stat=NO;
                return;
            }
        }
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
        
        if(![self isCancelled] && self.delegate && stat)
        { 
            [self.delegate didFinishParsing:self.workingEntry index:indexPathInTableView ];
        }
        self.workingPropertyString = nil;
        
        [parser release];
        [pool release];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                        qualifiedName:(NSString *)qName
                                        attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"song"])
	{
        self.workingEntry =[[[SongRecord alloc] init] autorelease];
        self.workingEntry.privateId=self.songPrivateId;
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
            else if([elementName isEqualToString:kprivatesongid]) // 未用
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
    [delegate parseErrorOccurred:parseError];
}


-(NSData*)requestSong:(NSIndexPath*) indexPath
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
    
    int recordnum=indexPath.row+1;
    
    NSString *sendBuff=nil;
   /* if(itype==1)//新歌抢鲜
    {
        if(iSubType==1)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==2)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
    }
    else if(itype==3)//按拼音查询
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>false</querycount><pinyin>%@</pinyin><position>%d</position></query><validate>%@</validate></root>",ncondition, recordnum,stringLogin];
    }
    else if(itype==2)//全部歌曲
    {
        if(iSubType==1)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==2)//拼音排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
    }*/
 /*   else if(itype==0)//排行榜
    {
        if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        if(iSubType==2)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
    }
    else if(itype==6)//已选歌曲
    {
        if(iSubType==1)//未尝
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>playlist</type><querycount>false</querycount><order>playlist</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==2)//已唱
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>sung</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
    }
    else if(itype==7)//已选歌曲的拼音查询
    {
        if(iSubType==1)//未尝
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>playlist</type><querycount>false</querycount><pinyin>%@</pinyin><position>%d</position></query><validate>%@</validate></root>",ncondition,recordnum,stringLogin];
        }
        else if(iSubType==2)//已唱
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>sung</type><querycount>false</querycount><pinyin>%@</pinyin<position>%d</position></query><validate>%@</validate></root>",ncondition,recordnum,stringLogin];
        }
    }
    else */
    if(itype==1)//国语
    {
        if(iSubType==0)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>0</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)//拼音查询
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>0</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==2)//粤语
    {
        if(iSubType==0)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>1</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)//拼音查询
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>1</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==3)//闽南语
    {
        if(iSubType==0)//
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>2</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)//拼音查询
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>2</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==6)//韩语语
    {
        if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>5</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>5</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==5)//日语
    {
        if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>4</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>4</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==4)//英语语
    {
        if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>3</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)//拼音排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>3</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==7)//其他
    {
        if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songlang</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>6</condition></root>",recordnum,stringLogin,ncondition];
        }
    }
    else if(itype==8)//拼音点歌
    {
        if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>false</querycount><order>songfreq</order><pinyin>%@</pinyin><position>%d</position></query><validate>%@</validate></root>",ncondition, recordnum,stringLogin];
        }
        else if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>all</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        
    }
    if(itype==9)//新歌抢鲜
    {
        if(iSubType==0)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songnewfreq</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><pinyin>%@</pinyin><validate>%@</validate></root>",recordnum,ncondition,stringLogin];
        }
    }
    else if(itype==10)//排行榜
    {
        if(iSubType==0)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        if(iSubType==1)
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>hot</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><pinyin>%@</pinyin><validate>%@</validate></root>",recordnum,ncondition,stringLogin];
        }
    }
    else if (itype==11)
    {
        if(iSubType==0)//未尝
        {
           sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>playlist</type><querycount>false</querycount><order>playlist</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
        else if(iSubType==1)//已唱
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>sung</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate></root>",recordnum,stringLogin];
        }
    }
    else if (12==itype)   // add by liteng for 根据歌曲信息获得歌号ID  201204178
    {
        if (!callReserve) {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>songno</type><querycount>false</querycount><position>1</position></query><condition>%@</condition><validate>%@</validate></root>",songInfo,stringLogin];
        }
        else
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>privatesong</class><type>playlistorder</type><condition>%@</condition><querycount>false</querycount><position>%d</position></query><validate>%@</validate></root>",songInfo,recordnum,stringLogin];
        }
    }

    else if(itype==0)//按歌星按拼音查询歌曲
    {
        if(iSubType==0)//热门排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>star</type><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>%@</condition></root>",recordnum,stringLogin,ncondition,singerId];
        }
        else if(iSubType==1)//拼音排序
        {
            sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>song</class><type>star</type><querycount>false</querycount><order>pinyin</order><position>%d</position></query><validate>%@</validate><pinyin>%@</pinyin><condition>%@</condition></root>",recordnum,stringLogin,ncondition,singerId];
        }
    }
   
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
    if (12==itype) {
        if(!strcmp("99999999", readBuff)||!strcmp("00000000", readBuff)){
            recvFlag=NO;
            NSLog(@"未找到预约或歌曲信息");
            return nil;
        }
        reserveNO=atoi(readBuff);
        callReserve=YES;
    }
    
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

@end
