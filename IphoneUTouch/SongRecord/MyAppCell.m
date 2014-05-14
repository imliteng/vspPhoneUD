//
//  MyAppCell.m
//  VisionTouch
//
//  Created by v v on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyAppCell.h"

#define MAX_RATING 5.0




@implementation SubviewBasedApplicationCellContentView

@synthesize singerButton;
@synthesize singerNameArray;
@synthesize singerNameIdArray;
@synthesize myAppCellDelegate;

- (id)initWithFrame:(CGRect)frame cell:(ApplicationCell *)cell
{
    if (self = [super initWithFrame:frame])
    {
        _cell = cell;
        self.opaque = YES;
        self.backgroundColor = _cell.backgroundColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGRect rectImage = self.bounds;
    rectImage.size.width=320;
// modify by liteng for 不使用cell背景图片 20130416
//    UIImage *ratingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cell" ofType:@"png"inDirectory:@"Images"] ];
//    [ratingImage drawInRect:rectImage];

/* add by liteng for 删除沉余button  20130416*/
    for(id tmpView in  self.subviews)
    {
        if([tmpView isKindOfClass:[UIButton class]])
        {
            UIButton *tmpButtonView = (UIButton *)tmpView;
                [tmpButtonView removeFromSuperview]; //删除子视图
        }
    }

/*  add by liteng for 歌星反查功能 20130416 */
    singerNameArray=[[NSMutableArray alloc] init];
    [self analysisSingersData:_cell.singerName];
    int tagNum=0;
    CGFloat width=7.0;
    for (NSString * tmpString in singerNameArray ) {
        NSLog(@"[%@]",tmpString);
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize size = [tmpString sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:  UILineBreakModeWordWrap];
        UIButton *saveButton= [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        CGRect frame = CGRectMake(width ,26.0 , size.width, 20.0);
        width+=size.width+5;
        saveButton.frame=frame;
        saveButton.tag=tagNum;
        [saveButton setTitle:tmpString forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(singerSearchSong:)forControlEvents:UIControlEventTouchUpInside];
        saveButton.backgroundColor=[UIColor clearColor];
        [self addSubview:saveButton];
        tagNum++;
    }
    [singerNameArray release];
    
    NSString * str=nil;
    if([_cell.songName length]>0)
    {
//        str=[[NSString alloc]initWithFormat:@"%@  [%@]",_cell.singerName,_cell.language];
        str=[[NSString alloc]initWithFormat:@"[%@]",_cell.language];
    }
    else 
    {
        str=[[NSString alloc]initWithFormat:@"%@",@""];
    }
    // modify by liteng for 预约名变色 20130418
    int colorType=[self filterSongName:_cell.songName];
    if (1==colorType)
        [[UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:3.0/255.0 alpha:1.0]set];
    else if(2==colorType)
        [[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:26.0/255.0 alpha:1.0]set];
    else
        [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]set];
//    [[UIColor greenColor]set];
    [_cell.songName drawAtPoint:CGPointMake(7.0, 0.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:20.0]];
    /*[[UIColor whiteColor]set];
    [_cell.language drawAtPoint:CGPointMake(100.0, 5.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:15.0]];*/
    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8]set];
    [str drawAtPoint:CGPointMake(width, 26.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:13.0]];
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted
{
    return _highlighted;
}

/*add by liteng for 截取歌手名称 20130416*/
-(void)analysisSingersData:(NSString *)singerNames
{
    [singerNames stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //去空格
    NSString * stringTem=[NSString stringWithFormat:@" "];
    NSRange range = [singerNames rangeOfString:stringTem];
    int location = range.location;
    NSString * tmpSingerName;
    NSString * tmpSingerNames;
    if (NSNotFound!=range.location) {
        tmpSingerName=[singerNames substringToIndex:location];
        [singerNameArray addObject:tmpSingerName];
        tmpSingerNames=[singerNames substringFromIndex:(location+1)];
        [self analysisSingersData:tmpSingerNames];
    }else{
        [singerNameArray addObject:singerNames];
    }
}

/*add by liteng for 颜色判断 20130418*/
-(int) filterSongName:(NSString *)songName
{
    NSString * stringTem=[NSString stringWithFormat:@"(预约"];
    NSRange range = [songName rangeOfString:stringTem];
    int location = range.location;
    if (NSNotFound!=range.location)
        return 1;
    else 
    {
        stringTem=[NSString stringWithFormat:@"<预约"];
        range = [songName rangeOfString:stringTem];
        location = range.location;
        if (NSNotFound!=range.location) {
            return 1;
        }else{
            stringTem=[NSString stringWithFormat:@"<无曲目"];
            range = [songName rangeOfString:stringTem];
            location = range.location;
            if (NSNotFound!=range.location) {
                return 2;
            }
        }
    }
    return 0;
}


/*add by liteng for  歌星反差接口  20130418*/
-(IBAction)singerSearchSong:(id)sender
{
    UIButton * tempButton=(UIButton *)sender;
    singerNameIdArray=[[NSMutableArray alloc] init];
    NSLog(@"1111223321121321132[%@]",_cell.singerIdString);
    [self filterSingerName:_cell.singerIdString];
//    [self.myAppCellDelegate searchSingerSong:[singerNameIdArray objectAtIndex:tempButton.tag] SingerName:_cell.singerName];
    [self.myAppCellDelegate searchSingerSong:[singerNameIdArray objectAtIndex:tempButton.tag] SingerName:tempButton.titleLabel.text];
    NSLog(@"[%@]==OnMessageSearchSong!",[singerNameIdArray objectAtIndex:tempButton.tag]);
    [singerNameIdArray release];
}

/*add by liteng  for 分拆歌手名称 20130419*/
-(void) filterSingerName:(NSString *)singerName
{
    NSLog(@"进入filterSingerName:[%@]",singerName);
    [singerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strFind=[NSString stringWithFormat:@";"];
    NSRange  range=[singerName rangeOfString:strFind];
    if (0==range.location) {
        NSString *singerStr=[singerName substringFromIndex:1];
        NSLog(@"+++++%@",singerStr);
        [self filterSingerName:singerStr];
    } else if(0<range.location&&0!=range.length){
        [singerNameIdArray addObject:[singerName substringToIndex:range.location]];
        NSString *singerStr=[singerName substringFromIndex:range.location];
        NSLog(@"#####%@",singerStr);
        [self filterSingerName:singerStr];
    } else{
        NSLog(@"歌曲名称过滤结束");
        for (NSString * tmpString in singerNameIdArray){
            NSLog(@"%@",tmpString);
        }
    }
}

@end


@implementation MyAppCell
@synthesize cellContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
     //   [self setBackgroundColor:[UIColor whiteColor]];
        cellContentView = [[SubviewBasedApplicationCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
        
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        collectButton=nil;
        [self.contentView addSubview:cellContentView];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [UIView setAnimationsEnabled:NO];
    CGSize contentSize = cellContentView.bounds.size;
    cellContentView.contentStretch = CGRectMake(0, 0.0, contentSize.width, 1.0);
    [UIView setAnimationsEnabled:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    cellContentView.backgroundColor = backgroundColor;
}

- (void)dealloc
{
    [cellContentView release];
    [super dealloc];
}

- (void)setCell:(NSString *)songname songLanguage:(NSString *)Language Singer:(NSString*) singer SingerIdString:(NSString*) singerNoString
{
    self.songName=songname;
    self.language=Language;
    self.singerName=singer;
    self.singerIdString=singerNoString;
    [cellContentView setNeedsDisplayInRect:cellContentView.bounds];
}



@end
