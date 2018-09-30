//
//  BaseViewController.m
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "BaseViewController.h"
#import "GlobalDefines.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [RSColor colorWithHexString:@"#f7f6fb"];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
