//
//  MyButtonItem.h
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>

@protocol TouchUpInsideMeDegate <NSObject>
-(void)TouchUpDegate:(NSInteger)index;
@end

@interface MyButtonItem : UIView
{
    NSInteger index;
    id<TouchUpInsideMeDegate> touchdelegate;
}

@property (nonatomic,assign) id<TouchUpInsideMeDegate> touchdelegate;
@property (nonatomic) NSInteger index;

- (id)initWithFrameAndimage:(CGRect)frame Image:(UIImage*)image Index:(NSInteger) iIndex;
-(void) TouchInsideMe;

- (CAAnimation *)popOutAnimationFor:(UIView *)view duration:(NSTimeInterval)duration Delegate:(id)delegate1 
                      startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector;

- (CAAnimationGroup *)animationGroupFor:(NSArray *)animations withView:(UIView *)view 
                               duration:(NSTimeInterval)duration Delegate:(id)delegate1
                          startSelector:(SEL)startSelector stopSelector:(SEL)stopSelector 
                                   name:(NSString *)name type:(NSString *)type;

@end
