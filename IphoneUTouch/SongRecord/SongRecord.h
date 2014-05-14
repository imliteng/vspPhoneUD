//
//  SongRecord.h
//  VisionTouch
//
//  Created by v v on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongRecord : NSObject
{
    NSString *songId;
    NSString *singer;
    NSString *songName;
    NSString *language;
    BOOL     isChange;
    NSString *pid;
    NSString *plOrder;
    NSString *privateId;
    BOOL    isReserve;
    NSString  *singerString;
    BOOL    isHave;
}

@property(nonatomic,retain) NSString *songId;
@property(nonatomic,retain) NSString *singer;
@property(nonatomic,retain) NSString *songname;
@property(nonatomic,retain) NSString *language;
@property BOOL isChange;
@property(nonatomic,retain) NSString *pid;
@property(nonatomic,retain) NSString *plOrder;
@property(nonatomic,retain) NSString *privateId;
@property BOOL isReserve;
@property(nonatomic,retain) NSString  *singerString;
@property BOOL    isHave;
@end
