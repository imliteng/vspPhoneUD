//
//  SingerRecord.h
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingerRecord : NSObject
{
    NSString * singerId;
    NSString * singerName;
}

@property (nonatomic,retain) NSString * singerId;
@property (nonatomic,retain) NSString * singerName;
@end
