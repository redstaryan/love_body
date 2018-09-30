//
//  NewsViewController.m
//  YSLife
//
//  Created by admin on 2018/5/24.
//  Copyright © 2018年 redstar. All rights reserved.
//
#define IdentifierValue @"NewsTableViewCellIdentifier"

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"
#import "NewsModel.h"

@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    CGRect tableViewFrame = self.view.bounds;
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self findAllNews];
}

#pragma mark - NetWork Data
- (void)findAllNews
{
    NSString *urlStr = [NSString stringWithFormat:@"%@newsService/findAllNews",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"userid":@"7"};
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSArray *dataArray = object[@"data"];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dict = dataArray[i];
            NewsModel *newsModel = [NewsModel mj_objectWithKeyValues:dict];
            [mutableArray addObject:newsModel];
        }
        
        [weakSelf.dataArray addObjectsFromArray:mutableArray];
        
        [weakSelf.tableView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
        NSLog(@"progress");
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierValue];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierValue];
    }
    
    cell.newsModel = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailViewController *newsDetailViewController = [[NewsDetailViewController alloc] init];
    newsDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
