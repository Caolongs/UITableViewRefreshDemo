//
//  UITableView+Ext.h
//  clj美食
//
//  Created by caolongjian on 15/9/26.
//  Copyright (c) 2015年 caolongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CLJRefreshViewStates{
    CLJRefreshViewStatesBeginDrag,
    CLJRefreshViewStatesDragging,
    CLJRefreshViewStatesLoading
};
typedef enum CLJRefreshViewStates CLJRefreshViewStates;



@interface UITableView (CLJRefresh)

@property (nonatomic, assign)CLJRefreshViewStates states;
@property (nonatomic,assign )BOOL headerRefresh;
@property (nonatomic,assign )BOOL footerRefresh;


//block
@property (nonatomic,copy)void(^tableHeaderViewStates)(UITableView *tableView, CLJRefreshViewStates states);
@property (nonatomic,copy)void(^tableFooterViewStates)(UITableView *tableView, CLJRefreshViewStates states);
- (void)addReFresh;
- (void)stopAnimation;



- (void)setTableHeaderViewStates:(void (^)(UITableView *tableView, CLJRefreshViewStates states))tableHeaderViewStates;
- (void)setTableFooterViewStates:(void (^)(UITableView *tableView, CLJRefreshViewStates states))tableFooterViewStates;
@end
