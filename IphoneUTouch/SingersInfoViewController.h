//
//  SingersInfoViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingerRecord.h"
#import "RequestSingers.h"
#import "SongInViewController.h"

@interface SingersInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ParseSingerDelegate,UITextFieldDelegate>
{
    int singerType;
    
    UITableView * mySingerTable;
    NSOperationQueue * singersQueue;
    NSMutableArray *singersRecordArray;
    
    int myRecordCount;
    
    int myTrueRecordCount;
    
    SongInViewController * songInfoContrl;
    
    UITextField *textField;
    
    BOOL bSearchByABC;
    
    NSString * szABC;
    
    int MySongTypeIndex;
    
    UIView * searchViewEx;
    UIBarButtonItem * searchButton;
    BOOL searchViewShowFlag;
}

@property (nonatomic) int singersType;
@property (nonatomic,retain) UITableView * mySingerTable;
@property (nonatomic,retain)  NSOperationQueue * singersQueue;
@property (nonatomic,retain) NSMutableArray *singersRecordArray;

@property (nonatomic,retain) SongInViewController * songInfoContrl;

@property (nonatomic,retain) UITextField *textField;

@property (nonatomic,retain) NSString * szABC;
@property (nonatomic,retain) UIView * searchViewEx;
@property (nonatomic,retain) UIBarButtonItem * searchButton;

- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type;
-(void)LoadMore;
- (void)handleError:(NSError *)error;
- (void)handleLoadedApps:(NSIndexPath *)indexpath;

-(void) SearchSingersByABC:(NSString*)strABC;

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid;



@end
