//
//  NSMutableAttributedString+Hightlighted.m
//  DISPrism_Sales
//
//  Created by Cừu Lười on 11/3/14.
//  Copyright (c) 2014 Phi Dung. All rights reserved.
//

#import "NSMutableAttributedString+Hightlighted.h"
#import "NSString+DIS.h"

@implementation NSMutableAttributedString (Hightlighted)

- (void)hightlightedWithSearchText:(NSString *)searchText withColor:(UIColor *)color
{
    [self hightlightedWithSearchText:searchText withColor:color highlighted:NULL];
}

- (void)hightlightedWithSearchText:(NSString *)searchText withColor:(UIColor *)color highlighted:(BOOL *)state
{
    if (!searchText.length) {
        return;
    }
    
    if ([searchText isEqualToString:self.string]) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
        return;
    }
    
    NSRange range = NSMakeRange(0, self.length);
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchText options:NSRegularExpressionCaseInsensitive error:nil];
    __block BOOL val = NO;
    [expression enumerateMatchesInString:self.string options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange keywordRange = [result rangeAtIndex:0];
        [self addAttribute:NSForegroundColorAttributeName value:color range:keywordRange];
        val = YES;
    }];
    if (state != NULL) {
        *state = val;        
    }
}

- (void)hightlightedComponentsWithSearchText:(NSString *)searchText withColor:(UIColor *)color highlighted:(BOOL *)state
{
    if (!searchText.length) {
        return;
    }
    
    if ([searchText isEqualToString:self.string]) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
        return;
    }
    NSArray *wordList = [[searchText replaceAllWhitespacesWithSpace] componentsSeparatedByString:@" "];
    NSMutableArray *ranges = [NSMutableArray new];
    __block BOOL val = NO;
    NSMutableDictionary *enumeratedWordDict = [NSMutableDictionary dictionary];
    NSString *specialUpperCaseString = [NSString stringWithFormat:@"$$Up$$"];
    NSString *specialLowerCaseString = [NSString stringWithFormat:@"$$Down$$"];
    NSString *assciText = [[[self.string replaceDWithStrokeByStringUpperCase:specialUpperCaseString lowerCase:specialLowerCaseString] convertToAsciiString] reveseReplaceDWithStrokeByStringUpperCase:specialUpperCaseString lowerCase:specialLowerCaseString];
    for (NSString *word in wordList) {
        if (!enumeratedWordDict[word]) {
            NSRange range = NSMakeRange(0, self.length);
            NSString *asciiWord = [[[word replaceDWithStrokeByStringUpperCase:specialUpperCaseString lowerCase:specialLowerCaseString] convertToAsciiString] reveseReplaceDWithStrokeByStringUpperCase:specialUpperCaseString lowerCase:specialLowerCaseString];
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:asciiWord options:NSRegularExpressionCaseInsensitive error:nil];
            [expression enumerateMatchesInString:assciText options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                for (NSInteger i = 0; i < result.numberOfRanges;i++) {
                    NSRange keywordRange = [result rangeAtIndex:i];
                    if (ranges.count) {
                        for (NSValue *savedRange in ranges) {
                            NSRange intersectionRange = NSIntersectionRange(savedRange.rangeValue, keywordRange);
                            if (NSEqualRanges(intersectionRange, savedRange.rangeValue)) {
                                [ranges removeObject:savedRange];
                                [ranges addObject:[NSValue valueWithRange:keywordRange]];
                                break;
                            }
                        }
                    } else {
                        [ranges addObject:[NSValue valueWithRange:keywordRange]];
                    }
                }
            }];
            enumeratedWordDict[word] = @(YES);
        }
    }
    for (NSValue *savedRange in ranges) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:savedRange.rangeValue];
    }
    val = ranges.count > 0;
    
    if (state != NULL) {
        *state = val;
    }
}

@end
