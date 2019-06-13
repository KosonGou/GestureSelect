//
//  ViewController.m
//  GestureSelect
//
//  Created by KosonGou on 5/25/19.
//  Copyright © 2019 Leyoujia. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "UIViewController+TopVC.h"
#import "UIImage+JJSAspect.h"
#import "NSArray+Category.h"
#import "PreviewViewController.h"

#define TAG_TouchView 8765
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
//如果要定义Controller title 为空的描述，在PCH文件中 #define JJSAspect_Title_NULL @"Your Title"
#ifndef JJSAspect_Controller_Title_NULL
#define JJSAspect_Controller_Title_NULL @"[未设置界面标题]"
#endif

@interface ViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    UIImageView *previewImageView;
    UIView *touchView;
    UIView *coverView;
    UIView *currentView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 遮罩视图
    coverView = [[UIView alloc] initWithFrame:CGRectZero];
    [coverView setBackgroundColor:[UIColor redColor]];
    [coverView setAlpha:0.6];
    [coverView.layer setBorderWidth:1];
    [coverView.layer setBorderColor:[UIColor blueColor].CGColor];
    [self setupView];
    [self loadPanView];
}

- (void)setupView {
    [self.navigationItem setTitle:@"圈选Demo"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setRightBarButtonItem:rightItem animated:YES];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 60, 30)];
    [tempLabel setBackgroundColor:[UIColor grayColor]];
    [tempLabel setText:@"Label"];
    [self.navigationController.navigationBar addSubview:tempLabel];
    
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
    [button addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 100) / 2, 250, 100, 100)];
    [imageView setImage:[UIImage imageNamed:@"home_hot_bg"]];
    [self.view addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 360, screenWidth, 200) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 580, screenWidth - 60, 300)];
    [self.view addSubview:previewImageView];
}

- (void)loadPanView {
    touchView = [[UIView alloc] init];
    touchView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    touchView.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height / 2 - [UIScreen mainScreen].bounds.size.height / 4, 60, 60);
    touchView.layer.cornerRadius = 30;
    touchView.layer.masksToBounds = YES;
    touchView.tag = TAG_TouchView;
    [[UIApplication sharedApplication].keyWindow addSubview:touchView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction1:)];
    pan.minimumNumberOfTouches = 1;
    pan.delegate = self;
    [touchView addGestureRecognizer:pan];
}

- (void)panAction1:(UIPanGestureRecognizer *)ges {
    //    CGPoint p = [(UILongPressGestureRecognizer *)ges locationInView:touchView];
    //    NSLog(@"press at %f, %f", p.x, p.y);

    UIView *gesView = [ges view];
    
    CGPoint point = [ges translationInView:gesView];
//    NSLog(@"point at %f, %f", point.x, point.y);

    gesView.transform = CGAffineTransformTranslate(gesView.transform, point.x, point.y);
    [ges setTranslation:CGPointZero inView:gesView];
    
//    CGPoint viewPoint = [ges locationInView:self.view];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
   CGRect panRect = [gesView convertRect:gesView.bounds toView:window];
//    NSLog(@"rect to window %@", NSStringFromCGRect(panRect));
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(panRect), CGRectGetMidY(panRect));
    [self showCover:centerPoint];
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:
            [self showEditContentView];
            [self gotoNextStep];
            break;
        case UIGestureRecognizerStateCancelled:
            [self showEditContentView];
            break;
        case UIGestureRecognizerStateFailed:
            [self showEditContentView];
            break;
        default:
            break;
    }
    
}

