//
//  WWEntrancePhysicsAnimation.h
//  Homework
//
//  Created by 王威 on 2019/2/27.
//  Copyright © 2019 王威. All rights reserved.
//
// 物理场入场动画类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWEntrancePhysicsAnimation : NSObject

- (instancetype)initWith:(UIView *)baseView completion:(void(^)(void))completion;
- (void)readyAnimation;
- (void)startAnimation;

@end

