//
//  NSDecimalNumberHandler+category.h
//  Prism
//
//  Created by Tung Duong Thanh on 1/31/15.
//  Copyright (c) 2015 qsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumberHandler (category)
+ (instancetype)numberHandler;
+ (NSDecimalNumberHandler*)currencyHandler:(NSString *)currencyCode;
@end
