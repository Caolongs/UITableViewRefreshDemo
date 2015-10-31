//
//  UITableView+Ext.m
//  clj美食
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UITableView+CLJRefresh.h"
#import <objc/runtime.h>

#define ScreenSize [UIScreen mainScreen].bounds.size
#define RefreshHeight 60

static void *strRefresh = &strRefresh;
static void *strButton = &strButton;
static void *strloadView = &strloadView;
static void *strDelegate = &strDelegate;
static void *strhead = &strhead;
static void *strfoot = &strfoot;


@interface UITableView ()
@property (nonatomic,weak)UIView *refreshView;
@property (nonatomic,weak) UIButton *alertButtonView;
@property (nonatomic,weak) UIView *loadDataView;

@end

@implementation UITableView (CLJRefresh)

//BOOL footer
-(BOOL)footerRefresh
{
    return objc_getAssociatedObject(self, &strfoot);
}
- (void)setFooterRefresh:(BOOL)footerRefresh
{
    NSNumber *refbool = [NSNumber numberWithBool:footerRefresh];
    objc_setAssociatedObject(self, &strfoot, refbool, OBJC_ASSOCIATION_ASSIGN);
}
//BOOL header
- (BOOL)headerRefresh
{
    return objc_getAssociatedObject(self, &strhead);
}
- (void)setHeaderRefresh:(BOOL)headerRefresh
{
    NSNumber *refbool = [NSNumber numberWithBool:headerRefresh];
    objc_setAssociatedObject(self, &strhead, refbool, OBJC_ASSOCIATION_ASSIGN);
}


- (CLJRefreshViewStates)states
{
    return  (CLJRefreshViewStates)[(NSNumber *)objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setStates:(CLJRefreshViewStates)states
{
    NSNumber *sta = [NSNumber numberWithInt:states];
    objc_setAssociatedObject(self, @selector(states), sta, OBJC_ASSOCIATION_ASSIGN);
}

//刷新视图相关
- (UIView *)refreshView
{
    return objc_getAssociatedObject(self, &strRefresh);
}
- (UIView *)refresh
{
    UIView * refresh = [[UIView alloc] init];
    CGFloat x = 0;
    CGFloat y = -RefreshHeight;
    CGFloat w = ScreenSize.width;
    CGFloat h = RefreshHeight;
    refresh.frame = CGRectMake(x, y, w, h);
    refresh.backgroundColor = [UIColor yellowColor];
    return refresh;
}

-(void)setRefreshView:(UIView *)refreshView
{
    objc_setAssociatedObject(self, &strRefresh, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)addReFresh
{
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.states == CLJRefreshViewStatesLoading) {
        return;
    }
    //if (self.headerRefresh == YES) {
        
        if (self.isDragging) {
            CGFloat maxY = self.contentSize.height - self.frame.size.height;
            
            if (self.contentOffset.y < 0 && self.contentOffset.y > -RefreshHeight) {
                //判断添加刷新视图
                if (self.refreshView == nil) {
                    self.refreshView = [self refresh];
                    self.refreshView.center = CGPointMake(ScreenSize.width*0.5, -self.refreshView.frame.size.height*0.5);
                    [self addSubview:self.refreshView];
                }
                [self setRefreshStates:CLJRefreshViewStatesBeginDrag];
            }else if(self.contentOffset.y < -RefreshHeight){
                [self setRefreshStates:CLJRefreshViewStatesDragging];
                
            }else if (self.contentOffset.y > maxY && self.contentOffset.y < maxY+RefreshHeight){
                if (self.refreshView == nil) {
                    self.refreshView = [self refresh];
                    self.refreshView.center = CGPointMake(ScreenSize.width*0.5, self.contentSize.height+self.refreshView.frame.size.height*0.5);
                    [self addSubview:self.refreshView];

                }
                
                [self setRefreshStates:CLJRefreshViewStatesBeginDrag];
            }else if (self.contentOffset.y > maxY+RefreshHeight){
                [self setRefreshStates:CLJRefreshViewStatesDragging];
            }
 
        }else{
            if (self.states == CLJRefreshViewStatesDragging) {
                [self setRefreshStates:CLJRefreshViewStatesLoading];
                
                if (self.contentOffset.y<0) {
                    self.contentInset = UIEdgeInsetsMake(RefreshHeight, 0, 0, 0);
                    if (self.tableHeaderViewStates) {
                        self.tableHeaderViewStates(self,CLJRefreshViewStatesDragging);
                    }
                    
                }
                if (self.contentOffset.y > 0) {
                    self.contentInset = UIEdgeInsetsMake(0, 0, RefreshHeight, 0);
                    if (self.tableFooterViewStates) {
                        self.tableFooterViewStates(self,CLJRefreshViewStatesDragging);
                    }
                    
                }
                
            }
        }

}

- (void)stopAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        [self.refreshView removeFromSuperview];
        self.refreshView = nil;
        self.alertButtonView = nil;
        self.loadDataView = nil;
        self.states = CLJRefreshViewStatesBeginDrag;
    }];
    
}


