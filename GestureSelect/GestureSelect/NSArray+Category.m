//
//  NSArray+Category.m
//  JJSFoundation
//
//  Created by YD-Guozuhong on 16/2/16.
//  Copyright © 2016年 JJSHome. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (id)objectAtSafeIndex:(NSInteger)index
{
    if (self == nil || [self count] == 0) {
        return nil;
    }
    if (index > self.count - 1 || index < 0) {
        NSLog(@"Index beyond of bound");
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSArray *)sortedArray:(NSArray *)numbers
{
    return [numbers sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = NSOrderedSame;
        NSInteger firstObj = [obj1 floatValue];
        NSInteger secondObj = [obj2 floatValue];
        if (firstObj > secondObj)
            result = NSOrderedDescending;
        else if (firstObj < secondObj)
            result = NSOrderedAscending;
        return result;
        
    }];
}

- (NSArray *)reverseArray:(NSArray *)array
{
    return array.reverseObjectEnumerator.allObjects;
}

- (NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
