//
//  LoginViewController.m
//  YSLife
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 redstar. All rights reserved.
//  登录页面

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()
@property (nonatomic, weak) UIImageView *headImgView;
@property (nonatomic, weak) RSTextField *telTextField;
@property (nonatomic, weak) RSTextField *pwTextField;
@property (nonatomic, weak) UIView *operationView;
@property (nonatomic, assign) BOOL codeLogin;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *verCodeBtn;
@property (nonatomic, weak) UIButton *switchBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeLogin = YES;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = self.view.bounds;
   // imgView.image = [UIImage imageNamed:@"WechatIMG82"];
    [self.view addSubview:imgView];
    
    [self initChildView];
}

#pragma mark-initChildView
- (void)initChildView
{
    //背景图片
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.image = [UIImage imageNamed:@""];
    backImgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backImgView];
    
    //头像
    CGFloat headImgViewWH = 80;
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.backgroundColor = [UIColor redColor];
    headImgView.layer.cornerRadius = headImgViewWH / 2;
    //headImgView.image = [UIImage imageNamed:@""];
    [self.view addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(headImgViewWH);
        make.height.mas_equalTo(headImgViewWH);
    }];
    self.headImgView = headImgView;
    
    
    [self initOperationView];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"loginClose"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-2);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
}

/**
 操作区域
 */
- (void)initOperationView
{
    UIView *operationView = [[UIView alloc] init];
    [self.view addSubview:operationView];
    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.headImgView.mas_bottom).offset (70);
        make.height.mas_equalTo(300);
    }];
    self.operationView = operationView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"手机号登录注册";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [operationView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationView).offset(25);
        make.right.equalTo(operationView).offset(-25);
        make.top.equalTo(operationView);
        make.height.mas_equalTo(20);
    }];
    self.titleLabel = titleLabel;
    
    //获取验证码
    CGFloat verCodeBtnH = 27;
    UIButton *verCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn addTarget:self action:@selector(verCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [verCodeBtn setTitleColor:[RSColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    verCodeBtn.layer.cornerRadius = verCodeBtnH / 2;
    verCodeBtn.layer.borderColor = [RSColor colorWithHexString:@"#cccccc"].CGColor;
    verCodeBtn.layer.borderWidth = 1;
    verCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [operationView addSubview:verCodeBtn];
    [verCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(operationView).offset(-25);
        make.top.equalTo(operationView).offset(76);
        make.width.mas_equalTo(89);
        make.height.mas_equalTo(verCodeBtnH);
    }];
    self.verCodeBtn = verCodeBtn;
    
    //手机号码
    CGFloat textFieldH = 44;

    RSTextField *telTextField = [[RSTextField alloc] init];
    telTextField.placeholder = @"手机号";
    telTextField.keyboardType = UIKeyboardTypeNumberPad;
    telTextField.clearButtonMode = UITextFieldViewModeAlways;
    [operationView addSubview:telTextField];
    [telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(48);
        make.left.equalTo(operationView).offset(23);
        make.right.equalTo(verCodeBtn.mas_left).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
    self.telTextField = telTextField;
    
    //分割线
    UILabel *telLine = [[UILabel alloc] init];
    telLine.backgroundColor = [RSColor colorWithHexString:@"#cccccc"];
    [operationView addSubview:telLine];
    [telLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telTextField.mas_bottom).offset(2);
        make.left.equalTo(operationView).offset(23);
        make.right.equalTo(operationView).offset(-23);
        make.height.mas_equalTo(1);
    }];
    
    //密码
    RSTextField *pwTextField = [[RSTextField alloc] init];
    pwTextField.placeholder = @"验证码";
    pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [operationView addSubview:pwTextField];
    [pwTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telLine.mas_bottom).offset(27);
        make.left.equalTo(operationView).offset(23);
        make.right.equalTo(operationView).offset(-23);
        make.height.mas_equalTo(textFieldH);
    }];
    self.pwTextField = pwTextField;
    
    //分割线
    UILabel *pwLine = [[UILabel alloc] init];
    pwLine.backgroundColor = [RSColor colorWithHexString:@"#cccccc"];
    [operationView addSubview:pwLine];
    [pwLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwTextField.mas_bottom).offset(2);
        make.left.equalTo(operationView).offset(23);
        make.right.equalTo(operationView).offset(-23);
        make.height.mas_equalTo(1);
    }];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    loginButton.layer.cornerRadius = 20;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [operationView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwLine.mas_bottom).offset(25);
        make.left.equalTo(operationView).offset(25);
        make.right.equalTo(operationView).offset(-25);
        make.height.mas_equalTo(40);
    }];
    
    //切换登录模式
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [switchBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [switchBtn setTitle:@"手机号密码登录" forState:UIControlStateNormal];
    [switchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [operationView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(6);
        make.centerX.equalTo(operationView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    self.switchBtn = switchBtn;
}

#pragma mark-点击事件
- (void)loginButtonClick
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    if (self.telTextField.isEmpty) {
        hud.label.text = @"请输入手机号";
        [hud hideAnimated:YES afterDelay:1];
    } else if(self.pwTextField.isEmpty){
        if (self.codeLogin == YES) {
            hud.label.text = @"请输入验证码";
        } else {
            hud.label.text = @"请输入密码";
        }
        [hud hideAnimated:YES afterDelay:1];
    } else {
        NSString *urlString = @"userService/login";
        NSDictionary *dataDic = @{@"telPhone":self.telTextField.text,
                                  @"password":@"",
                                  @"messageCode":self.pwTextField.text};
        
        if (self.codeLogin == NO) {
            dataDic = @{@"telPhone":self.telTextField.text,
                        @"password":self.pwTextField.text,
                        @"messageCode":@""};
        }
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"加载中...";
        
        __weak typeof(self) weakSelf = self;
        [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
            NSInteger success = [object[@"success"] integerValue];
            NSString *message = object[@"message"];
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:1];
            if (success == 1) {
                [HXShareTool sharedInstance].currentUser = [User mj_objectWithKeyValues:object[@"data"]];
                [HXShareTool sharedInstance].currentUser.loginState = LoginStateSuccess;
                [weakSelf closeBtnClick];
            }
        } withFailureBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1];
        } progress:^(float progress) {}];
    }
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

