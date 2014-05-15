//
//  MyButtonItem.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyButtonItem.h"

#import <QuartzCore/QuartzCore.h>

NSString *const kFTAnimationPopOut = @"kFTAnimationPopOut";
NSString *const kFTAnimationName = @"kFTAnimationName";
NSString *const kFTAnimationType = @"kFTAnimationType";
NSString *const kFTAnimationTypeIn = @"kFTAnimationTypeIn";
NSString *const kFTAnimationTypeOut = @"kFTAnimationTypeOut";
NSString *const kFTAnimationTargetViewKey = @"kFTAnimationTargetViewKey";
NSString *const kFTAnimationCallerDelegateKey = @"kFTAnimationCallerDelegateKey";
NSString *const kFTAnimationCallerStartSelectorKey = @"kFTAnimationCallerStartSelectorKey";
NSString *const kFTAnimationCallerStopSelectorKey = @"kFTAnimationCallerStopSelectorKey";

@implementation MyButtonItem

@synthesize index;
@synthesize touchdelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithFrameAndimage:(CGRect)frame Image:(UIImage*)image Index:(NSInteger) iIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        index = iIndex;
        
        UIImageView * bgView=[[UIImageView alloc]initWithImage:image];
        bgView.frame=self.bounds;
        [self addSubview:bgView];
        [bgView release];

    }
    return self;
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint targetPoint = [[touches anyObject] locationInView:self];
    
    if(targetPoint.y>=5 && targetPoint.y<=self.bounds.size.height-5
       && targetPoint.x>=5 && targetPoint.x<=self.bounds.size.width-5)
    {
        CAAnimation *anim = [self popOutAnimationFor:self duration:0.2 Delegate:self startSelector:nil stopSelector:@selector(TouchInsideMe)];
        [self.layer addAnimation:anim forKey:kFTAnimationPopOut];
    }
}

-(void) TouchInsideMe
{
    [self.touchdelegate TouchUpDegate:self.index];
}

- (CAAnimation *)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration Delegate:(id)delegate1 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration * .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:0.5f];
    fadeOut.toValue = [NSNumber numberWithFloat:1.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeOut.beginTime = duration * .6f;
    fadeOut.fillMode = kCAFillModeBoth;
    
    return [self animationGroupFor:[NSArray arrayWithObjects:scale, fadeOut, nil] withView:view duration:duration 
                          Delegate:self startSelector:startSelector stopSelector:stopSelector 
                              name:kFTAnimationPopOut type:kFTAnimationTypeOut];
}

- (CAAnimationGroup *)animationGroupFor:(NSArray *)animations withView:(UIView *)view 
                               duration:(NSTimeInterval)duration Delegate:(id)delegate1 
                          startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector
                                   name:(NSString *)name type:(NSString *)type
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:animations];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    if([type isEqualToString:kFTAnimationTypeOut])
    {
        group.fillMode = kCAFillModeBoth;
    }
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:view forKey:kFTAnimationTargetViewKey];
    [group setValue:delegate1 forKey:kFTAnimationCallerDelegateKey];
    if(!startSelector)
    {
        startSelector = @selector(animationDidStart:);
    }
    [group setValue:NSStringFromSelector(startSelector) forKey:kFTAnimationCallerStartSelectorKey];
    if(!stopSelector)
    {
        stopSelector = @selector(animationDidStop:finished:);
    }
    [group setValue:NSStringFromSelector(stopSelector) forKey:kFTAnimationCallerStopSelectorKey];
    [group setValue:name forKey:kFTAnimationName];
    [group setValue:type forKey:kFTAnimationType];
    return group;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self TouchInsideMe];
}

@end
