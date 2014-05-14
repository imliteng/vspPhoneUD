//
//  RequestSingers.m
//  VisionTouch
//
//  Created by v v on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestSingers.h"
#import "SingerRecord.h"
#import "AppSelSocket.h"
#import "IphoneUTouchViewController.h"

//<starno>420</starno><starname>周杰伦</starname></starimg>http://192.100.110.156:8080/starimg/ST0420.JPG</starimg>

static NSString *kSingerId   = @"starno";
static NSString *kSingerName   = @"starname";
static NSString *kSingerIcon = @"starimg";

extern NSString * stringLogin;

@implementation RequestSingers

@synthesize singerdelegate;
@synthesize workingEntry;
@synthesize workingPropertyString;
@synthesize elementsToParse;
@synthesize storingCharacterData;
@synthesize indexPathInTableView;
@synthesize ncondition;

- (id)initWithIndex:(NSIndexPath*)index Tyep:(int)type  Condition:(NSString *)condition delegate:(id<ParseSingerDelegate>)theDelegate ;
{
    self = [super init];
    if (self != nil)
    {
        itype=type;
        self.ncondition=condition;
        self.indexPathInTableView=index;
        self.singerdelegate = theDelegate;
        self.elementsToParse = [NSArray arrayWithObjects:kSingerId,kSingerName,kSingerIcon,nil];
    }
    return self;
}

- (void)dealloc
{
    [workingEntry release];
    [workingPropertyString release];
    [indexPathInTableView release];
    [ncondition release];
    
    [super dealloc];
}

- (void)main
{
    [NSThread sleepForTimeInterval:0.05];
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    self.workingPropertyString = [NSMutableString string];
    
    NSString *sendBuff=nil;
  
    if(itype==1)//华人男
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==2)//华人女
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseGirl</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==3)//华人组合
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBand</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==4)//欧美
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>EuropeAndUSA</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==5)//日本
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>japan</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    
   else if(itype==6)//韩国
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>korea</type><condition>6</condition><querycount>false</querycount><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==7)//华人男+拼音
    {
       // sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><condition>6</condition><querycount>false</querycount><pinyin>%@</pinyin><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",ncondition,self.indexPathInTableView.row,stringLogin];
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBoy</type><querycount>false</querycount><order>pinyin</order><position>%d</position><pagesize>1</pagesize><pinyin>%@</pinyin><condition></condition></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,self.ncondition,stringLogin];
    }
    else if(itype==8)//华人女+拼音
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseGirl</type><querycount>false</querycount><order>pinyin</order><position>%d</position><pagesize>1</pagesize><pinyin>%@</pinyin><condition></condition></query><validate>%@</validate></root>",self.indexPathInTableView.row+1,self.ncondition,stringLogin];
    }

    else if(itype==9)//华人组合+拼音
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>chineseBand</type><condition>6</condition><querycount>false</querycount><pinyin>%@</pinyin><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.ncondition,self.indexPathInTableView.row+1,stringLogin];
    }

    else if(itype==10)//欧美+拼音
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>EuropeAndUSA</type><condition>6</condition><querycount>false</querycount><pinyin>%@</pinyin><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.ncondition,self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==11)//日本+拼音
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>japan</type><condition>6</condition><querycount>false</querycount><pinyin>%@</pinyin><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.ncondition,self.indexPathInTableView.row+1,stringLogin];
    }
    else if(itype==12)//韩国 +拼音
    {
        sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>star</class><type>korea</type><condition>6</condition><querycount>false</querycount><pinyin>%@</pinyin><order>songfreq</order><position>%d</position></query><validate>%@</validate></root>",self.ncondition,self.indexPathInTableView.row+1,stringLogin];
    }

    //NSLog(@"%@",sendBuff);

    NSData *data= [IphoneUTouchViewController RequestFromServer:sendBuff];
    if(data==nil)
    {
        data=[IphoneUTouchViewController RequestFromServer:sendBuff];
        if(data==nil)
        {
            [sendBuff release];
            [pool release];
            return;
        }
    }
    
    [sendBuff release];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];

	if(![self isCancelled] )
    {
        [self.singerdelegate didFinishParsingSinger:self.workingEntry index:indexPathInTableView];
    }
    self.workingPropertyString = nil;
    
    [parser release];
	[pool release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"star"])
	{
        self.workingEntry = [[[SingerRecord alloc] init] autorelease];
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
            if([elementName isEqualToString:kSingerId])
            {
                //NSLog(@"歌星ID%@",trimmedString);
                self.workingEntry.singerId= trimmedString;
            }
            else if ([elementName isEqualToString:kSingerName])
            {   
                trimmedString=[trimmedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                self.workingEntry.singerName = trimmedString;
                //NSLog(@"演唱者%@",trimmedString);
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [singerdelegate parseErrorOccurred:parseError];
}



@end

