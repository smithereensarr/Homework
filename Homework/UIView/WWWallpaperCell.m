//
//  WWWallpaperCell.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperCell.h"
#import <UIImageView+YYWebImage.h>
#import <Masonry.h>

@interface WWWallpaperCell ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation WWWallpaperCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)loadData:(WWWallpaperItemModel *)data
{
    [self.imgView yy_setImageWithURL:data.smallUrl options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}
@end
