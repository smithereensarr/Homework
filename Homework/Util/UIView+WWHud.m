//
//  UIView+WWHud.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "UIView+WWHud.h"
#import <JGProgressHUD.h>
#import <objc/runtime.h>

static const void *kCurrentHudKey = "kCurrentHudKey";

@interface UIView ()
@property (nonatomic, strong) JGProgressHUD *currentHud;
@end

@implementation UIView (WWHud)

- (void)ww_showLoading
{
    if ([self.currentHud.textLabel.text isEqualToString:@"Loading"]) {
        return;
    }
    
    self.currentHud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.currentHud.userInteractionEnabled = NO;
    self.currentHud.textLabel.text = @"Loading";
    [self.currentHud showInView:self];
}

- (void)ww_dismissLoading
{
    [self.currentHud dismiss];
    self.currentHud = nil;
}

- (void)ww_showErrorMsg:(NSString *)errorStr
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.userInteractionEnabled = NO;
    HUD.textLabel.text = errorStr ?: @"";
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

- (void)ww_showSuccessMsg:(NSString *)successStr
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    HUD.userInteractionEnabled = NO;
    HUD.textLabel.text = successStr ?: @"";
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

- (JGProgressHUD *)currentHud
{
    return objc_getAssociatedObject(self, kCurrentHudKey);
}

- (void)setCurrentHud:(JGProgressHUD *)currentHud
{
    objc_setAssociatedObject(self, kCurrentHudKey, currentHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
