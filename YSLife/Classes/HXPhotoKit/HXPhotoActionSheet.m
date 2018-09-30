//
//  HXPhotoActionSheet.m
//  YSLife
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 redstar. All rights reserved.
//
#define KCELLHEIGHT 55

#import "HXPhotoActionSheet.h"
#import "HXPhotoAlbumController.h"
#import "HXPhotoKitController.h"

@interface HXPhotoActionSheet()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HXPhotoActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.fatherController = [self getCurrentVC];
        
        //拍摄 从手机相册选择 取消
        CGFloat tableViewH = KCELLHEIGHT * 3 + 5;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, tableViewH) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = NO;
        tableView.tableFooterView = [UIView new];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [self addSubview:tableView];
        self.tableView  = tableView;
        
        [self showTableView];
        
        UIApplication *appWindow = [UIApplication sharedApplication];
        [appWindow.keyWindow addSubview:self];
    }
    return self;
}

/**
 显示列表动画
 */
- (void)showTableView
{
    CGFloat tableViewH = KCELLHEIGHT * 3 + 5;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, self.frame.size.height - tableViewH, self.frame.size.width, tableViewH);
    }];
}

/**
 列表消失
 */
- (void)removeTableView
{
    CGFloat tableViewH = KCELLHEIGHT * 3 + 5;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, tableViewH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HXPhotoActionSheetCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"拍摄";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"从手机相册选择";
        }
    } else if(indexPath.section == 1){
        cell.textLabel.text = @"取消";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
      
        if (indexPath.row == 1) {
            [self removeTableView];
            
            HXPhotoAlbumController *albumController = [[HXPhotoAlbumController alloc] init];
            UINavigationController *albumNav = [[UINavigationController alloc] initWithRootViewController:albumController];
            
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            albumController.navigationItem.backBarButtonItem = item;
            
            HXPhotoKitController *photoKitController = [[HXPhotoKitController alloc] init];
            photoKitController.navigationItem.title = @"相机胶卷";
            [albumNav pushViewController:photoKitController animated:YES];
            
            [self.fatherController showViewController:albumNav sender:nil];
        }
    } else if (indexPath.section == 1) {
        [self removeTableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCELLHEIGHT;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