- (void)showCover:(CGPoint)point {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    // 在当前控制器的View上查找圈选控件
    NSArray *subviews = [self.view subviews];
    BOOL touched = NO;
    for (int i = 0; i < subviews.count; i++) {
        UIView *v = subviews[i];
        CGRect rect = [v convertRect:v.bounds toView:window];
        BOOL contain = CGRectContainsPoint(rect, point);
        if (contain && v != touchView) {
            
            if ([v isKindOfClass:[UITableView class]]) {
                // UITableView的视图处理
                UITableView *tableView = (UITableView *)v;
                NSArray *visibleCells = [tableView visibleCells];
                for (int i = 0; i < visibleCells.count; i++) {
                    UITableViewCell *cell = visibleCells[i];
                    if (cell) {
                       NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                        if (indexPath) {
                            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
                            CGRect rectInWindow = [tableView convertRect:rectInTableView toView:window];
                            
                            BOOL cellContain = CGRectContainsPoint(rectInWindow, point);
                            if (cellContain) {
                                [coverView setFrame:rectInWindow];
                                [window addSubview:coverView];
                                currentView = cell;
                                touched = YES;
                                break;
                            }
                        }
                    }
                }
            } else {
                [coverView setFrame:rect];
                [window addSubview:coverView];
                currentView = v;
                touched = YES;
            }
            
        }
    }
    
    // 当前控制器的View上没有查找到圈选控件后，在导航控制器View上查找
    if (!touched) {
        [self showEditContentView];
        if (self.navigationController != nil) {
            UIView *navView = self.navigationController.view;
            if (navView) {
                NSArray *navSubViews = [navView subviews];
                for (int i = 0; i < navSubViews.count; i++) {
                    UIView *v = navSubViews[i];
                    CGRect rect = [v convertRect:v.bounds toView:window];
                    BOOL isNavBar = [v isKindOfClass:[UINavigationBar class]];
                    BOOL contain = CGRectContainsPoint(rect, point);
                    if (isNavBar && contain && v != touchView) {
                        
                        NSArray *barSubviews = [v subviews];
                        if (barSubviews && barSubviews.count > 0) {
                            for (int ni = 0; ni < barSubviews.count; ni++) {
                                UIView *barSubV = barSubviews[ni];
                                CGRect barSubVRect = [barSubV convertRect:barSubV.bounds toView:window];
                                BOOL barSubContain = CGRectContainsPoint(barSubVRect, point);
                                if (barSubContain) {
                                    [coverView setFrame:barSubVRect];
                                    [window addSubview:coverView];
                                    currentView = barSubV;
                                    touched = YES;
                                    break;
                                }
                            }
                        } else {
                            [coverView setFrame:rect];
                            [window addSubview:coverView];
                            currentView = v;
                            touched = YES;
                        }
                    } else {
                        currentView = nil;
                    }
                }
            }
        }
    }
    
}

- (void)gotoNextStep {
    if (currentView) {
        UIView *v = currentView;
        CGRect vFrame = v.frame;
        NSString *eId = [self generalEventID:v];
        NSLog(@"事件Id:%@", eId);
        UIImage *image = [self screenShot:v];
        if (image) {
            [previewImageView setImage:image];
            [previewImageView setFrame:CGRectMake(previewImageView.frame.origin.x, previewImageView.frame.origin.y, vFrame.size.width, vFrame.size.height)];
            // 跳转到下一步
            PreviewViewController *previewVC = [[PreviewViewController alloc] init];
            [previewVC setEvnetID:eId];
            [previewVC setControlShotImage:image];
            [previewVC setScreenShotImage:[self screenShot:[UIApplication sharedApplication].keyWindow]];
            [self.navigationController pushViewController:previewVC animated:YES];
        }
    }
}

- (void)showEditContentView {
    UIView *superView = [coverView superview];
    if (superView) {
        [coverView removeFromSuperview];
    }
}

