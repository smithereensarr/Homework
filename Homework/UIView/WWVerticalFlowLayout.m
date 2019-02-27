//
//  WWVerticalFlowLayout.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWVerticalFlowLayout.h"

static const NSInteger kColumnCount = 2;//列数
static const CGFloat kXMargin = 5.0;//item水平间距;
static const CGFloat kYMargin = 5.0;//item垂直间距;
static const UIEdgeInsets kEdgeInsets = {10, 10, 10, 10};//容器整体边缘内距

@interface WWVerticalFlowLayout ()

@property (nonatomic, weak) id<WWVerticalFlowLayoutDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnBottomYArray;//每列底部坐标集合
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cellAttributeArray;

@end

@implementation WWVerticalFlowLayout

- (instancetype)initWidthDelegate:(id<WWVerticalFlowLayoutDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma makr - overwrite
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.columnBottomYArray removeAllObjects];
    [self.cellAttributeArray removeAllObjects];
    
    //重新计算成员变量的值
    for (int i = 0; i < kColumnCount; i++) {
        [self.columnBottomYArray addObject:@(kEdgeInsets.top)];
    }
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [self.cellAttributeArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //计算当前cell的frame
    CGFloat cellWidth = (self.collectionView.frame.size.width - kEdgeInsets.left - kEdgeInsets.right - kXMargin * (kColumnCount - 1)) / (CGFloat)kColumnCount;
    //这里需要对宽度进行向下取整，否则会因为长度溢出布局换行
    cellWidth = floorf(cellWidth);
    CGFloat whRate = [self.delegate cellWHRateForIndexPath:indexPath] ?: 1;
    CGFloat cellHeight = cellWidth / whRate;
    //找到当前最短的那一列
    NSNumber *minBottomY = self.columnBottomYArray.firstObject;
    for (NSNumber *number in self.columnBottomYArray) {
        if ([number floatValue] < [minBottomY floatValue]) {
            minBottomY = number;
        }
    }
    NSInteger columnIndex = [self.columnBottomYArray indexOfObject:minBottomY];
    CGFloat currentColumnBottomY = [self.columnBottomYArray[columnIndex] floatValue];
    CGFloat x = kEdgeInsets.left + (kXMargin + cellWidth) * columnIndex;
    CGFloat y = currentColumnBottomY + kYMargin;

    //保存当前列的最底部坐标
    currentColumnBottomY += (cellHeight + kYMargin);
    [self.columnBottomYArray replaceObjectAtIndex:columnIndex withObject:@(currentColumnBottomY)];
    
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    atrbs.frame = CGRectMake(x, y, cellWidth, cellHeight);

    return atrbs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.cellAttributeArray;
}

- (CGSize)collectionViewContentSize
{
    //最长一列的bottom坐标
    CGFloat maxBottomY = [self.columnBottomYArray.firstObject floatValue];
    for (NSNumber *number in self.columnBottomYArray) {
        if ([number floatValue] > maxBottomY) {
            maxBottomY = [number floatValue];
        }
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, maxBottomY + kEdgeInsets.bottom);
}

#pragma mark - property
- (NSMutableArray *)cellAttributeArray
{
    if (!_cellAttributeArray) {
        _cellAttributeArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributeArray;
}

- (NSMutableArray *)columnBottomYArray
{
    if (!_columnBottomYArray) {
        _columnBottomYArray = [[NSMutableArray alloc] init];
    }
    return _columnBottomYArray;
}
@end
