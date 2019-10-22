//
//  MutiLevelCell.h
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutiLevelViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MutiLevelCell : UITableViewCell
/// 箭头
@property (nonatomic, strong) UIImageView *arrowImgView;
/// 给cell赋值
/// @param viewModel viewModel
/// @param indexPath indexPath
- (void)fillCellWithViewModel:(MutiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;
/// 给cell赋值
/// @param viewModel viewModel
/// @param indexPath indexPath
- (void)setCellWithViewModel:(MutiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;
/// 给定角度旋转arrowImgView
/// @param rotation 旋转度数
- (void)makeArrowImgViewRotation:(CGFloat)rotation;
@end

NS_ASSUME_NONNULL_END
