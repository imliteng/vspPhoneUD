//
//  RequestSongs.h
//  VisionTouch
//
//  Created by v v on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiteDateBase.h"

@class SongRecord;

@protocol ParseSongsDelegate;

@interface RequestSongs : NSOperation <NSXMLParserDelegate>
{
    @private
        id <ParseSongsDelegate> delegate;
        SongRecord       *workingEntry;
        NSMutableString *workingPropertyString;
        NSArray         *elementsToParse;
        BOOL            storingCharacterData;
        NSIndexPath     *indexPathInTableView;
        int             itype;
        int             iSubType;
        NSString        *ncondition;
        NSString        *singerId;
        NSString        *songInfo;
        NSString        *songPrivateId;
        BOOL            stat;
        LiteDateBase *mySqlite;
        BOOL        recvFlag; // add by liteng 20130418
        BOOL        callReserve; // add by liteng 20130418
        NSInteger       reserveNO;// add by liteng 20130418
        NSString        *ktvID;
        NSString        *songID;
}

@property (nonatomic, assign) id <ParseSongsDelegate> delegate;
@property (nonatomic, retain) SongRecord *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, retain) NSString        *singerId;
@property (nonatomic, retain) NSString        *songInfo;
@property (nonatomic, retain) NSString        *songPrivateId;
@property (nonatomic, retain) NSString        *ncondition;
@property (nonatomic, retain) NSString        *ktvID;
@property (nonatomic, retain) NSString        *songID;

- (id)initWithIndex:(NSIndexPath*)index Tyep:(int)type SubType:(int) subType Condition:(NSString*)condition delegate:(id <ParseSongsDelegate>)theDelegate;
-(NSData*)requestSong:(NSIndexPath*) indexPath;

- (id)initWithIndexS:(NSIndexPath*)index Tyep:(int)type SubType:(int) subType Condition:(NSString*)condition SingerId:(NSString*)singerid delegate:(id <ParseSongsDelegate>)theDelegate;

@end

@protocol ParseSongsDelegate
- (void)didFinishParsing:(SongRecord *)appRecord index:(NSIndexPath*)index;
- (void)parseErrorOccurred:(NSError *)error;
@end