- (void)setRefreshStates:(CLJRefreshViewStates)states
{
    
    switch (states) {
        case CLJRefreshViewStatesBeginDrag:
            if (self.alertButtonView == nil) {
                
                self.alertButtonView = [self alertButtonView1];
                [self.alertButtonView setTitle:@"拖拽" forState:UIControlStateNormal];
                self.states = states;
            }
            break;
        case CLJRefreshViewStatesDragging:
//            if (![self.alertButtonView.titleLabel.text isEqualToString:@"松开"]) {
//                self.states = states;
//                [self.alertButtonView setTitle:@"松开" forState:UIControlStateNormal];
//            }
            self.states = states;
            [self.alertButtonView setTitle:@"松开" forState:UIControlStateNormal];
            break;
        case CLJRefreshViewStatesLoading:
            if (self.loadDataView == nil) {
                [self.alertButtonView removeFromSuperview];
                self.loadDataView = [self loadDataView1];
                self.states = states;
            }
            break;
        default:
            break;
    }
}


//
- (UIButton *)alertButtonView
{
    return objc_getAssociatedObject(self, &strButton);
}
- (void)setAlertButtonView:(UIButton *)alertButtonView
{
    objc_setAssociatedObject(self, &strButton, alertButtonView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)alertButtonView1
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = self.refreshView.bounds;
    [self.refreshView addSubview:btn];
    //[btn setTitle:@"下拉" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    return btn;
}

//加载数据视图相关
- (UIView *)loadDataView
{
    return objc_getAssociatedObject(self, &strloadView);
}
- (void)setLoadDataView:(UIView *)loadDataView
{
    objc_setAssociatedObject(self, &strloadView, loadDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)loadDataView1
{
        UIView *view = [UIView new];
        view.frame = self.refreshView.bounds;
        [self.refreshView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.refreshView.bounds];
        label.text = @"正在加载数据";
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(80, 10, 40, 40);
        [view addSubview:activity];
        [activity startAnimating];
    
    return view;
}


- (void (^)(UITableView *, CLJRefreshViewStates))tableHeaderViewStates
{
    return (void (^)(UITableView *, CLJRefreshViewStates))objc_getAssociatedObject(self, @selector(tableHeaderViewStates));
}
- (void)setTableHeaderViewStates:(void (^)(UITableView *, CLJRefreshViewStates))tableHeaderViewStates
{
    objc_setAssociatedObject(self, @selector(tableHeaderViewStates),tableHeaderViewStates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(UITableView *, CLJRefreshViewStates))tableFooterViewStates
{
    return (void (^)(UITableView *, CLJRefreshViewStates))objc_getAssociatedObject(self, @selector(tableFooterViewStates));
}
- (void)setTableFooterViewStates:(void (^)(UITableView *, CLJRefreshViewStates))tableFooterViewStates
{
    objc_setAssociatedObject(self, @selector(tableFooterViewStates),tableFooterViewStates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