- (NSString *)generalEventID:(UIView *)instance {
    UIViewController *currentCtl = [UIViewController getCurrentViewController];
    NSString *currentCtlTitle = currentCtl.title;
    if (currentCtlTitle == nil) {
        currentCtlTitle = currentCtl.navigationItem.title;
    }
    if (!currentCtlTitle) {
        currentCtlTitle = JJSAspect_Controller_Title_NULL;
    }
    NSString *currentControllerClass = @"";
    if (currentCtl != nil) {
        currentControllerClass = NSStringFromClass([currentCtl class]);
    }
    
    if (instance == nil) {
        return @"";
    }
    if (instance.superview == nil) {
        return @"";
    }
    
    NSString *instanceInfo = nil;
    
    NSString *superViewClassStr = NSStringFromClass([instance.superview class]);
    NSString *controlTitle = nil;
    //按钮
    if ([instance isKindOfClass:[UIButton class]]) {
        controlTitle = [(UIButton *)instance titleLabel].text;
        NSString *imageNameString = [(UIButton *)instance currentImage].imageName;
        if (!imageNameString) {
            imageNameString = [(UIButton *)instance currentBackgroundImage ].imageName;
        }
        NSString *superViewIndexStr = @"";
        if (!imageNameString && !controlTitle) { //当按钮即没有设置图片也没有设置标题时，增加按钮在父视图的index属性
            NSArray *grandSubviewsArray = instance.superview.superview.subviews;//上上层的子类
            NSArray *fatherSubviewsArray = instance.superview.subviews;//上一层的子类
            //遍历两级是为了提高唯一性，例如个人中心发布委托，如果只遍历一层仍无法保证唯一性。
            for (int i = 0; i < grandSubviewsArray.count; i++) {
                if ([[grandSubviewsArray objectAtSafeIndex:i] isEqual:instance.superview]) {
                    for (int j = 0; j < fatherSubviewsArray.count; j++) {
                        if ([[fatherSubviewsArray objectAtSafeIndex:j] isEqual:instance]) {
                            superViewIndexStr = [NSString stringWithFormat:@"%@(%d)%@(%d)",NSStringFromClass([instance.superview.superview class]),i,NSStringFromClass([instance.superview class]),j];
                            break;
                        }
                    }
                    break;
                }
            }
        } else if (!controlTitle) {
            superViewIndexStr = NSStringFromClass([instance class]);
        }
        if ([NSStringFromClass([instance class]) isEqualToString:@"MenuIconButton"]) {
            instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%d",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class]),imageNameString?:@"",instance.tag];
        } else {
            instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class]),imageNameString?:@""];
        }
        
    } else if ([instance isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segment = (UISegmentedControl *)instance;
        controlTitle = [segment titleForSegmentAtIndex:[segment selectedSegmentIndex]];
        NSString *selectedIndexString = [NSString stringWithFormat:@"SegmentIndex(%ld)",(long)[segment selectedSegmentIndex]];
        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class]),selectedIndexString];
        
    } else if ([instance isKindOfClass:[UISwitch class]]) {
        UISwitch *switchControl = (UISwitch *)instance;
        if ([switchControl isOn]) {
            controlTitle = @"state:开";
        } else {
            controlTitle = @"state:关";
        }
        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class])];
    } else if ([instance isKindOfClass:[UITextField class]]) {
        controlTitle = [(UITextField *)instance placeholder];
        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class])];
    } else if ([instance isKindOfClass:[UILabel class]]) {
        controlTitle = [(UILabel *)instance text];
        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class])];
    }
//    else if ([instance isKindOfClass:[YHSelectAction class]]) {
//        controlTitle = [(YHSelectAction *)instance title];
//        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@",superViewClassStr,NSStringFromClass(self),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class])];
//    }
    else { //UIDatePicker  UIPageControl  UISlider等
        instanceInfo = [NSString stringWithFormat:@"%@-%@-%@-%@",superViewClassStr,NSStringFromClass([self class]),NSStringFromClass([instance class]),controlTitle?:NSStringFromClass([instance class])];
    }
    /*
     事件id生成规则：当前所处某个页面+页面标题 + button属性
     button属性：SuperViewClassType+控件类型+控件标题+图片+背景图片
     */
    NSString *eventID = [NSString stringWithFormat:@"%@-%@-%@",currentControllerClass,currentCtlTitle,instanceInfo];
    return eventID;
}

- (void)nextPage:(id)sender {
    NextViewController *nextViewController = [[NextViewController alloc] init];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - Screen shot
- (UIImage *)screenShot:(UIView *)view {
    // 获取图形上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)snapshotScreenWithGL:(UIView *)view {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UITableView delegate & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"测试圈选功能%ld", indexPath.row]];
    [cell.detailTextLabel setText:@"用手指按压进行圈选"];
    return cell;
}

@end
