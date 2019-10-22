//
//  ViewController.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "ViewController.h"
#import "MutiLevelViewController.h"
#import "MutiLevelCraftViewController.h"
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    CGPoint point = self.view.center;
    point.y -= 50;
    button1.center = point;
    [self.view addSubview:button1];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"多层级CityTableView" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    point = self.view.center;
    point.y += 50;
    button2.center = point;
    [self.view addSubview:button2];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"多层级CraftTableView" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

#pragma mark - button点击事件
- (void)button1Action:(UIButton *)btn {
    MutiLevelViewController *viewController = [[MutiLevelViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)button2Action:(UIButton *)btn {
    MutiLevelCraftViewController *viewController = [[MutiLevelCraftViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
