//
//  NSArray+Category.h
//  JJSFoundation
//
//  Created by YD-Guozuhong on 16/2/16.
//  Copyright © 2016年 JJSHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

// Avoid beyond bounds
- (id)objectAtSafeIndex:(NSInteger)index;

// Number sorts
- (NSArray *)sortedArray:(NSArray *)numbers;

// Reverse Array
- (NSArray *)reverseArray:(NSArray *)array;

// JSON string
- (NSString *)jsonString;

@end
