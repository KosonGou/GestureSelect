//
//  UIViewController+TopVC.h
//  JJSOA
//
//  Created by YD-zhangjiyu on 16/1/21.
//  Copyright © 2016年 JJSHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopVC)

+ (UIViewController*)topViewController;

+ (UIViewController *)getCurrentViewController;
@end
