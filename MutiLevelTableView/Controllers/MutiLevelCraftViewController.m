//
//  MutiLevelCraftViewController.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/20.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "MutiLevelCraftViewController.h"
#import "MutiLevelCell.h"
#import "MutiLevelViewModel.h"

@interface MutiLevelCraftViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MutiLevelViewModel *viewModel;
@end

@implementation MutiLevelCraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.craftsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MutiLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MutiLevelCell class]) forIndexPath:indexPath];
    [cell setCellWithViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取cell
    MutiLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //获取点击行的数据model
    MutiLevelCraftModel *selectedModel = self.viewModel.craftsArray[indexPath.row];
    NSMutableArray *modelArray = [NSMutableArray array];
    BOOL isMatched = NO;
    if (self.viewModel.statesArray.count > 0) {
        for (NSMutableDictionary *dict in self.viewModel.statesArray) {
            NSString *name = dict[@"name"];
            if ([name isEqualToString:selectedModel.name]) {
                modelArray = dict[@"array"];
                isMatched = YES;
                break;
            }
        }
    }
    if (!isMatched || self.viewModel.statesArray.count == 0) {
        NSMutableArray *allCraftsArrayCopy = [self.viewModel.allCraftsArray mutableCopy];
        [allCraftsArrayCopy removeObjectsInArray:self.viewModel.craftsArray];
        self.viewModel.otherCraftsArray = allCraftsArrayCopy;
        for (MutiLevelCraftModel *model in self.viewModel.otherCraftsArray) {
            if ([model.pid isEqualToString:selectedModel.craft_id]) {
                [modelArray addObject:model];
            }
        }
        //对marray内的model依据level_code进行排序，因为level_code数值的小数点后数字表示其顺序
        [self quickSortMutiLevelCraftModelByLevel_codeWithArray:modelArray leftIndex:0 rightIndex:modelArray.count - 1];
    }
    
    if (!selectedModel.isExpand) {
        selectedModel.isExpand = YES;
        //旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        NSMutableArray *indexArray = [NSMutableArray array];
        for (int i = 1; i <= modelArray.count; i++) {
            NSIndexPath *index_path = [NSIndexPath indexPathForRow:indexPath.row + i inSection:0];
            [indexArray addObject:index_path];
            [self.viewModel.craftsArray insertObject:modelArray[i - 1] atIndex:indexPath.row + i];
        }
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    } else {
        selectedModel.isExpand = NO;
        //旋转动画
        [cell makeArrowImgViewRotation:0];
        
        NSMutableArray *indexArray = [NSMutableArray array];
        NSInteger length = 0;
        NSInteger i = indexPath.row + 1;
        NSArray *array1 = [selectedModel.level_code componentsSeparatedByString:@"."];
        for (i = indexPath.row + 1; i < self.viewModel.craftsArray.count; i++) {
            MutiLevelCraftModel *endModel = self.viewModel.craftsArray[i];
            NSArray *array2 = [endModel.level_code componentsSeparatedByString:@"."];
            if (array1.count >= array2.count) {
                break;
            }
            NSIndexPath *index_path = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArray addObject:index_path];
        }
        length = i - indexPath.row - 1;
        if (length <= 0) {
            return;
        }
        NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
        BOOL isMatched = NO;
        for (NSMutableDictionary *dict in self.viewModel.statesArray) {
            NSString *name = dict[@"name"];
            if ([name isEqualToString:selectedModel.name]) {
                dict[@"array"] = [self.viewModel.craftsArray subarrayWithRange:NSMakeRange(indexPath.row + 1, length)];
                isMatched = YES;
                break;
            }
        }
        if (!isMatched) {
            modelDict[@"array"] = [self.viewModel.craftsArray subarrayWithRange:NSMakeRange(indexPath.row + 1, length)];
            modelDict[@"name"] = selectedModel.name;
            [self.viewModel.statesArray addObject:modelDict];
        }
        [self.viewModel.craftsArray removeObjectsInRange:NSMakeRange(indexPath.row + 1, length)];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

//快速排序
- (void)quickSortMutiLevelCraftModelByLevel_codeWithArray:(NSMutableArray *)marray leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    if (left >= right) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    MutiLevelCraftModel *model = marray[i];
    NSInteger key = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    
    while (i < j) {
        while (i < j && [self getCondition1WithArray:marray key:key index:j]) {//从右边找到比key小的
            j--;
        }
        marray[i] = marray[j];
        
        while (i < j && [self getCondition2WithArray:marray key:key index:i]) {//从左边找到比key大的
            i++;
        }
        marray[j] = marray[i];
    }
    marray[i] = model;//把基准数放在正确的位置
    //递归
    [self quickSortMutiLevelCraftModelByLevel_codeWithArray:marray leftIndex:left rightIndex:i - 1];//排序基准数左边的
    [self quickSortMutiLevelCraftModelByLevel_codeWithArray:marray leftIndex:i + 1 rightIndex:right];//排序基准数右边的
}

- (NSString *)getLastStringWith:(NSString *)string separateBy:(NSString *)character {
    NSArray *array = [string componentsSeparatedByString:character];
    return array.lastObject;
}

- (BOOL)getCondition1WithArray:(NSMutableArray *)marray key:(NSInteger)key index:(NSInteger)index {
    MutiLevelCraftModel *model = marray[index];
    NSInteger keyIndex = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    return keyIndex >= key;
}

- (BOOL)getCondition2WithArray:(NSMutableArray *)marray key:(NSInteger)key index:(NSInteger)index {
    MutiLevelCraftModel *model = marray[index];
    NSInteger keyIndex = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    return keyIndex <= key;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MutiLevelCell class] forCellReuseIdentifier:NSStringFromClass([MutiLevelCell class])];
    }
    return _tableView;
}

- (MutiLevelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MutiLevelViewModel alloc] init];
    }
    return _viewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
