//
//  WWVerticalFlowLayout.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWVerticalFlowLayoutDelegate <NSObject>

- (CGFloat)cellWHRateForIndexPath:(NSIndexPath *)indexPath;

@end

@interface WWVerticalFlowLayout : UICollectionViewLayout

- (instancetype)initWidthDelegate:(id<WWVerticalFlowLayoutDelegate>)delegate;

@end

