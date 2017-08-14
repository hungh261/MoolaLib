//
//  NSLocale+category.m
//  Pods
//
//  Created by CauPV on 8/14/17.
//
//

#import "NSLocale+category.h"

@implementation NSLocale (category)

+ (id)localeFromCurrencyCode:(NSString *)currencyCode
{
    if (!currencyCode) {
        return nil;
    }
    BOOL found = NO;
    NSLocale * locale;
    NSString * upperCode = [currencyCode uppercaseString];
    for (NSString * identifier in [NSLocale availableLocaleIdentifiers])
        @autoreleasepool {
            locale = [NSLocale localeWithLocaleIdentifier:identifier];
            if ([[[locale objectForKey:NSLocaleCurrencyCode] uppercaseString] isEqualToString:upperCode]) {
                found = YES;
                break;
            }
        }
    return found ? locale : nil;
}

@end
