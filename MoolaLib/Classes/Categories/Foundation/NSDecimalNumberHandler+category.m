//
//  NSDecimalNumberHandler+category.m
//  Prism
//
//  Created by Tung Duong Thanh on 1/31/15.
//  Copyright (c) 2015 qsoft. All rights reserved.
//

#import "NSDecimalNumberHandler+category.h"
#import "NSLocale+category.h"

@implementation NSDecimalNumberHandler (category)

static NSDecimalNumberHandler *numberHandler;
static NSMutableDictionary *currencyHandlerDict;
+ (instancetype)numberHandler {
    if (!numberHandler) {
        // Default apply for USD with two number after decimal point
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            numberHandler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain
                                                                           scale:2
                                                                raiseOnExactness:NO
                                                                 raiseOnOverflow:NO
                                                                raiseOnUnderflow:NO
                                                             raiseOnDivideByZero:NO];
        });
    }
    return numberHandler;
}

+ (NSDecimalNumberHandler*)currencyHandler:(NSString *)currencyCode
{
    if (!currencyHandlerDict) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currencyHandlerDict = [NSMutableDictionary new];
        });
    }
    if (!currencyCode.length) {
        return [self numberHandler];
    }
    if (!currencyHandlerDict[currencyCode]) {
        NSLocale *locale = [NSLocale localeFromCurrencyCode:currencyCode];
        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setLocale:locale];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSInteger maximumFractionDigits = numberFormatter.maximumFractionDigits;
        
        NSDecimalNumberHandler * numberHandler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:maximumFractionDigits raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        [currencyHandlerDict setObject:numberHandler forKey:currencyCode];
    }
    return currencyHandlerDict[currencyCode];
}

@end
