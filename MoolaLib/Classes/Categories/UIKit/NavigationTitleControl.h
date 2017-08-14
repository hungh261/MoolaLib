//
//  NavigationTitleControl_v2.h
//  Prism
//
//  Created by Hung Le on 9/20/16.
//  Copyright © 2016 Global Enterprise Mobility. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DropdownIconPosition) {
    DropdownIconPositionTop,
    DropdownIconPositionMiddle,
    DropdownIconPositionBottom,
};

typedef struct NavigationTitleControlStyle {
    DropdownIconPosition dropdownIconPosision;
    __unsafe_unretained NSString *topTitleLabelNuiClass;
    __unsafe_unretained NSString *bottomTitleLabelNuiClass;
} NavigationTitleControlStyle;

NavigationTitleControlStyle NavigationTitleControlStyle1();
NavigationTitleControlStyle NavigationTitleControlStyle2();
NavigationTitleControlStyle NavigationTitleControlStyle3();
NavigationTitleControlStyle NavigationTitleControlStyle4();
NavigationTitleControlStyle NavigationTitleControlStyle5();

@interface NavigationTitleControl : UIControl

- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("This method is unavailable.")));

@property (nonatomic) NavigationTitleControlStyle style;

- (void)setTopTitle:(NSString *)topTitle;
- (void)setBottomTitle:(NSString *)bottomTitle;
- (void)setDropdownIconImage:(NSString *)imageName;
- (void)setDropdownIconImageHidden:(BOOL)isHidden;

@end

@interface NavigationTitleControl (Utilities)

+ (instancetype)controlWithStyle1;
+ (instancetype)controlWithStyle2;
+ (instancetype)controlWithStyle3;
+ (instancetype)controlWithStyle4;
+ (instancetype)controlWithStyle5;

@end
