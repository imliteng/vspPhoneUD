//
//  LiteDateBase.m
//  VisionTouch
//
//  Created by v v on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LiteDateBase.h"

extern NSString * filePath;

@implementation LiteDateBase

-(BOOL) OpenDB:(NSString *) dbName
{
#if TARGET_IPHONE_SIMULATOR
    NSString *path=@"/Users/mac/Desktop/VisionProject/AppPhoneUD/IphoneUTouch_online_ios7.1/IphoneUTouch/IphoneUTouch/Song.db";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString* sFilePath=[documentsDirectory stringByAppendingPathComponent:@"Images"];;
    NSString *path= [documentsDirectory stringByAppendingPathComponent:@"/Song.db"];
#endif
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    //找到数据库文件
    if (find)
    {
        //NSLog(@"DB Path %@  have already existed",path);
        if(sqlite3_open([path UTF8String], &_sqlite) != SQLITE_OK)
        //if(sqlite3_open_v2([path UTF8String], &_sqlite, SQLITE_OPEN_FULLMUTEX, NULL) != SQLITE_OK)
        {
            sqlite3_close(_sqlite);
            _sqlite=NULL;
            NSLog(@"Error: open database file.");
            return NO;
        }
        return YES;
    }
    else
    {
         NSLog(@"DB Path %@",path);
    }
    return NO;
}

-(BOOL) CloseDB
{
    if(_sqlite)
    {
        sqlite3_close(_sqlite);
        _sqlite=NULL;
    }
    return YES;
}

-(void) GetRecords:(NSMutableArray*) recordsArray
{
    sqlite3_stmt *statement = nil;
	char *sql = "SELECT * FROM SongInfo limit 20";
	if (sqlite3_prepare_v2(_sqlite, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: ");
        return ;
	}
    
	while (sqlite3_step(statement) == SQLITE_ROW)
    {
        char* stkid= (char *)sqlite3_column_text(statement, 0);
        char* sid = (char*)sqlite3_column_text(statement, 1);
        char* sname =(char*)sqlite3_column_text(statement, 2);
        char* slanguage = (char*)sqlite3_column_text(statement, 3);
        char* ssinger= (char*)sqlite3_column_text(statement, 4);
        
        SongRecord* ri = [[SongRecord alloc] init];
        ri.pid=[NSString stringWithCString:stkid encoding:NSUTF8StringEncoding];//此处pid代表数据库的自增字段
        ri.songId = [NSString stringWithCString:sid encoding:NSUTF8StringEncoding];
        ri.songname = [NSString stringWithCString:sname encoding:NSUTF8StringEncoding];
        ri.language = [NSString stringWithCString:slanguage encoding:NSUTF8StringEncoding];
        ri.singer = [NSString stringWithCString:ssinger encoding:NSUTF8StringEncoding];
        
        [recordsArray addObject:ri];
        [ri release];
	}
	sqlite3_finalize(statement);
}

-(int) GetRecordsCount
{
    int count=0;
    sqlite3_stmt *statement = nil;
    char * sql= "select count(*) from SongInfo";
    
    if (sqlite3_prepare_v2(_sqlite, sql, -1, &statement, NULL) == SQLITE_OK)
    {
    	if(sqlite3_step(statement) == SQLITE_ROW)
        {
            count=sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    return count;
}

-(void) DoClearRecords
{
    char *sql = "delete from SongInfo";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_sqlite, sql, -1, &statement, nil) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement:create reports table");
        return ;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE)
    {
        NSLog(@"Error: failed to dehydrate:delete TABLE reports");
        return ;
    }   
}

-(BOOL) InsertRecord:(NSString*)sql
{
    char *errMsg;
    if(_sqlite==NULL)
    {
        return NO;
    }
    if(sqlite3_exec(_sqlite,[sql UTF8String] ,NULL,NULL,&errMsg)==SQLITE_OK)
    {
        return YES;
    }
    return NO;
}

-(BOOL) DelRecord:(NSString*)sql
{
    char *errMsg;
    if(_sqlite==NULL)
    {
        return NO;
    }
    if(sqlite3_exec(_sqlite,[sql UTF8String] ,NULL,NULL,&errMsg)==SQLITE_OK)
    {
        return YES;
    }
    return NO;
}

/*用于执行sql*/
-(BOOL) ExecSqlCmd:(NSString*)sql
{
    char *errMsg;
    if(_sqlite==NULL)
    {
        return NO;
    }
    if(sqlite3_exec(_sqlite,[sql UTF8String] ,NULL,NULL,&errMsg)==SQLITE_OK)
    {
        return YES;
    }
    return NO;
}

/*用于查询记录数*/
-(int)getPersonalSongCount
{
    NSString *sqlQuery = @"SELECT COUNT(1) FROM personalSongInfo";
    sqlite3_stmt * statement;
    char *count=NULL ;
    int reCount=0;
    if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            count = (char*)sqlite3_column_text(statement, 0);
            NSString * nsCount=[[NSString alloc] initWithFormat:@"%s",count];
            NSLog(@"私人曲库记录数为[%@]",nsCount);
            reCount=[nsCount intValue];
        }
    }
    return reCount;
}

