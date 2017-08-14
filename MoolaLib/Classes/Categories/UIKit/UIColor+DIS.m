//
//  UIColor+DIS.m
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import "UIColor+DIS.h"

@implementation UIColor (DIS)
+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

- (NSString *)hexStringFromColor {
    return [NSString stringWithFormat:@"%0.6X", (unsigned int)self.rgbHex];
}
- (UInt32)rgbHex {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
    
	return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}
- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}
- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
    
	CGFloat r,g,b,a;
    
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
    
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
    
	return YES;
}
- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}
- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

+ (UIColor *)sw_blueColor
{
    return RGBCOLOR(15, 69, 114, 1);
}
@end

@implementation UIColor (SwipeButtonAction)

+ (UIColor *)sw_blueColor
{
    return RGBCOLOR(15, 69, 114, 1);
}

+ (UIColor *)sw_greenColor
{
    return RGBCOLOR(30, 200, 90, 1);
}

+ (UIColor *)sw_grayColor
{
    return RGBCOLOR(170, 170, 170, 1);
}

+ (UIColor *)sw_orangeColor {
    return RGBCOLOR(255, 180, 64, 1);
}

+ (UIColor *)disableTextColor
{
    return [UIColor colorWithHexString:@"bababa"];
}

+ (UIColor *)sw_cursorColor {
    return RGBCOLOR(13, 95, 255, 1);
}

+ (UIColor *)sw_searchBarColor {
    return RGBCOLOR(200, 200, 200, 1);
}

@end


@implementation UIColor (HashToColor)

+ (UIColor *)colorWithHash:(NSUInteger)hash {
    NSInteger index = hash % 20;
    return [UIColor colorList][index];
}

+ (NSArray *)colorList {
    static NSArray * colors;
    if (!colors) {
        colors = @[
                   RGBCOLOR(255, 90, 0, 1),
                   RGBCOLOR(255, 190, 0, 1),
                   RGBCOLOR(255, 140, 255, 1),
                   RGBCOLOR(140, 140, 255, 1),
                   RGBCOLOR(140, 0, 255, 1),
                   RGBCOLOR(50, 0, 140, 1),
                   RGBCOLOR(50, 0, 255, 1),
                   RGBCOLOR(0, 120, 120, 1),
                   RGBCOLOR(0, 150, 0, 1),
                   RGBCOLOR(0, 50, 0, 1),
                   
                   RGBCOLOR(200, 90, 0, 1),
                   RGBCOLOR(55, 90, 0, 1),
                   RGBCOLOR(25, 140, 55, 1),
                   RGBCOLOR(40, 240, 155, 1),
                   RGBCOLOR(240, 100, 255, 1),
                   RGBCOLOR(150, 80, 140, 1),
                   RGBCOLOR(50, 100, 25, 1),
                   RGBCOLOR(60, 220, 120, 1),
                   RGBCOLOR(90, 210, 30, 1),
                   RGBCOLOR(200, 50, 50, 1),
                   ];
    }
    return colors;
}

@end

@implementation UIColor (UITableViewCellColor)

+ (UIColor *)ext_selectedBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithHexString:@"80d4ff"];
    });
    return color;
}
+ (UIColor *)ext_normalBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor clearColor];
    });
    return color;
}
+ (UIColor *)ext_evenRowBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor clearColor];
    });
    return color;
}
+ (UIColor *)ext_oddRowBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithHexString:@"f9f9f9"];
    });
    return color;
}

+ (UIColor *)ext_confirmationBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = RGBCOLOR(185, 220, 196, 0.6);
    });
    return color;
}

+ (UIColor *)ext_navigationDropdownTableSeperatorColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithWhite:1 alpha:0.2];
    });
    return color;
}

+ (UIColor *)ext_drawerTableSeperatorColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [NUISettings getColor:@"separator-color" withClass:@"LeftMenuTable"];;
    });
    return color;
}

+ (UIColor *)ext_dropdownTableHeaderColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithHexString:@"132537"];
    });
    return color;
}

@end

@implementation UIColor (OtherViewBackground)

+ (UIColor *)ext_cashBalanceViewBackground
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor whiteColor];
    });
    return color;
}

+ (UIColor *)ext_navigationBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithHexString:@"0f4572"];
    });
    return color;
}

+ (UIColor *)ext_tableHeaderBackground
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithHexString:@"06bd6d"];
    });
    return color;
}

@end
