//
//  RequestSingers.h
//  VisionTouch
//
//  Created by v v on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SingerRecord;

@protocol ParseSingerDelegate
- (void)didFinishParsingSinger:(SingerRecord *)appRecord index:(NSIndexPath*)index ;
- (void)parseErrorOccurred:(NSError *)error;
@end

@interface RequestSingers : NSOperation <NSXMLParserDelegate>
{
    @private
    id <ParseSingerDelegate> singerdelegate;
    SingerRecord       *workingEntry;
    NSMutableString *workingPropertyString;
    NSArray         *elementsToParse;
    BOOL            storingCharacterData;
    NSIndexPath     *indexPathInTableView;
    int             itype;
    NSString        *ncondition;
}

@property (nonatomic, assign) id <ParseSingerDelegate> singerdelegate;
@property (nonatomic, retain) SingerRecord *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic,retain) NSString        *ncondition;

- (id)initWithIndex:(NSIndexPath*)index Tyep:(int)type Condition:(NSString*)condition delegate:(id <ParseSingerDelegate> )theDelegate;

@end
