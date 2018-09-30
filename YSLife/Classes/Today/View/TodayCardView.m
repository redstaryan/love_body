//
//  TodayCardView.m
//  YSLife
//
//  Created by admin on 2018/5/15.
//  Copyright © 2018年 redstar. All rights reserved.
//

#import "TodayCardView.h"

@interface TodayCardView()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) PlaceholderTextView *textView;
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@end

@implementation TodayCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lastSelectPhotos = [[NSMutableArray alloc] init];
        
        self.lastSelectAssets = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 10;
        
        UILabel *titleLabel = [[UILabel alloc]  init];
        //titleLabel.text = @"早餐";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [RSColor colorWithHexString:@"#666666"];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KLRMarginValue);
            make.right.equalTo(self).offset(-KLRMarginValue);
            make.top.equalTo(self).offset(KLRMarginValue);
            make.height.mas_equalTo(15);
        }];
        self.titleLabel = titleLabel;
        
        PlaceholderTextView *textView = [[PlaceholderTextView alloc]init];
        textView.placeholderLabel.font = [UIFont systemFontOfSize:13];
        textView.backgroundColor = [RSColor colorWithHexString:@"#f7f7f7"];
        //textView.placeholder = @"早餐自己做的？？？";
        textView.font = [UIFont systemFontOfSize:15];
        textView.maxLength = 30;
        textView.layer.cornerRadius = 5.f;
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KLRMarginValue);
            make.right.equalTo(self).offset(-KLRMarginValue);
            make.top.equalTo(titleLabel.mas_bottom).offset(KLRMarginValue);
            make.height.mas_equalTo(60);
        }];
        self.textView = textView;
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton addTarget:self action:@selector(clickCameraButton) forControlEvents:UIControlEventTouchUpInside];
        addButton.backgroundColor = [UIColor redColor];
        [self addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KLRMarginValue);
            make.top.equalTo(textView.mas_bottom).offset(KLRMarginValue);
            //make.top.equalTo(titleLabel.mas_bottom).offset(KLRMarginValue);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
        
        UIButton *ignoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ignoreButton setTitle:@"不吃" forState:UIControlStateNormal];
        ignoreButton.backgroundColor = [UIColor redColor];
        [self addSubview:ignoreButton];
        [ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KLRMarginValue);
            make.top.equalTo(addButton.mas_bottom).offset(KLRMarginValue);
            //make.top.equalTo(titleLabel.mas_bottom).offset(KLRMarginValue);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.backgroundColor = [UIColor redColor];
        [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:@"开动" forState:UIControlStateNormal];
        [self addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-KLRMarginValue);
            make.top.equalTo(addButton.mas_bottom).offset(KLRMarginValue);
            //make.top.equalTo(titleLabel.mas_bottom).offset(KLRMarginValue);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setTodayType:(TodayType)todayType
{
    if (todayType == TodayTypeBreakFast) {
        self.titleLabel.text = @"早餐";
    } else if (todayType == TodayTypLunch) {
        self.titleLabel.text = @"午餐";
    } else if (todayType == TodayTypeDinner) {
        self.titleLabel.text = @"晚餐";
    } else if (todayType == TodayTypeSleep) {
        self.titleLabel.text = @"睡觉";
    }
}

- (void)buttonClick:(UIButton *)sender
{
    //TodayModel *todayModel = self.dataArray[indexPath.row];
    
    [self removeFromSuperview];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@userTodayService/addUserToday",KYSBaseURL];
    
    NSDictionary *dataDic = @{@"userid":@"7",
                              @"content":@"我早上吃的一个鸡蛋一碗粥",
                              @"type":@"1"};

    [NetWorkManager uploadImageWithOperations:dataDic withImageArray:self.lastSelectPhotos withtargetWidth:0 withUrlString:urlStr withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
    } withFailurBlock:^(NSError *error) {
        NSLog(@"error");
    } withUpLoadProgress:^(float progress) {
        NSLog(@"progress");
    }];
}

-(void)clickCameraButton
{
    [self endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    self.actionSheet.arrSelectedAssets = self.lastSelectAssets;
    [self.actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf.lastSelectAssets removeAllObjects];
        [weakSelf.lastSelectAssets addObjectsFromArray:assets];
        
        [weakSelf.lastSelectPhotos removeAllObjects];
        [weakSelf.lastSelectPhotos addObjectsFromArray:images];
        
        
        
    }];
    
    //调用相册
    [self.actionSheet showPhotoLibrary];
}

- (ZLPhotoActionSheet *)actionSheet
{
    if (_actionSheet == nil) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
        _actionSheet.configuration.maxSelectCount = 5;
        _actionSheet.configuration.allowSelectGif = NO;
        _actionSheet.configuration.allowSelectVideo = NO;
        _actionSheet.configuration.allowEditImage = NO;
        _actionSheet.configuration.useSystemCamera = YES;
        _actionSheet.configuration.allowTakePhotoInLibrary = YES;
        _actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
        _actionSheet.configuration.showSelectedMask = YES;
        _actionSheet.configuration.allowRecordVideo = NO;
        _actionSheet.configuration.allowSelectOriginal = NO;
        _actionSheet.configuration.maxPreviewCount = 0;
        _actionSheet.configuration.allowMixSelect = NO;
        _actionSheet.sender = self.fatherViewController;//如调用的方法无sender参数，则该参数必传
    }
    return _actionSheet;
}



@end
