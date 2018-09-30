//
//  MeViewController.m
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIImageView *headImgView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *telLabel;
@end

@implementation MeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeCellIdentifier"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark- 点击事件
- (void)loginButtonClick
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:^{}];
}

/**
 * 更新个人信息页面
 */
- (void)updateHeaderView
{
    User *user = [HXShareTool sharedInstance].currentUser;
    if (user.loginState == LoginStateSuccess && user) {
        self.loginButton.hidden = YES;
        
        self.headImgView.hidden = NO;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:nil];
        
        self.nameLabel.hidden = NO;
        if (user.nickName.length == 0) {
            self.nameLabel.text = @"未设置昵称";
        } else {
            self.nameLabel.text = user.nickName;
        }
        self.telLabel.hidden = NO;
        self.telLabel.text = user.telPhone;
    } else {
        self.loginButton.hidden = NO;
        
        self.headImgView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.telLabel.hidden = YES;
    }
}

#pragma mark- 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateHeaderView];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //恢复导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark- 懒加载
- (void)tableHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, KScreenWidth, 80);
    headerView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableHeaderView:headerView];
    
    //1.没有登录的状态
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.layer.cornerRadius = 22;
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor redColor];
    [headerView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
    self.loginButton  = loginButton;
    
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.layer.cornerRadius = 6;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.borderWidth = 2;
    headImgView.layer.borderColor = [UIColor blackColor].CGColor;
    [headerView addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(KLRMarginValue);
        make.top.equalTo(headerView);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(66);
    }];
    self.headImgView = headImgView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgView.mas_right).offset(KLRMarginValue);
        make.top.equalTo(headerView).offset(13);
        make.right.equalTo(headerView).offset(-50);
        make.height.mas_equalTo(17);
    }];
    self.nameLabel = nameLabel;
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.right.equalTo(nameLabel);
        make.height.mas_equalTo(14);
    }];
    self.telLabel = telLabel;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat tableViewH = KScreenHeight - KHeight_topNav- self.tabBarController.tabBar.frame.size.height;
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, KHeight_topNav,KScreenWidth,tableViewH) style:UITableViewStyleGrouped];
        _tableView.sectionHeaderHeight = 10;
        _tableView.sectionFooterHeight = 10;
        _tableView.tableHeaderView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        }

        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        
        [self tableHeaderView];
    }
    return _tableView;
}

@end
