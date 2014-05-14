//
//  SongInViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppSelSocket.h"
#import "RequestSongs.h"

#import "GCDiscreetNotificationView.h"

#import "LiteDateBase.h"
#import "MyAppCell.h"

@protocol DownDelegate <NSObject>

-(void) DownView;

@end

@interface SongInViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ParseSongsDelegate,UITextFieldDelegate,MyAppCellDelegate>
{
    UITableView * MySongsInfoTable;
    NSOperationQueue * MySongsInfoQueue;
    NSMutableArray * songsInfoRecordArray;
    
    NSString * sID;
    NSString * sName;
    int iType;
    
    int myRecordCount;
    int myTrueRecordCount;
    UITextField *textField;
    UIView * searchViewEx;
    UIBarButtonItem * searchButton;
    BOOL searchViewShowFlag;
    
    NSString * szSongABC;
    
    BOOL isSearchByABC;
    
    UIImageView  * BKImageView;
    UIImageView * seledImage;
    UIImageView * songedImage;
    
    BOOL isSeled;//是否显示的是已选的歌曲
    
    GCDiscreetNotificationView * PromptView;
    
    LiteDateBase *mySqlite;
    
    id<DownDelegate> delegate;
    
    UIViewController * searchSongViewController;
    NSMutableArray * privateSongsInfoArray;
    NSString * ktvID;
    int threadCount;
    BOOL isLoad;
}

@property (nonatomic,retain) UITableView * MySongsInfoTable;
@property (nonatomic,retain) NSOperationQueue * MySongsInfoQueue;
@property (nonatomic,retain) NSMutableArray * songsInfoRecordArray;

@property (nonatomic,retain) NSString * sID;
@property (nonatomic,retain) NSString * sName;
@property (nonatomic) int iType;
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,retain) UIView * searchViewEx;
@property (nonatomic,retain) UIBarButtonItem * searchButton;

@property (nonatomic,retain) UIImageView  * BKImageView;

@property (nonatomic,retain) NSString * szSongABC;

@property (nonatomic,retain) GCDiscreetNotificationView * PromptView;

@property (nonatomic,assign) id<DownDelegate> delegate;
@property (nonatomic,retain) UIViewController * searchSongViewController;
@property (nonatomic,retain) NSMutableArray * privateSongsInfoArray;
@property (nonatomic,retain) NSString * ktvID;
@property (atomic) int threadCount;
@property (atomic) int myRecordCount;
@property (atomic) int myTrueRecordCount;

-(id)initWithNibAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  Type:(int)type Id:(NSString*)iid Name:(NSString*)name;

-(void)LoadMore;
- (void)handleError:(NSError *)error;
- (void)handleLoadedApps:(NSIndexPath *)indexpath;

-(void) SearchSongsByABC:(NSString*)strABC;

-(void) getRecords;

-(void)topOrDelPressed:(UIButton *)button Event:(id)event;

-(void)DownPressed:(UIButton *)button;

-(void) ShowPopPrompt:(NSString*) songName RowWithIndexPath:(NSIndexPath *)indexPath PopType:(int)popType;

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid;

-(int)SongInfoSendCmdToServer:(NSString *)strCMD;

-(NSString*) md5:(NSString*) str;

-(NSString*) filterSongName:(NSString *)songName;

-(NSString*)translateUTF8toGBK:(NSString *)tmpString;

-(NSString*)translateLanguageClassNo:(NSString*)languageStr;

-(void)moveTableView:(int)type;

-(BOOL)isPrivateHaveSongInfo:(SongRecord*)songRecord;

-(BOOL)compareSongsInfo:(SongRecord*)songRecord1 SongRecord2:(SongRecord*)songRecord2;

@end
