//
//  UIView+WWHud.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (WWHud)

- (void)ww_showLoading;
- (void)ww_dismissLoading;

- (void)ww_showErrorMsg:(NSString *)errorStr;
- (void)ww_showSuccessMsg:(NSString *)successStr;

@end