/**
 手机号验证码登录注册 和 手机号密码登录 切换
 */
- (void)switchBtnClick
{
    [self.view setNeedsUpdateConstraints];//告知需要更改约束
    [UIView animateWithDuration:0.5 animations:^{
        self.operationView.alpha = 0;
        [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImgView.mas_bottom).offset (100);
        }];
        [self.view layoutIfNeeded];//告知父类控件绘制，不添加注释的这两行的代码无法生效
    } completion:^(BOOL finished) {
        self.operationView.alpha = 1;
        [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImgView.mas_bottom).offset (70);
        }];
        
        if (self.codeLogin == YES) {
            self.codeLogin = NO;
            self.titleLabel.text = @"手机号密码登录";
            
            [self.verCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            
            self.pwTextField.placeholder = @"密码";
            
            [self.switchBtn setTitle:@"手机号登录注册" forState:UIControlStateNormal];
        } else {
            self.codeLogin = YES;
            self.titleLabel.text = @"手机号登录注册";
            
            [self.verCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(89);
            }];
            
            self.pwTextField.placeholder = @"验证码";
            
            [self.switchBtn setTitle:@"手机号密码登录" forState:UIControlStateNormal];
        }
    }];
}

/**
 获取验证码
 */
- (void)verCodeBtnClick
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.telTextField.isEmpty) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入手机号";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    NSString *urlString = @"userService/sendMessageCode";
    NSDictionary *dataDic = @{@"telPhone":self.telTextField.text};
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"发送中...";
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSString *message = object[@"message"];
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
        [hud hideAnimated:YES afterDelay:1];
    } withFailureBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1];
    } progress:^(float progress) {}];
}

- (void)registerButtonClick
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)forgetPwdButtonClick
{
    ForgetPwdViewController *forgetPwdViewController = [[ForgetPwdViewController alloc] init];
    forgetPwdViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetPwdViewController animated:YES];
}

@end
