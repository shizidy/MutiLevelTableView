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
/// tableView
@property (nonatomic, strong) UITableView *tableView;
/// viewModel
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
    return self.viewModel.craftsArray.count > 0;
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
    
    BOOL isMatched = NO;
    for (MutiLevelCraftModel *craftModel in self.viewModel.allCraftsArray) {
        if ([craftModel.craft_id isEqualToString:selectedModel.craft_id]) {
            continue;
        }
        if ([craftModel.pid isEqualToString:selectedModel.craft_id]) {
            isMatched = YES;
            break;
        }
    }
    if (!isMatched) {
        /*
         1.倒序查找父节点即可找到层级关系
         2.查找思路：对比level值大小，倒序找到第一个比自己level值小的即为自己的父级
         3.level值的层级关系定义是：level值为0->1->2->3...
         */
        // 初始化第一个节点为本节点
        NSMutableArray<MutiLevelCraftModel *> *marray = [NSMutableArray arrayWithObject:selectedModel];
        // 初始化str
        NSString *str = selectedModel.name;
        // 初始化level
        NSInteger level = [selectedModel.level_code componentsSeparatedByString:@"."].count;
        for (NSInteger i = indexPath.row - 1; i >= 0; i--) {
            MutiLevelCraftModel *tmpModel = self.viewModel.craftsArray[i];
            NSInteger tmpLevel = [tmpModel.level_code componentsSeparatedByString:@"."].count;
            if (level > tmpLevel) {
                str = [NSString stringWithFormat:@"%@->%@", tmpModel.name, str];
                [marray insertObject:tmpModel atIndex:0];
                // 重置level
                level = tmpLevel;
            }
            if (tmpLevel == 1) {
                break;
            }
        }
        NSLog(@"你的选择：%@", selectedModel.name);
        NSLog(@"层级关系：%@", str);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (!selectedModel.isExpand) {
#pragma mark - 展开级联
        selectedModel.isExpand = YES;
        //旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSString *craftId in self.viewModel.statesDictionary.allKeys) {
            if ([craftId isEqualToString:selectedModel.craft_id]) {
                NSArray *array = self.viewModel.statesDictionary[craftId];
                modelArray = array.mutableCopy;
                break;
            }
        }
        if (modelArray.count == 0) {
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
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (int i = 0; i < modelArray.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            [self.viewModel.craftsArray insertObject:modelArray[i] atIndex:indexPath.row + 1 + i];
        }
        //执行插入行
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else {
#pragma mark - 关闭级联
        selectedModel.isExpand = NO;
        //旋转动画
        [cell makeArrowImgViewRotation:0];
        
        NSMutableArray *indexPathArray = [NSMutableArray array];
        NSMutableArray *modelArray = [NSMutableArray array];
        NSInteger length = 0;
        NSInteger i = indexPath.row + 1;
        NSArray *array1 = [selectedModel.level_code componentsSeparatedByString:@"."];
        for (i = indexPath.row + 1; i < self.viewModel.craftsArray.count; i++) {
            MutiLevelCraftModel *endModel = self.viewModel.craftsArray[i];
            NSArray *array2 = [endModel.level_code componentsSeparatedByString:@"."];
            if (array1.count >= array2.count) {
                break;
            }
            // 添加tmpIndexPath
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            // 添加数据model
            [modelArray addObject:endModel];
        }
        length = i - indexPath.row - 1;
        if (length == 0) {
            return;
        }
        
        // 更新statesDictionary
        self.viewModel.statesDictionary[selectedModel.craft_id] = modelArray;
        // 删除数据
        [self.viewModel.craftsArray removeObjectsInRange:NSMakeRange(indexPath.row + 1, length)];
        //执行删除行
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
        while (i < j && [self getCondition1WithArray:marray key:key index:j]) {  // 从右边找到比key小的
            j--;
        }
        marray[i] = marray[j];
        
        while (i < j && [self getCondition2WithArray:marray key:key index:i]) {  // 从左边找到比key大的
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
