//
//  UILabel+GEM.h
//  Prism
//
//  Created by Nguyen Le Duan on 3/3/15.
//  Copyright (c) 2015 Global Enterprise Mobility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (GEM)

- (void)setRequiredTextTitle:(NSString *)requiredTextTitle;
- (void)setRequiredTextTitleWithoutColon:(NSString *)requiredTextTitle;
- (void)setTextTitle:(NSString *)textTitle;
- (void)setTitle:(NSString *)title value:(NSString *)value;
- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass value:(NSString *)value valueNuiClass:(NSString *)valueNuiClass;
- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass value:(NSString *)value valueNuiClass:(NSString *)valueNuiClass withSperator:(NSString *)sperator;
- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass belowValue:(NSString *)belowValue belowValueNuiClass:(NSString *)belowValueNuiClass;
- (BOOL)isTruncated;
- (BOOL)isTruncatedByWidth:(CGFloat)width;
- (void)setValue1:(NSString *)value1 value1NuiClass:(NSString *)value1NuiClass value2:(NSString *)value2 value2NuiClass:(NSString *)value2NuiClass;
- (void)setText:(NSString *)text withNuiClass:(NSString *)nuiClass;
- (void)setValue1:(NSString *)value1 value1NuiClass:(NSString *)value1NuiClass value2:(NSString *)value2 value2NuiClass:(NSString *)value2NuiClass withSeparator:(NSString *)separator;
- (void)setHighlightedWithSearchText:(NSString *)searchText;

@end
