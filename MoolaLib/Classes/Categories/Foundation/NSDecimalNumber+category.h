//
//  NSDecimalNumber+category.h
//  Prism
//
//  Created by Tung Duong Thanh on 1/30/15.
//  Copyright (c) 2015 qsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (category)
- (BOOL)isNumber;
- (NSString *)stringValueInCurrentLocale;
- (NSDecimalNumber *)safe_decimalNumberByAdding:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode;
- (NSDecimalNumber *)safe_decimalNumberBySubtracting:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode;
- (NSDecimalNumber *)safe_decimalNumberByMultiplyingBy:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode;
- (NSDecimalNumber *)safe_decimalNumberByDividingBy:(NSDecimalNumber *)decimalNumber currencyCode:(NSString *)currencyCode;


- (NSDecimalNumber *)safe_decimalNumberByAdding:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)safe_decimalNumberBySubtracting:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)safe_decimalNumberByMultiplyingBy:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)safe_decimalNumberByDividingBy:(NSDecimalNumber *)decimalNumber;

- (NSDecimalNumber *)absoluteValue;
- (NSDecimalNumber *)negativeValue;
- (BOOL)isNegativeNumber;

- (NSDecimalNumber *)roundByCurrencyCode:(NSString *)currencyCode;
- (BOOL)isRoundedByCurrencyCode:(NSString *)currencyCode;

+ (instancetype)priceDecimalNumberWithDouble:(double)value;
+ (instancetype)priceDecimalNumberWithDoubleString:(NSString *)doubleValue;
+ (instancetype)priceDecimalNumberWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
+ (instancetype)priceDecimalNumberWithNumber:(NSNumber *)number;
+ (instancetype)priceDecimalNumberWithNumber:(NSNumber *)number currencyCode:(NSString *)currencyCode;
+ (instancetype)roundNearestTwoDecimalWithDouble:(double)value;
@end

@interface NSDecimalNumber (number)

- (BOOL)notNullOrZero;
- (NSDecimalNumber *)percentage;
- (NSDecimalNumber *)safe_decimalNumberByDividingBy_zeroIfError:(NSDecimalNumber *)decimalNumber;

+ (NSDecimalNumber *)n_1000;
+ (NSDecimalNumber *)n_100;
+ (NSDecimalNumber *)n_60;
+ (NSDecimalNumber *)n_2;

+ (NSDecimalNumber *)n:(NSNumber *)number;

@end
