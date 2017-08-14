//
//  NSMutableAttributedString+Hightlighted.h
//  DISPrism_Sales
//
//  Created by Cừu Lười on 11/3/14.
//  Copyright (c) 2014 Phi Dung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Hightlighted)

- (void)hightlightedWithSearchText:(NSString *)searchText withColor:(UIColor *)color;
- (void)hightlightedWithSearchText:(NSString *)searchText withColor:(UIColor *)color highlighted:(BOOL *)state;
- (void)hightlightedComponentsWithSearchText:(NSString *)searchText withColor:(UIColor *)color highlighted:(BOOL *)state;
@end
