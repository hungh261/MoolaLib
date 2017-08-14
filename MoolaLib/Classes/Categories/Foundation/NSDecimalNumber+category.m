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

#import "CurrencyHelper.h"
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

+ (NSDecimalNumber *)taxOfInputPrice:(NSDecimalNumber *)price withVAT:(NSNumber *)vat isIncludeVAT:(BOOL)priceIncludeVAT {
    if (!vat || [vat isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    if (!price || [price isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    /*
     * Case price include tax: tax = price * vat / (100+vat).
     * Case price not include tax: tax = price * vat / 100.
     */
    NSDecimalNumber *vatDecimal = [NSDecimalNumber roundNearestTwoDecimalWithDouble:vat.doubleValue];
    NSDecimalNumber *tax;
    if (priceIncludeVAT) {
        tax = [[price safe_decimalNumberByMultiplyingBy:vatDecimal]
               safe_decimalNumberByDividingBy:
               ([vatDecimal safe_decimalNumberByAdding:[NSDecimalNumber n_100]]) currencyCode:[CurrencyHelper workingBranchCurrency]];
    }else{
        tax = [[price safe_decimalNumberByMultiplyingBy:vatDecimal]
               safe_decimalNumberByDividingBy:[NSDecimalNumber n_100] currencyCode:[CurrencyHelper workingBranchCurrency]];
    }

    return tax;
}

+ (NSDecimalNumber *)percentTaxOfInputPrice:(NSDecimalNumber *)price withTax:(NSDecimalNumber *)tax isIncludeVAT:(BOOL)priceIncludeVAT {
    if (!tax || [tax isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    if (!price || [price isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    /*
     * Case price include tax: vat = tax * 100 / (price - tax).
     * Case price not include tax: vat = tax * 100 / price.
     */
    NSDecimalNumber *percentTax;
    if (priceIncludeVAT) {
        percentTax = [[tax safe_decimalNumberByMultiplyingBy:[NSDecimalNumber n_100]]
               safe_decimalNumberByDividingBy_zeroIfError:
               ([price safe_decimalNumberBySubtracting:tax])];
    }else{
        percentTax = [[tax safe_decimalNumberByMultiplyingBy:[NSDecimalNumber n_100]]
               safe_decimalNumberByDividingBy_zeroIfError:price];
    }
    
    /*
     * Làm tròn đến số thập phân thứ 2.
     */
    percentTax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[percentTax doubleValue]]];
    return percentTax;
}

+ (NSDecimalNumber *)taxOfPreTaxPrice:(NSDecimalNumber *)price withVAT:(NSNumber *)vat {
    if (!vat || [vat isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    if (!price || [price isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    /*
     * Price truyền vào luôn là preTax.
     * Case price not include tax: tax = price * vat / 100.
     */
    NSDecimalNumber *vatDecimal = [NSDecimalNumber roundNearestTwoDecimalWithDouble:vat.doubleValue];
    NSDecimalNumber *tax = [[price safe_decimalNumberByMultiplyingBy:vatDecimal]
                            safe_decimalNumberByDividingBy_zeroIfError:[NSDecimalNumber n_100]];
    
    
    /*
     * Làm tròn đến số thập phân thứ 2.
     */
    tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[tax doubleValue]]];
    return tax;
}

+ (NSDecimalNumber *)vatOfPrice:(NSDecimalNumber *)price withTax:(NSDecimalNumber *)tax {
    if (!tax || [tax isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    if (!price || [price isEqualToNumber:[NSDecimalNumber zero]]) {
        return [NSDecimalNumber zero];
    }
    
    /*
     * Price truyền vào luôn là preTax.
     * Case price not include tax: vat = tax * 100 / price.
     */
    
    NSDecimalNumber *vat = [[[NSDecimalNumber n:tax] safe_decimalNumberByMultiplyingBy:[NSDecimalNumber n_100]]
           safe_decimalNumberByDividingBy_zeroIfError:price];
    
    
    /*
     * Làm tròn đến số thập phân thứ 2.
     */
    vat = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[vat doubleValue]]];
    return vat;
}


@end
