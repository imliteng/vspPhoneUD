//
//  SongBySingerCell.m
//  VisionTouch
//
//  Created by v v on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongBySingerCell.h"


#define MAX_RATING 5.0

@interface SubviewBasedApplicationCellContentV : UIView
{
    ApplicationCell *_cell;
    BOOL _highlighted;
}

@end

@implementation SubviewBasedApplicationCellContentV

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
    [[UIColor whiteColor]set];
    [_cell.songName drawAtPoint:CGPointMake(10.0, 11.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:19.0]];//UIFont boldSystemFontOfSize:20.0]];//歌名
    [[UIColor whiteColor]set];
    [_cell.language drawAtPoint:CGPointMake(520.0, 11.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:19.0]];//[UIFont boldSystemFontOfSize:17.0]];//语种
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

@end


@implementation SongBySingerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        cellContentView = [[SubviewBasedApplicationCellContentV alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
        
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
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

- (void)setCell:(NSString *)songname songLanguage:(NSString *)Language Singer:(NSString*) singer
{
    self.songName=songname;
    self.language=Language;
    self.singerName=singer;
    [cellContentView setNeedsDisplayInRect:cellContentView.bounds];
}


@end
