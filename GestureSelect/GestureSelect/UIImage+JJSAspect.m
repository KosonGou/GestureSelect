//
//  UIImage+JJSAspect.m
//  Pods
//
//  Created by jjs-imac-qhy on 15/4/2016.
//
//

#import "UIImage+JJSAspect.h"
#import <objc/runtime.h>

NSMutableDictionary *imgNameDic = nil;
@implementation UIImage (JJSAspect)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Exchange imageNamed: implementation
        Method imageNameOriginalMethod = class_getClassMethod([self class], @selector(imageNamed:));
        Method imageNameSwizzledMethod = class_getClassMethod([self class], @selector(vi_imageNamed:));
        method_exchangeImplementations(imageNameOriginalMethod, imageNameSwizzledMethod);
        //Exchange imageWithContentsOfFile: implementation
        Method imageWithContentsOfFileOriginalMethod = class_getClassMethod([self class], @selector(imageWithContentsOfFile:));
        Method imageWithContentsOfFileSwizzledMethod = class_getClassMethod([self class], @selector(vi_imageWithContentsOfFile:));
        method_exchangeImplementations(imageWithContentsOfFileOriginalMethod, imageWithContentsOfFileSwizzledMethod);
    });            //上面的两个方法可以获取到使用代码设置的图片，但是无法取出通过xib方式设置的。下面的initWithCoder可以获取到，但是由于是私有方法，也暂时不考虑了，防止审核被拒
    //Exchange initWithCoder: implementation in order to get the resource file
//    Method initWithCoderOriginalMethod = class_getInstanceMethod(NSClassFromString(@"UIImageNibPlaceholder"), @selector(initWithCoder:));
//    Method initWithCoderSwizzledMethod = class_getInstanceMethod([self class], @selector(vi_initWithCoder:));
//
//    method_exchangeImplementations(initWithCoderOriginalMethod, initWithCoderSwizzledMethod);
    
}

+ (nullable UIImage *)vi_imageNamed:(NSString *)name
{
    UIImage *image = [UIImage vi_imageNamed:name];
    image.imageName = name;
    
    return image;
}

+ (nullable UIImage *)vi_imageWithContentsOfFile:(NSString *)path
{
    
    NSString *pt = @"";
    if (path && [path isKindOfClass:[NSString class]] && path.length > 0) {
        pt = path;
    }
    UIImage *image = [UIImage vi_imageWithContentsOfFile:pt];
    NSURL *urlPath = [NSURL fileURLWithPath:pt];
    NSString *imageName = [[urlPath.lastPathComponent componentsSeparatedByString:@"."] firstObject];
    image.imageName = imageName;
    
    return image;
}

- (NSString *)imageName
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setImageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, @selector(imageName), imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
