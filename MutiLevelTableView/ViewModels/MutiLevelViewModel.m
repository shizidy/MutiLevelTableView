//
//  MutiLevelViewModel.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "MutiLevelViewModel.h"

@implementation MutiLevelViewModel


- (instancetype)init {
    if (self = [super init]) {
        [self initCityResource];
        [self initCraftResource];
    }
    return self;
}

- (void)initCityResource {
    NSString *fileStr = [[NSBundle mainBundle] pathForResource:@"cityResource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:fileStr];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //            NSLog(@"%@", jsonArray);
    NSMutableArray *provinces = [MutiLevelModel mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.placesArray addObjectsFromArray:provinces];
    
    for (MutiLevelModel *model in self.placesArray) {
        model.level = 1;//初始化第一层level = 1
    }
}

- (void)initCraftResource {
    NSString *fileStr = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:fileStr];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", jsonArray);
    NSMutableArray *crafts = [MutiLevelCraftModel mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.allCraftsArray addObjectsFromArray:crafts];
    for (MutiLevelCraftModel *model in crafts) {
        if (!model.pid) {
            [self.craftsArray addObject:model];
        } else {
            [self.otherCraftsArray addObject:model];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)placesArray {
    if (!_placesArray) {
        _placesArray = [NSMutableArray array];
    }
    return _placesArray;
}

- (NSMutableArray *)statesArray {
    if (!_statesArray) {
        _statesArray = [NSMutableArray array];
    }
    return _statesArray;
}

- (NSMutableArray *)craftsArray {
    if (!_craftsArray) {
        _craftsArray = [NSMutableArray array];
    }
    return _craftsArray;
}

- (NSMutableArray *)allCraftsArray {
    if (!_allCraftsArray) {
        _allCraftsArray = [NSMutableArray array];
    }
    return _allCraftsArray;
}

- (NSMutableArray *)otherCraftsArray {
    if (!_otherCraftsArray) {
        _otherCraftsArray = [NSMutableArray array];
    }
    return _otherCraftsArray;
}

@end
