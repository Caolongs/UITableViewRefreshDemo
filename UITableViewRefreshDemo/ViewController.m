//
//  ViewController.m
//  UITableViewRefreshDemo
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 Caolongjian. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+CLJRefresh.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    
    
    [self.tableView addReFresh];
    [self.tableView setTableHeaderViewStates:^(UITableView *tableView, CLJRefreshViewStates states) {
        NSLog(@"tableHeaderViewStates - 开始网络请求");
        [self performSelector:@selector(send) withObject:nil afterDelay:1.0];
    }];
    [self.tableView setTableFooterViewStates:^(UITableView *tableView, CLJRefreshViewStates states) {
        NSLog(@"Foot开始网络请求");
        [self performSelector:@selector(send) withObject:nil afterDelay:1.0];
    }];

}
- (void)send
{
    NSLog(@"--stopAnimation");
    [self.tableView stopAnimation];
}



- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = @"abcdefg";
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
