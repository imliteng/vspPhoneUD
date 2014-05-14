//
//  MyAppCell.h
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationCell.h"
#import <UIKit/UIKit.h>


@protocol MyAppCellDelegate <NSObject>

-(void)searchSingerSong:(NSString*)singerId SingerName:(NSString *)singerName;

@end


@interface SubviewBasedApplicationCellContentView : UIView
{
    ApplicationCell *_cell;
    BOOL _highlighted;
    UIButton * singerButton;
    NSMutableArray * singerNameArray;
    NSMutableArray * singerNameIdArray;
    id<MyAppCellDelegate> myAppCellDelegate;
}
@property(nonatomic,retain) UIButton * singerButton;
@property(nonatomic,retain) NSMutableArray * singerNameArray;
@property(nonatomic,retain) NSMutableArray * singerNameIdArray;
@property(nonatomic,assign) id<MyAppCellDelegate> myAppCellDelegate;;

-(void)analysisSingersData:(NSString *)singerNames;
-(int) filterSongName:(NSString *)songName;
-(void) filterSingerName:(NSString *)singerName;
-(IBAction)singerSearchSong:(id)sender;

@end


@class ShowInfoViewController;

@interface MyAppCell : ApplicationCell
{
    UIView *cellContentView;
    UIButton * collectButton;// add by liteng for 收藏按钮 20130427
}

@property(nonatomic,retain)UIButton * button;
@property(nonatomic,retain)UIView *cellContentView;
@property(nonatomic,retain)UIButton * collectButton;

- (void)setCell:(NSString *)songname songLanguage:(NSString *)Language Singer:(NSString*) singer SingerIdString:(NSString*) singerNoString;
@end