/*用于查询私人曲库数据*/
-(SongRecord*)getPersonalSongInfo:(NSIndexPath *) IndexPath
{
    NSString *sqlQuery = @"SELECT songName,language,singerName,rowid,songID,isHave FROM personalSongInfo order by rowid";
    sqlite3_stmt * statement;
    NSMutableArray * recordArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *songName=(char *)sqlite3_column_text(statement, 0);
            NSString * songNameNs=[[NSString alloc] initWithUTF8String:songName];
            char *language=(char *)sqlite3_column_text(statement, 1);
            NSString * languageNs=[[NSString alloc] initWithUTF8String:language];
            char *singerName=(char *)sqlite3_column_text(statement, 2);
            NSString * singerNameNs=[[NSString alloc] initWithUTF8String:singerName];
            char *privateid=(char *)sqlite3_column_text(statement, 3);
            NSString * privateidNs=[[NSString alloc] initWithUTF8String:privateid];
            char *songid=(char *)sqlite3_column_text(statement, 4);
            NSString * songidNs=[[NSString alloc] initWithUTF8String:songid];
            char *isHave=(char *)sqlite3_column_text(statement, 5);
            NSString * isHaveNs=[[NSString alloc] initWithUTF8String:isHave];
            SongRecord* tmpSongRecord=[[[SongRecord alloc] init] autorelease];
            tmpSongRecord.privateId=privateidNs;
            tmpSongRecord.singer=singerNameNs;
            tmpSongRecord.songname=songNameNs;
            tmpSongRecord.language=languageNs;
            tmpSongRecord.pid=nil;
            tmpSongRecord.plOrder=nil;
            tmpSongRecord.isChange=nil;
            tmpSongRecord.songId=songidNs;
            tmpSongRecord.isHave=[isHaveNs intValue];
            [recordArray addObject:tmpSongRecord];
//            NSLog(@"row>> name=%@,language=%@,singerName=%@",songNameNs,languageNs,singerNameNs);
        }
    }
    sqlite3_finalize(statement);
    return [recordArray objectAtIndex:IndexPath.row];
}

/*用于删除私人曲库中的数据*/
-(BOOL)deletePersonalSongInfo:(NSString*)songID
{
    [songID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * cmdSqlString=[[NSString alloc] initWithFormat:@"delete from personalSongInfo where rowid=%@",songID];
    NSLog(@"=================0000000%@",cmdSqlString);
    return [self ExecSqlCmd:cmdSqlString];
}

/*用于获取私人曲库*/
-(NSMutableArray*)getAllPrivateSongsInfo
{
    NSString *sqlQuery = @"SELECT songName,language,singerName,rowid,songID FROM personalSongInfo order by rowid";
    sqlite3_stmt * statement;
    NSMutableArray * recordArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *songName=(char *)sqlite3_column_text(statement, 0);
            NSString * songNameNs=[[NSString alloc] initWithUTF8String:songName];
            char *language=(char *)sqlite3_column_text(statement, 1);
            NSString * languageNs=[[NSString alloc] initWithUTF8String:language];
            char *singerName=(char *)sqlite3_column_text(statement, 2);
            NSString * singerNameNs=[[NSString alloc] initWithUTF8String:singerName];
            char *privateid=(char *)sqlite3_column_text(statement, 3);
            NSString * privateidNs=[[NSString alloc] initWithUTF8String:privateid];
            char *songid=(char *)sqlite3_column_text(statement, 4);
            NSString * songidNs=[[NSString alloc] initWithUTF8String:songid];
            SongRecord* tmpSongRecord=[[SongRecord alloc] init];
            tmpSongRecord.privateId=privateidNs;
            tmpSongRecord.singer=singerNameNs;
            tmpSongRecord.songname=songNameNs;
            tmpSongRecord.language=languageNs;
            tmpSongRecord.pid=nil;
            tmpSongRecord.plOrder=nil;
            tmpSongRecord.isChange=nil;
            tmpSongRecord.songId=songidNs;
            [recordArray addObject:tmpSongRecord];
            [tmpSongRecord release];
//            NSLog(@"row>>name=%@,language=%@,singerName=%@,songID=%@",songNameNs,languageNs,singerNameNs,songidNs);
        }
    }
    sqlite3_finalize(statement);
    return recordArray;
}

/*用于获取KTV信息表的数据行数*/
-(int)getKTVCountRows
{
    NSString *sqlQuery = @"SELECT count(1) FROM ktvInfo";
    sqlite3_stmt * statement;
    int rows=0;
     if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
         while (sqlite3_step(statement)==SQLITE_ROW) {
             char *recordCount=(char *)sqlite3_column_text(statement, 0);
             rows=atoi(recordCount);
         }
     }
    sqlite3_finalize(statement);
    return rows;
}

/*用于获取最后一次KTV的ID值*/
-(NSString*)getLastKtvID
{
    NSString *sqlQuery = @"SELECT ktvID FROM ktvInfo";
    sqlite3_stmt * statement;
    NSString *ktvIdStringNs=nil;
    if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *ktvIDString=(char *)sqlite3_column_text(statement, 0);
            ktvIdStringNs=[NSString stringWithFormat:@"%s",ktvIDString];
        }
    }
    sqlite3_finalize(statement);
    return ktvIdStringNs;
}

@end
