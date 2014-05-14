//
//  AppSelSocket.m
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppSelSocket.h"
#import  <sys/time.h>
#import  <_structs.h>
#import  <sys/select.h>
@implementation AppSelSocket

-(int)initSocket
{
    if((sockfd=socket(AF_INET,SOCK_STREAM,0))==-1)
    {
        return -1; 
    }
    return 0;
}

-(void)CloseSocket
{
    close(sockfd);
}

-(int)TcpCall:(NSString *)HostAddr HostPort:(NSInteger)Port
{
    struct sockaddr_in sev_addr;
    sev_addr.sin_family = AF_INET;
    sev_addr.sin_addr.s_addr = inet_addr([HostAddr UTF8String]);
    sev_addr.sin_port = htons(Port);
    bzero(&(sev_addr.sin_zero), 8);
    //设置为非组赛
    int flags = fcntl(sockfd, F_GETFL,0);
    fcntl(sockfd,F_SETFL, flags | O_NONBLOCK);
    
    //int conn = connect(sockfd, (struct sockaddr*)&sev_addr,sizeof(struct sockaddr));// sizeof(sev_addr));

    int error=-1, len;
    struct timeval tm;
    fd_set set;
    bool ret=false;
    if(connect(sockfd,(struct sockaddr *)&sev_addr,sizeof(struct sockaddr))==-1)
    {
        tm.tv_sec=3;
        tm.tv_usec=0;
        FD_ZERO(&set);
        FD_SET(sockfd,&set);
        if(select(sockfd+1,NULL,&set,NULL,&tm)>0)
        {
            getsockopt(sockfd,SOL_SOCKET,SO_ERROR,&error,(socklen_t *)&len);
            if(error==0)
                ret=true;
            else 
                ret=false;
        }
    }
    if(ret)
    {
        //连接成功，改为阻塞 
        flags=fcntl(sockfd,F_GETFL,0);
        flags&=~O_NONBLOCK;
        fcntl(sockfd,F_SETFL,flags);
        return 0;
    }
    else
    {
        return -1;
    }
    //return conn;
}

-(int)ReadN:(char*)buff ReadSize:(int)size ReadTimeOut:(int)timeout;
{
    int ret=0;
    int  err=0;
    
    long startTime,currentTime;
	struct timeval tt;
    fd_set set;
    int found;
    
	time( &startTime );
	if(timeout==-1)
	{
		timeout=5;
	}
    
    while(size >0)  
	{
        time( &currentTime );
		tt.tv_sec = timeout - ( currentTime - startTime );
		tt.tv_usec = 0;
		sleep(0.003);
		if ( tt.tv_sec <= 0 )
		{
			err = -1;
			break;
		}
        FD_ZERO(&set);
        FD_SET(sockfd,&set);
        found =select(sockfd+1,NULL,&set,NULL,&tt);
        if(found<=0)
        {
            return -1;
        }
        ret = recv(sockfd,buff,size,0);
		if(ret<=0) 
		{ 
            err=-1;
			break;
		}
		size -= ret; 
        buff+=ret;
    }
    
    return err;
}

-(int)SendN:(NSString*)buff SendSize:(int)size SendTimeOut:(int)timeout
{
    NSData *data=[buff dataUsingEncoding:NSUTF8StringEncoding];   
    ssize_t datalen=send(sockfd,[data bytes],[data length],0);
    if(datalen!=size)
    {
        return -1;
    }
    return 0;
}

-(int)SendNS:(const char*)buff SendSize:(int)size SendTimeOut:(int)timeout
{
    int err=0;
    int n=0;
    long	startTime, currentTime;
    struct timeval	tt;
    fd_set set;
    int found;
    
    if(timeout==-1)
    {
        timeout=5;
    }
    time( &startTime );
    while (size > 0 )  
    {
        time( &currentTime );
        tt.tv_sec = timeout - ( currentTime - startTime );
        tt.tv_usec = 0;
        if ( tt.tv_sec <= 0 ) 
        {
            err = -1;
            break;
        }
        FD_ZERO(&set);
        FD_SET(sockfd,&set);
        found =select(sockfd+1,NULL,&set,NULL,&tt);
        if(found<=0)
        {
            return -1;
        }
        
        n = send( sockfd, buff,size,0);
        if (n <= 0 ) 
        {
            err = -2;
            break;
        }
        size -= n;
        buff += n;  
    }
    return err;
}

@end
