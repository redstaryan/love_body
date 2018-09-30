//
//  NewsDetailViewController.m
//  YSLife
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailModel.h"
#import "NewsModel.h"

@interface NewsDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"养生正文";
    
    //修改返回按钮和文字的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    //[self showInWebView];
    
    [self findNewsDetailByNewsId];
}

#pragma mark - NetWork Data
- (void)findNewsDetailByNewsId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@newsService/findNewsDetailByNewsId",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"newsId":@"DJ4OB3M50526I07F"};
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:dataDic withSuccessBlock:^(NSDictionary *object) {
        NSDictionary *dict = object[@"data"];
        NewsModel *newsModel = [NewsModel mj_objectWithKeyValues:dict];
        //NewsModel *newsModel = [NewsDetailModel detailWithDict:object[docid]];
        [weakSelf.webView loadHTMLString:[newsModel getHtmlString:newsModel] baseURL:nil];
    
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error");
    } progress:^(float progress) {
        NSLog(@"progress");
    }];
}

#pragma mark - ******************** webView + html
- (void)showInWebView
{
    NSString *docid = @"C0K3IC0U0514AJH1";
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",docid];
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
        NewsDetailModel *detailModel = [NewsDetailModel detailWithDict:object[docid]];
        [weakSelf.webView loadHTMLString:[detailModel getHtmlString:detailModel] baseURL:nil];
    } withFailureBlock:^(NSError *error) {
    } progress:^(float progress) {
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:"];
    if (range.location != NSNotFound) {
        //        NSInteger begin = range.location + range.length;
        //        NSString *src = [url substringFromIndex:begin];
        //        [self savePictureToAlbum:src];
        //[self showPictureWithAbsoluteUrl:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.size.height = self.webView.scrollView.contentSize.height;
    self.webView.frame = webViewFrame;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView;
    }
    return [UIView new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView.frame.size.height;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFLOAT_MIN;
}

#pragma mark - **************** lazy
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 700)];
        _webView.delegate = self;
    }
    return _webView;
}

@end
