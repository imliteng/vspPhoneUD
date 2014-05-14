//
//  MySingerCell.m
//  IphoneUTouch
//
//  Created by v v on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MySingerCell.h"

@interface SingerCellContentView : UIView
{
    SingerCell *_cell;
    BOOL _highlighted;
}

@end

@implementation SingerCellContentView

- (id)initWithFrame:(CGRect)frame cell:(SingerCell *)cell
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
    /*add by liteng for 背景变更 20130502*/
//    CGRect rectImage = self.bounds;
//    rectImage.size.width=320;
//    UIImage *ratingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cell" ofType:@"png"inDirectory:@"Images"] ];
//    [ratingImage drawInRect:rectImage];
    
    [[UIColor whiteColor]set];
    [_cell.SingerName drawAtPoint:CGPointMake(10.0, 5.0) withFont:[UIFont fontWithName:@"MicrosoftYaHei" size:25.0]];//
    
   /* CGRect imageRect=CGRectMake(2, 2, 50, 56);
    UIImage *BackgroundImage = [UIImage imageNamed:@"book"] ;
    //[BackgroundImage drawAtPoint:ImageOrigin];
    [BackgroundImage drawInRect:imageRect];*/
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


@implementation MySingerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cellContentView = [[SingerCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
        
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

- (void)setCell:(NSString *)szName;
{
    self.SingerName=szName;
    
    [cellContentView setNeedsDisplayInRect:cellContentView.bounds];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
