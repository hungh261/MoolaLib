//
//  NSDecimalNumber+category.m
//  Prism
//
//  Created by Tung Duong Thanh on 1/30/15.
//  Copyright (c) 2015 qsoft. All rights reserved.
//

#import "NSDecimalNumber+category.h"
#import "NSDecimalNumberHandler+category.h"

@implementation NSDecimalNumber (category)

- (BOOL)isNumber {
    return ![self isEqual:[NSDecimalNumber notANumber]];
}

#pragma mark - Currency

- (NSDecimalNumber *)safe_decimalNumberByAdding:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByAdding:decimalNumber withBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberBySubtracting:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberBySubtracting:decimalNumber withBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberByMultiplyingBy:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByMultiplyingBy:decimalNumber withBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberByDividingBy:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByDividingBy:decimalNumber withBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
    }
    else
        return self;
}

#pragma mark - Just safe methods, not for Rounding

- (NSDecimalNumber *)safe_decimalNumberByAdding:(NSDecimalNumber *)decimalNumber
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByAdding:decimalNumber];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberBySubtracting:(NSDecimalNumber *)decimalNumber
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberBySubtracting:decimalNumber];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberByMultiplyingBy:(NSDecimalNumber *)decimalNumber
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByMultiplyingBy:decimalNumber];
    }
    else
        return self;
}
- (NSDecimalNumber *)safe_decimalNumberByDividingBy:(NSDecimalNumber *)decimalNumber
{
    if ([decimalNumber isValidDecimalNumber]) {
        return [self decimalNumberByDividingBy:decimalNumber];
    }
    else
        return self;
}
- (BOOL)isValidDecimalNumber
{
    return ![self isEqualToNumber:[NSDecimalNumber notANumber]];
}

- (NSString *)stringValueInCurrentLocale {
    NSDecimal decimal = self.decimalValue;
    return NSDecimalString(&decimal, [NSLocale currentLocale]);
}
- (NSDecimalNumber *)absoluteValue
{
    if ([self isNegativeNumber]) {
        return [self negativeValue];
    } else
        return self;
}


- (BOOL)isNegativeNumber
{
    return [self compare:[NSDecimalNumber zero]] == NSOrderedAscending;
}
- (NSDecimalNumber *)negativeValue
{
    return [[NSDecimalNumber zero] safe_decimalNumberBySubtracting:self];
}

#pragma mark - Rounding

- (NSDecimalNumber *)roundByCurrencyCode:(NSString *)currencyCode
{
    return [self decimalNumberByAdding:[NSDecimalNumber zero] withBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
}

- (BOOL)isRoundedByCurrencyCode:(NSString *)currencyCode
{
    NSDecimalNumber *roundedValue = [self roundByCurrencyCode:currencyCode];
    return [roundedValue compare:self] == NSOrderedSame;
}


+ (instancetype)priceDecimalNumberWithDouble:(double)value {
    NSDecimalNumber *decimalNumber = [self decimalNumberWithString:@(value).stringValue];
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler numberHandler]];
}

+ (instancetype)priceDecimalNumberWithDoubleString:(NSString *)doubleValue {
    NSDecimalNumber *decimalNumber = [self decimalNumberWithString:doubleValue locale:[NSLocale currentLocale]];
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler numberHandler]];
}

+ (instancetype)priceDecimalNumberWithDecimalNumber:(NSDecimalNumber *)decimalNumber {
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler numberHandler]];
}

+ (instancetype)priceDecimalNumberWithNumber:(NSNumber *)number {
    if (!number.stringValue) {
        return nil;
    }
    NSDecimalNumber *decimalNumber = [self decimalNumberWithString:number.stringValue];
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler numberHandler]];
}
+ (instancetype)priceDecimalNumberWithNumber:(NSNumber *)number currencyCode:(NSString *)currencyCode {
    if (!number.stringValue) {
        return nil;
    }
    NSDecimalNumber *decimalNumber = [self decimalNumberWithString:number.stringValue];
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler currencyHandler:currencyCode]];
}
+ (instancetype)roundNearestTwoDecimalWithDouble:(double)value
{
    NSDecimalNumber *decimalNumber = [self decimalNumberWithString:@(value).stringValue];
    return [decimalNumber decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler numberHandler]];
}
@end

@implementation NSDecimalNumber (number)

- (BOOL)notNullOrZero {
    return (self && ![self isEqualToNumber:[NSDecimalNumber zero]]);
}

- (NSDecimalNumber *)percentage {
    return [self safe_decimalNumberByDividingBy:[NSDecimalNumber n_100]];
}

- (NSDecimalNumber *)safe_decimalNumberByDividingBy_zeroIfError:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber || [decimalNumber isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    return [self safe_decimalNumberByDividingBy:decimalNumber];
}

+ (NSDecimalNumber *)n_1000 {
    return [NSDecimalNumber decimalNumberWithString:@"1000"];
}

+ (NSDecimalNumber *)n_100 {
    return [NSDecimalNumber decimalNumberWithString:@"100"];
}

+ (NSDecimalNumber *)n_60 {
    return [NSDecimalNumber decimalNumberWithString:@"60"];
}

+ (NSDecimalNumber *)n_2 {
    return [NSDecimalNumber decimalNumberWithString:@"2"];
}

+ (NSDecimalNumber *)n:(NSNumber *)number {
    if (!number) {
        return [NSDecimalNumber zero];
    }
    return [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

@end
