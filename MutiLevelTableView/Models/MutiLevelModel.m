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
    return @{@"children":@"MutiLevelSubModel"};
}

- (NSInteger)level {
    return 1;
}
@end


//
@implementation MutiLevelSubModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children":@"MutiLevelSubSubModel"};
}

- (NSInteger)level {
    return 2;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name=%@ level=%ld code=%@", self.name, (long)self.level, self.code];
}

@end



@implementation MutiLevelSubSubModel

- (NSInteger)level {
    return 3;
}

@end



@implementation MutiLevelCraftModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"craft_id":@"id"};
}

- (NSInteger)level {
    return 1;
}

@end
