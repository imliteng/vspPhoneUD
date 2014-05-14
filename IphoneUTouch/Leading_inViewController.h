//
//  Leading_inViewController.h
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiteDateBase.h"

@protocol ShowMenuAndInfoDelegate <NSObject>
-(void)ShowMenuAndInfo;
@end

@interface Leading_inViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int recordsCount;
    UITableView * myLeading_inTable;
    NSMutableArray *leadingRecordSArray;
    id<ShowMenuAndInfoDelegate> showDelegate;
    LiteDateBase * leading_inLiteDB;
}

@property (nonatomic,retain)  UITableView * myLeading_inTable;
@property (nonatomic,retain) NSMutableArray *leadingRecordSArray;

@property (nonatomic, assign)id<ShowMenuAndInfoDelegate> showDelegate;

-(void)buttonPressed:(UIButton *)button;

@end
