//
//  NextViewController.m
//  GestureSelect
//
//  Created by KosonGou on 5/28/19.
//  Copyright © 2019 Leyoujia. All rights reserved.
//

#import "NextViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface NextViewController () {
    UIImageView *imageV;
}

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageV = [[UIImageView alloc]init];
    imageV.frame = CGRectMake(50, 100, 50, 50);
    imageV.image = [UIImage imageNamed:@"icon_map_dingwei"];
    [self.view addSubview:imageV];
}

- (void)setupView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 100) / 2, 90, 100, 30)];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    [label setText:@"Test label A"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 100) / 2, 140, 100, 30)];
    [label1 setBackgroundColor:[UIColor lightGrayColor]];
    [label1 setText:@"Test label B"];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:label1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setFrame:CGRectMake((screenWidth - 80) / 2, 190, 80, 40)];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark--touch开始的时候
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

#pragma mark--touch移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self.view];
    //取得前一个位置
    CGPoint previous=[touch previousLocationInView:self.view];
    
    //移动前的中点位置
    CGPoint center=imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
    
    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    //重新设置新位置
    imageV.center=CGPointMake(center.x+offset.x, center.y+offset.y);
    
    UIView *v = touches.anyObject.view;
    NSString *n = NSStringFromClass([v class]);
    NSLog(@"触摸到的：%@", n);
}


#pragma mark--touch移动结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self.view];
    //取得前一个位置
    
    //移动前的中点位置
    //    CGPoint center=imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x, current.y);
    
    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    //重新设置新位置
    imageV.center=CGPointMake(offset.x,offset.y);
}

@end
