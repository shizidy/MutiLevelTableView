//
//  MutiLevelModel.h
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface MutiLevelModel : NSObject
/// 下级
@property (nonatomic, strong) NSArray *children;
/// 城市代码
@property (nonatomic, strong) NSString *code;
/// 城市名称
@property (nonatomic, strong) NSString *name;
/// 层级
@property (nonatomic, assign) NSInteger level;
/// 记录是否展开
@property (nonatomic, assign) BOOL isExpand;
@end

@interface MutiLevelCraftModel : NSObject
@property (nonatomic, strong) NSString *craft_type;
@property (nonatomic, strong) NSString *craft_id;
@property (nonatomic, strong) NSString *level_code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;
/// 层级
@property (nonatomic, assign) NSInteger level;
/// 记录是否展开
@property (nonatomic, assign) BOOL isExpand;
@end

NS_ASSUME_NONNULL_END
