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
/// 记录条目关闭前的条目下的展开状态 格式 @{@"id1":array1, @"id2":array2} 或者@{@"code1":array1, @"code2":array2}
@property (nonatomic, strong) NSMutableDictionary *statesDictionary;
/// 存储数据model
@property (nonatomic, strong) NSMutableArray *craftsArray;
/// 所有craft数据model
@property (nonatomic, strong) NSMutableArray *allCraftsArray;
/// allCraftsArray - craftsArray
@property (nonatomic, strong) NSMutableArray *otherCraftsArray;
@end

NS_ASSUME_NONNULL_END
