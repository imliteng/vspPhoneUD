//
//  LiteDateBase.h
//  VisionTouch
//
//  Created by v v on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "SongRecord.h"

@interface LiteDateBase : NSObject
{
     @private
    sqlite3 * _sqlite;
}

-(BOOL) OpenDB:(NSString *) dbName;
-(BOOL) CloseDB;
-(void) GetRecords:(NSMutableArray*) recordsArray;
-(int) GetRecordsCount;
-(void) DoClearRecords;
-(BOOL) InsertRecord:(NSString*)sql;
-(BOOL) DelRecord:(NSString*)sql;
-(BOOL) ExecSqlCmd:(NSString*)sql;
-(int)getPersonalSongCount;
-(SongRecord*)getPersonalSongInfo:(NSIndexPath *) IndexPath;
-(BOOL)deletePersonalSongInfo:(NSString*)songID;
-(NSMutableArray*)getAllPrivateSongsInfo;
-(int)getKTVCountRows;
-(NSString*)getLastKtvID;
@end
