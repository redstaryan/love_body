//
//  RegisterViewController.m
//  YSLife
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, weak) RSTextField *telTF;
@property (nonatomic, weak) RSTextField *codeTF;
@property (nonatomic, weak) RSTextField *pwdTF;
@property (nonatomic, weak) RSTextField *rePwdTF;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initChildView];
}

#pragma mark-initChildView
- (void)initChildView
{
    /*
     1.填写手机号码
     2.发送验证码按钮
     3.填写验证码
     4.填写密码
     5.再次填写密码*/
    
    CGFloat textFieldH = 30;
    
    //手机号码
    RSTextField *telTF = [[RSTextField alloc] init];
    telTF.text = @"13621936345";
    telTF.placeholder = @"请输入手机号码";
    telTF.clearButtonMode = UITextFieldViewModeAlways;
    telTF.backgroundColor = [UIColor greenColor];
    [self.view addSubview:telTF];
    [telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.left.equalTo(self.view).offset(KLRMarginValue);
        make.right.equalTo(self.view).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
    self.telTF = telTF;
    
    //发送验证码按钮
    UIButton *sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeButton.backgroundColor = [UIColor blueColor];
    [sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.view addSubview:sendCodeButton];
    [sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telTF.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-textFieldH);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(textFieldH);
    }];
    
    //验证码
    RSTextField *codeTF = [[RSTextField alloc] init];
    codeTF.text = @"13621936345";
    codeTF.placeholder = @"请输入验证码";
    codeTF.clearButtonMode = UITextFieldViewModeAlways;
    codeTF.backgroundColor = [UIColor greenColor];
    [self.view addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sendCodeButton);
        make.left.equalTo(telTF);
        make.right.equalTo(sendCodeButton.mas_left).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
    self.codeTF = codeTF;
    
    //密码
    RSTextField *pwdTF = [[RSTextField alloc] init];
    pwdTF.text = @"13621936345";
    pwdTF.placeholder = @"请输入密码";
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeAlways;
    pwdTF.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTF.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(KLRMarginValue);
        make.right.equalTo(self.view).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
    self.pwdTF = pwdTF;
    
    //确认密码
    RSTextField *rePwdTF = [[RSTextField alloc] init];
    rePwdTF.text = @"13621936345";
    rePwdTF.placeholder = @"再一次输入密码";
    rePwdTF.secureTextEntry = YES;
    rePwdTF.clearButtonMode = UITextFieldViewModeAlways;
    rePwdTF.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rePwdTF];
    [rePwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTF.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(KLRMarginValue);
        make.right.equalTo(self.view).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
    self.rePwdTF = rePwdTF;
    
    //登录按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rePwdTF.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(KLRMarginValue);
        make.right.equalTo(self.view).offset(-KLRMarginValue);
        make.height.mas_equalTo(textFieldH);
    }];
}

#pragma mark-click
- (void)sendCodeButtonClick
{
    
}

- (void)registerButtonClick
{
    //手机号码不能为空
    //验证码不能为空
    //密码不能空
    //确认密码不能为空
    //新密码和再次确认密码要 一致
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    if (self.telTF.isEmpty) {
        hud.label.text = @"手机号码不能为空";
        [hud hideAnimated:YES afterDelay:1];
    } else if(self.codeTF.isEmpty){
        hud.label.text = @"验证码不能为空";
        [hud hideAnimated:YES afterDelay:1];
    } else if(self.pwdTF.isEmpty) {
        hud.label.text = @"密码不能空";
        [hud hideAnimated:YES afterDelay:1];
    } else if(self.pwdTF.isEmpty) {
        hud.label.text = @"密码不能空";
        [hud hideAnimated:YES afterDelay:1];
    } else if(self.pwdTF.isEmpty) {
        hud.label.text = @"密码不能空";
        [hud hideAnimated:YES afterDelay:1];
    } else if(![self.pwdTF.text isEqualToString:self.rePwdTF.text]) {
        hud.label.text = @"两次密码不一致";
        [hud hideAnimated:YES afterDelay:1];
    } else {
        NSString *urlString = @"userService/register";
        NSDictionary *dataDic = @{@"telphone":self.telTF.text,
                                  @"verCode":self.codeTF.text,
                                  @"password":self.pwdTF.text};
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"加载中...";
        [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlString withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
            NSInteger success = [object[@"success"] integerValue];
            NSString *message = object[@"message"];
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:1];
            if (success == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"aaaaa");
            [hud hideAnimated:YES afterDelay:1];
        } progress:^(float progress) {
            NSLog(@"aaaaa");
            [hud hideAnimated:YES afterDelay:1];
        }];
    }
}
@end
