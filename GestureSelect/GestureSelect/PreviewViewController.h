//
//  PreviewViewController.h
//  GestureSelect
//
//  Created by KosonGou on 6/1/19.
//  Copyright © 2019 Leyoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController

@property (nonatomic, strong) UIImage *screenShotImage;
@property (nonatomic, strong) UIImage *controlShotImage;
@property (nonatomic, strong) NSString *evnetID;
@property (nonatomic, strong) NSString *controlTitle;

@end

NS_ASSUME_NONNULL_END
