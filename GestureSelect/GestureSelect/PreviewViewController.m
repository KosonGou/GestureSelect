//
//  PreviewViewController.m
//  GestureSelect
//
//  Created by KosonGou on 6/1/19.
//  Copyright © 2019 Leyoujia. All rights reserved.
//

#import "PreviewViewController.h"

#define TAG_TouchView 8765
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:TAG_TouchView];
    if (view) {
        [view setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:TAG_TouchView];
    if (view) {
        [view setHidden:NO];
    }
}

- (void)setupView {
    [self.navigationItem setTitle:@"第一步：选择内容"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 页面部分
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 20, 160)];
    [pageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.3]];
    [pageView.layer setCornerRadius:4];
    [pageView.layer setMasksToBounds:YES];
    [self.view addSubview:pageView];
    
    UILabel *pageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenWidth - 150, 20)];
    [pageTitleLabel setText:@"当前界面"];
    [pageTitleLabel setTextColor:[UIColor whiteColor]];
    [pageTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [pageView addSubview:pageTitleLabel];
    
    float scale = screenWidth / screenHeight;
    CGFloat height = 130;
    CGFloat width = scale * height;
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 20 - 15 - width, 15, width, height)];
    if (self.screenShotImage) {
        [pageImageView setImage:self.screenShotImage];
    }
    [pageView addSubview:pageImageView];
    
    // 控件部分
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(10, 180, screenWidth - 20, 160)];
    [controlView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.3]];
    [controlView.layer setCornerRadius:4];
    [controlView.layer setMasksToBounds:YES];
    [self.view addSubview:controlView];
    
    UILabel *controlTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenWidth - 150, 20)];
    [controlTitleLabel setText:@"当前控件"];
    [controlTitleLabel setTextColor:[UIColor whiteColor]];
    [controlTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [controlView addSubview:controlTitleLabel];
    
    if (self.evnetID && self.evnetID.length > 0) {
        UILabel *eventIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screenWidth - 150, 105)];
        [eventIDLabel setText:self.evnetID];
        [eventIDLabel setTextColor:[UIColor whiteColor]];
        [eventIDLabel setFont:[UIFont systemFontOfSize:14]];
        [eventIDLabel setNumberOfLines:0];
        [eventIDLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [controlView addSubview:eventIDLabel];
    }
    
    if (self.controlShotImage) {
        CGFloat cWidth = self.controlShotImage.size.width;
        CGFloat cHeight = self.controlShotImage.size.height;
        UIImageView *controlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 20 - 15 - cWidth, 15, cWidth, cHeight)];
        [controlImageView setImage:self.controlShotImage];
        [controlView addSubview:controlImageView];
    }
    
}

@end
