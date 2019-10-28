//
//  MutiLevelViewModel.h
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutiLevelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MutiLevelViewModel : NSObject
/// 统一存储省，市，县的数据model
@property (nonatomic, strong) NSMutableArray *placesArray;
/// 记录条目关闭前的条目下的展开状态 元素是字典 @[@{@"name":name, @"array":array}, @{@"name":name1, @"array":array1}] array代表数据模型的数组 name代表地名
@property (nonatomic, strong) NSMutableArray *statesArray;
/// 存储数据model
@property (nonatomic, strong) NSMutableArray *craftsArray;
/// 所有craft数据model
@property (nonatomic, strong) NSMutableArray *allCraftsArray;
/// allCraftsArray - craftsArray
@property (nonatomic, strong) NSMutableArray *otherCraftsArray;
@end

NS_ASSUME_NONNULL_END
