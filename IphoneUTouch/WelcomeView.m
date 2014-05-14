//
//  WelcomeView.m
//  IphoneUTouch
//
//  Created by user on 13-5-17.
//
//

#import "WelcomeView.h"

extern NSString * HOST_IP;
extern NSString * HOST_PORT;

extern NSString * stringLogin;

@implementation WelcomeView
@synthesize  KTVName;
@synthesize  node;
@synthesize  ktvNameLabel;
@synthesize  backgroundview;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView * tmpImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        self.backgroundview=tmpImageView;
        [tmpImageView release];
        self.backgroundview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Welcome1" ofType:@"png"inDirectory:@"newImages"]];
        [self addSubview:self.backgroundview];
        [self getKTVName];
        UILabel * tmpLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 21)];
        [tmpLable setBackgroundColor:[UIColor clearColor]];
        self.ktvNameLabel=tmpLable;
        [tmpLable release];
        self.ktvNameLabel.text=self.KTVName;
        self.ktvNameLabel.font=[UIFont systemFontOfSize:30];
        self.ktvNameLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.ktvNameLabel];
        tmpLable=[[UILabel alloc] initWithFrame:CGRectMake(260, 70, 320, 21)];
        tmpLable.font=[UIFont systemFontOfSize:9];
        tmpLable.text=@"图片源自网络";
        tmpLable.textColor=[UIColor whiteColor];
        [tmpLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tmpLable];
    }
    return self;
}

-(void)dealloc
{
    [self.KTVName release];
    [self.node release];
    [self.ktvNameLabel release];
    [self.backgroundview release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)getKTVName
{
    NSData *data=[self requestKTVInfo];
    if(data==nil)
    {
        data=[self requestKTVInfo];//重新获取一次
        if(data==nil)
        {
            return;
        }
    }
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    NSLog(@"The KTV Name:%@",KTVName);
}

-(NSData*)requestKTVInfo
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
    
    sendBuff=[[NSString alloc]initWithFormat:@"<root><which>query</which><query><class>system</class><type>ktvinfo</type><querycount>false</querycount></query><validate>%@</validate></root>",stringLogin];
    
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
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.node=[NSString stringWithFormat:@"%@",string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"name"]) {
        NSString *tmpString = [self.node stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.KTVName=tmpString;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}

@end
