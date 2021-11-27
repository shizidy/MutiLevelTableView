//
//  MutiLevelViewController.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "MutiLevelViewController.h"
#import "MutiLevelCell.h"
#import "MutiLevelViewModel.h"

@interface MutiLevelViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MutiLevelViewModel *viewModel;
@end

@implementation MutiLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.placesArray.count > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.placesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MutiLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MutiLevelCell class]) forIndexPath:indexPath];
    [cell fillCellWithViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MutiLevelModel *model = self.viewModel.placesArray[indexPath.row];
    MutiLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!model.children) {
        return;
    }
    if (!model.isExpand) {
        model.isExpand = YES;
        // 执行箭头旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        NSArray *array = @[];
        BOOL isMatched = NO;
        if (self.viewModel.statesArray.count > 0) {
            for (NSMutableDictionary *dict in self.viewModel.statesArray) {
                NSString *code = dict[@"code"];
                if ([code isEqualToString:model.code]) {
                    array = dict[@"array"];
                    isMatched = YES;
                    break;
                }
            }
            if (!isMatched) {
                array = model.children;
            }
        } else {
            array = model.children;
        }
        //计算level
        if (!isMatched || self.viewModel.statesArray.count == 0) {//说明是新增的array
            for (MutiLevelModel *levelModel in array) {
                levelModel.level = model.level + 1;
            }
        }
        
        NSMutableArray *marray = [NSMutableArray array];
        for (int i = 1; i <= array.count; i++) {
            NSIndexPath *index_path = [NSIndexPath indexPathForRow:indexPath.row + i inSection:0];
            [marray addObject:index_path];
            [self.viewModel.placesArray insertObject:array[i - 1] atIndex:indexPath.row + i];
        }
        //执行插入行
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else {
        model.isExpand = NO;
        //执行箭头旋转动画
        [cell makeArrowImgViewRotation:0];
        /*
         1.关闭前先把省/市/县展开时的数据保存起来
         2.怎么查找要保存的数据，思路：1.两个相同层级（level）之间的数据即为该层级的展开状态下的数据 2.该层级与首次找到比他大的层级之间的数据
         3.例如北京市与河北省之间，假如北京这一层级处于展开状态，在placesArray中寻找北京（level1=0）与河北省（level2=0）判断条件level1=level2，把这两者中间的数据保存起来，或者北京市市辖区（level1=1）与河北省（level2=0）之间的数据，判断条件level1>level2
         */
        NSMutableArray *marray = [NSMutableArray array];
        NSInteger length = 0;
        NSInteger i = indexPath.row + 1;
        for (i = indexPath.row + 1; i < self.viewModel.placesArray.count; i++) {
            MutiLevelModel *endModel = self.viewModel.placesArray[i];
            if (model.level >= endModel.level) {
                break;
            }
            NSIndexPath *index_path = [NSIndexPath indexPathForRow:i inSection:0];
            [marray addObject:index_path];
        }
        length = i - indexPath.row - 1;
        if (length <= 0) {
            return;
        }
        NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
        BOOL isMatched = NO;
        for (NSMutableDictionary *dict in self.viewModel.statesArray) {
            NSString *code = dict[@"code"];
            if ([code isEqualToString:model.code]) {
                dict[@"array"] = [self.viewModel.placesArray subarrayWithRange:NSMakeRange(indexPath.row + 1, length)];
                isMatched = YES;
                break;
            }
        }
        if (!isMatched) {
            modelDict[@"array"] = [self.viewModel.placesArray subarrayWithRange:NSMakeRange(indexPath.row + 1, length)];
            modelDict[@"code"] = model.code;
            [self.viewModel.statesArray addObject:modelDict];
        }
        [self.viewModel.placesArray removeObjectsInRange:NSMakeRange(indexPath.row + 1, length)];
        //执行删除行
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
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
