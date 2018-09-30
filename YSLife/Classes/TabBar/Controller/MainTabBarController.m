//
//  MainTabBarController.m
//  YSLife
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "TodayViewController.h"
#import "NewsViewController.h"
#import "MeViewController.h"
#import "RootNavigationController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //dic[NSForegroundColorAttributeName] = [RSColor colorWithHexString:@"#999999"];
    
    //NSMutableDictionary *selectedDic = [NSMutableDictionary dictionary];
    //selectedDic[NSForegroundColorAttributeName] = [RSColor colorWithHexString:@"#440c85"];
    
    //UITabBarItem *item = [UITabBarItem appearance];
    //[item setTitleTextAttributes:dic forState:UIControlStateNormal];
    //[item setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    
    HomeViewController *homeViewController= [[HomeViewController alloc]init];
    homeViewController.navigationItem.title = @"首页";
    RootNavigationController *homeNav = [[RootNavigationController alloc]initWithRootViewController:homeViewController];
    //[homeNav.tabBarItem setImage:[UIImage imageNamed:@"navigation_icon_home"]];
    //[homeNav.tabBarItem setSelectedImage:[UIImage imageNamed:@"navigation_icon_home_pitchon"]];
    homeNav.tabBarItem.title = @"首页";
    
    TodayViewController *todayViewController = [[TodayViewController alloc]init];
    todayViewController.navigationItem.title = @"今天";
    RootNavigationController *todayNav = [[RootNavigationController alloc]initWithRootViewController:todayViewController];
    //[todayNav.tabBarItem setImage:[UIImage imageNamed:@"navigation_icon_notice"]];
    //[todayNav.tabBarItem setSelectedImage:[UIImage imageNamed:@"navigation_icon_notice_pitchon"]];
    todayNav.tabBarItem.title = @"今天";
    
    NewsViewController *newsViewController = [[NewsViewController alloc]init];
    newsViewController.navigationItem.title = @"养生新闻";
    RootNavigationController *contactsNav = [[RootNavigationController alloc]initWithRootViewController:newsViewController];
    //[contactsNav.tabBarItem setImage:[UIImage imageNamed:@"navigation_icon_address"]];
    //[contactsNav.tabBarItem setSelectedImage:[UIImage imageNamed:@"navigation_icon_address_pitchon"]];
    contactsNav.tabBarItem.title = @"资讯";
    
    MeViewController *meViewController = [[MeViewController alloc]init];
    meViewController.navigationItem.title = @"我";
    RootNavigationController *meNav = [[RootNavigationController alloc]initWithRootViewController:meViewController];
    [meNav.tabBarItem setImage:[UIImage imageNamed:@"navigation_icon_personage"]];
    [meNav.tabBarItem setSelectedImage:[UIImage imageNamed:@"navigation_icon_personage_pitchon"]];
    meNav.tabBarItem.title = @"我";
    
    NSArray *viewControllers = @[homeNav,todayNav,contactsNav,meNav];
    [self setViewControllers:viewControllers animated:NO];
}

@end
