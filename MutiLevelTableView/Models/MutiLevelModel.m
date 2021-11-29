//
//  MutiLevelModel.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "MutiLevelModel.h"

@implementation MutiLevelModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"children": @"MutiLevelModel"
    };
}

@end

@implementation MutiLevelCraftModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"craft_id": @"id"
    };
}

@end
