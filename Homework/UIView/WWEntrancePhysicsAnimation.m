//
//  WWEntrancePhysicsAnimation.m
//  Homework
//
//  Created by 王威 on 2019/2/27.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWEntrancePhysicsAnimation.h"

@interface WWEntrancePhysicsAnimation () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, weak) UIView *baseView;
@end

@implementation WWEntrancePhysicsAnimation

- (instancetype)initWith:(UIView *)baseView completion:(void(^)(void))completion
{
    self = [self init];
    if (self) {
        self.baseView = baseView;
        self.completion = completion;
    }
    return self;
}

- (void)readyAnimation
{
    //蒙版视图
    self.baseView.maskView = self.maskView;
}

- (void)startAnimation
{
    if (!self.baseView.maskView) {
        return;
    }
    
    [self.animator removeAllBehaviors];
    //元素性质
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.maskView]];
    itemBehavior.elasticity = 0.6;
    [self.animator addBehavior:itemBehavior];
    //垂直重力
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.maskView]];
    gravityBehavior.magnitude = 5;
    [self.animator addBehavior:gravityBehavior];
    //水平推力
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.maskView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = 10;
    CGVector pushVector = {9, 0};
    pushBehavior.pushDirection = pushVector;
    [self.animator addBehavior:pushBehavior];
    //碰撞墙
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.maskView]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    [collisionBehavior addBoundaryWithIdentifier:@"w" fromPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height - 200) toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
    [collisionBehavior addBoundaryWithIdentifier:@"h" fromPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - 20, 0) toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height)];
    [self.animator addBehavior:collisionBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [_animator removeAllBehaviors];
    _animator = nil;
    
    //执行蒙版放大动画
    [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center = self.baseView.center;
        self.maskView.frame = [UIScreen mainScreen].bounds;
        self.maskView.center = center;
        self.maskView.layer.cornerRadius = 0;
    } completion:^(BOOL finished) {
        self.baseView.maskView = nil;
    }];
    
    if (self.completion) {
        self.completion();
    }
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.baseView];
        _animator.delegate = self;
    }
    return _animator;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(-100, -100, 100, 100)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.layer.cornerRadius = 50;
        _maskView.layer.masksToBounds = YES;
    }
    return _maskView;
}
@end
