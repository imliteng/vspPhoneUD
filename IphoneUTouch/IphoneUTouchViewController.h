//
//  IphoneUTouchViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyButtonItem.h"
#import "SingersSelViewController.h"
#import "LangugeViewController.h"
#import "SongInViewController.h"

#import <commoncrypto/CommonDigest.h>
#import "AppSelSocket.h"

#import "LiteDateBase.h"

#import "AsyncSocket.h"

#define SRV_CONNECTED 0
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL -1

BOOL IsSeledShow;

@protocol ExChangeToolBarStat <NSObject>

-(void)ExChangeMucStat:(BOOL)isYuanChang;
-(void)ExChangePlayStat:(BOOL)isPlaying;

@end

@protocol CloseRoomDelegate <NSObject>

-(void)CloseRoom;

@end

@interface IphoneUTouchViewController : UIViewController<TouchUpInsideMeDegate,DownDelegate,NSXMLParserDelegate>
{
    SingersSelViewController * singerSelContrl;
    LangugeViewController * langugeSelContrl;
    int MyIndex;
    int MySeledIndex;
    
    SongInViewController * songInfoContrller;
    SongInViewController * songSeledInfoContrller;
    NSArray         *elementsToParse;
    BOOL storingCharacterData;
    NSInteger reserveNO;
    BOOL haveSongFlag;
    NSMutableString * workingPropertyString;
    
    LiteDateBase *mySqlite;
    SongRecord* workingEntry;
    
    AsyncSocket *longConnClient; //长连接服务端Socket
    BOOL longConnStat;
    
    NSTimer *reConnTimer;
    
    id<ExChangeToolBarStat> ChangeDelegate;
    id<CloseRoomDelegate> closeRoomDelegate;

}

@property (nonatomic,retain) SingersSelViewController * singerSelContrl;
@property (nonatomic,retain) SongInViewController * songSeledInfoContrller;
@property (nonatomic,retain) LangugeViewController * langugeSelContrl;
@property (nonatomic,retain) SongInViewController * songInfoContrller;
@property (nonatomic,retain) SongRecord* workingEntry;
@property (nonatomic,retain) NSArray  *elementsToParse;
@property (nonatomic,retain) NSMutableString * workingPropertyString;
@property(nonatomic,retain) AsyncSocket *longConnClient;

@property (nonatomic,assign) id<ExChangeToolBarStat> ChangeDelegate;

@property (nonatomic,assign) id<CloseRoomDelegate> closeRoomDelegate;;

-(void) ToolBarClick:(int) tag;


+(NSString*) md5:(NSString*) str;
+(NSData*)RequestFromServer:(NSString*)sendBuff;

+(int)GetRecordsCount:(NSString *) sendBuff;

+(int)SendCmdToServer:(NSString *)strCMD;

+(NSString *) dataFilePath;

+(int) GetLoginStat;
+(NSString *)GetLoginString;
+(NSString*)GetKTVIDInfo;

- (int) connectServer: (NSString *) hostIP port:(int) hostPort;
- (int) OnReConnect;

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid;

-(void) SaveLoginString;

-(void) SelfDownView;

-(void)updateSongsNumber;
-(void)doUpdateSongsNumber;
-(NSString *)getSongNumFromCurrentServer:(NSString *)songInfo;
-(NSData*)requestSong:(NSString *)songInfo;

@end
