//
//  UIColor+DIS.h
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DIS)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

- (NSString *)hexStringFromColor;

+ (UIColor *)sw_blueColor;
@end

@interface UIColor (SwipeButtonAction)

+ (UIColor *)sw_blueColor;
+ (UIColor *)sw_greenColor;
+ (UIColor *)sw_grayColor;
+ (UIColor *)sw_orangeColor;
+ (UIColor *)disableTextColor;
+ (UIColor *)sw_cursorColor;
+ (UIColor *)sw_searchBarColor;

@end

@interface UIColor (HashToColor)

+ (UIColor *)colorWithHash:(NSUInteger)hash;

@end

@interface UIColor (UITableViewCellColor)

+ (UIColor *)ext_selectedBackgroundColor;
+ (UIColor *)ext_normalBackgroundColor;
+ (UIColor *)ext_evenRowBackgroundColor;
+ (UIColor *)ext_oddRowBackgroundColor;
+ (UIColor *)ext_confirmationBackgroundColor;
+ (UIColor *)ext_navigationDropdownTableSeperatorColor;
+ (UIColor *)ext_dropdownTableHeaderColor;

@end

@interface UIColor (OtherViewBackground)

+ (UIColor *)ext_cashBalanceViewBackground;
+ (UIColor *)ext_navigationBackgroundColor;
+ (UIColor *)ext_tableHeaderBackground;

@end
