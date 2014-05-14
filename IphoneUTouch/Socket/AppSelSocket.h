//
//  AppSelSocket.h
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>

#import <sys/uio.h> 
#import <unistd.h>

#import <sys/types.h>   
#import <sys/time.h>  
#import <netinet/in.h>   
#import <stdio.h>  
#import <string.h>   
#import <stdlib.h>  
#import <fcntl.h> 

@interface AppSelSocket : NSObject
{
    @private
        int sockfd;
}

-(int)initSocket;
-(int)TcpCall:(NSString *)HostAddr HostPort:(NSInteger)Port;
-(int)ReadN:(char*)buff ReadSize:(int)size ReadTimeOut:(int)timeout;
-(int)SendN:(NSString*)buff SendSize:(int)size SendTimeOut:(int)timeout; 

-(int)SendNS:(const char*)buff SendSize:(int)size SendTimeOut:(int)timeout;
-(void)CloseSocket;

@end
