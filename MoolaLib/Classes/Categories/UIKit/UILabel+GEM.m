//
//  UILabel+GEM.m
//  Prism
//
//  Created by Nguyen Le Duan on 3/3/15.
//  Copyright (c) 2015 Global Enterprise Mobility. All rights reserved.
//

#import "UILabel+GEM.h"
#import "NSString+DIS.h"
#import "NSMutableAttributedString+Hightlighted.h"
@import NUI;

@implementation UILabel (GEM)
- (void)setRequiredTextTitle:(NSString *)requiredTextTitle
{
    self.text = Nil;
    self.attributedText = Nil;
    if (requiredTextTitle.length) {
        UIFont *font;
        UIColor * color;
        if (self.nuiClass.length) {
            font = [NUISettings getFontWithClass:self.nuiClass];
            color = [NUISettings getColor:@"font-color" withClass:self.nuiClass];
            self.font = font;
            self.textColor = color;
            self.nuiClass = Nil;
            [self applyNUI];
        }
        else {
            font = self.font;
            color = self.textColor;
        }
        self.attributedText = [requiredTextTitle requireTextWithMainFont:font mainTextColor:color hightlightedText:@"\\*" appendText:@" *:"];
    }
    else
        [self setText:@":"];
}

- (void)setRequiredTextTitleWithoutColon:(NSString *)requiredTextTitle{
    self.text = Nil;
    self.attributedText = Nil;
    if (requiredTextTitle.length) {
        UIFont *font;
        UIColor * color;
        if (self.nuiClass.length) {
            font = [NUISettings getFontWithClass:self.nuiClass];
            color = [NUISettings getColor:@"font-color" withClass:self.nuiClass];
            self.font = font;
            self.textColor = color;
            self.nuiClass = Nil;
            [self applyNUI];
        }
        else {
            font = self.font;
            color = self.textColor;
        }
        self.attributedText = [requiredTextTitle requireTextWithMainFont:font mainTextColor:color hightlightedText:@"\\*" appendText:@" *"];
    }
    else
        [self setText:@""];
}

- (void)setTextTitle:(NSString *)textTitle
{
    self.text = Nil;
    self.attributedText = Nil;
    if (textTitle.length) {
        [self setText:[textTitle stringByAppendingString:@":"]];
    }
    else
        [self setText:@":"];
}

- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass value:(NSString *)value valueNuiClass:(NSString *)valueNuiClass
{
    [self setTitle:title titleNuiClass:titleNuiClass value:value valueNuiClass:valueNuiClass withSperator:@": "];
}

- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass value:(NSString *)value valueNuiClass:(NSString *)valueNuiClass withSperator:(NSString *)sperator
{
    self.attributedText = Nil;
    if (title.length) {
        NSString * fullStr = [title stringByAppendingString:sperator];
        if (value.length) {
            fullStr = [fullStr stringByAppendingString:value];
        }
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        UIFont * font = [NUISettings getFontWithClass:titleNuiClass];
        UIColor * color = [NUISettings getColor:@"font-color" withClass:titleNuiClass];
        [attributeStr addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color} range:NSMakeRange(0, title.length -1 + sperator.length)];
        if (value.length) {
            font = [NUISettings getFontWithClass:valueNuiClass];
            color = [NUISettings getColor:@"font-color" withClass:valueNuiClass];
            [attributeStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color} range:NSMakeRange(title.length + sperator.length, value.length)];
        }
        self.attributedText = attributeStr;
    }
}

- (void)setTitle:(NSString *)title value:(NSString *)value
{
    [self setTitle:title titleNuiClass:@"T4" value:value valueNuiClass:@"T15"];
}

- (void)setTitle:(NSString *)title titleNuiClass:(NSString *)titleNuiClass belowValue:(NSString *)belowValue belowValueNuiClass:(NSString *)belowValueNuiClass
{
    self.attributedText = Nil;
    if (title.length) {
        UIFont * font = [NUISettings getFontWithClass:titleNuiClass];
        UIColor * color = [NUISettings getColor:@"font-color" withClass:titleNuiClass];
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:@"\n"] attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
        if (belowValue.length) {
            font = [NUISettings getFontWithClass:belowValueNuiClass];
            color = [NUISettings getColor:@"font-color" withClass:belowValueNuiClass];
            NSAttributedString * att = [[NSAttributedString alloc] initWithString:belowValue attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color}];
            [attributeStr appendAttributedString:att];
        }
        self.attributedText = attributeStr;
    }
}
- (BOOL)isTruncated
{
    return [self isTruncatedByWidth:CGRectGetWidth(self.bounds)];
}
- (BOOL)isTruncatedByWidth:(CGFloat)width
{
    CGSize sizeOfText = [self.text boundingRectWithSize: CGSizeMake(width, CGFLOAT_MAX) options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes: [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context: nil].size;
    
    if (CGRectGetHeight(self.bounds) < ceilf(sizeOfText.height)) {
        return YES;
    }
    return NO;
}

- (void)setValue1:(NSString *)value1 value1NuiClass:(NSString *)value1NuiClass value2:(NSString *)value2 value2NuiClass:(NSString *)value2NuiClass{
    self.attributedText = Nil;
    if (value1.length) {
        NSString * fullStr = [value1 stringByAppendingString:@" "];
        if (value2.length) {
            fullStr = [fullStr stringByAppendingString:value2];
        }
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        UIFont * font = [NUISettings getFontWithClass:value1NuiClass];
        UIColor * color = [NUISettings getColor:@"font-color" withClass:value1NuiClass];
        [attributeStr addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color} range:NSMakeRange(0, value1.length + 1)];
        if (value2.length) {
            font = [NUISettings getFontWithClass:value2NuiClass];
            color = [NUISettings getColor:@"font-color" withClass:value2NuiClass];
            [attributeStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color} range:NSMakeRange(value1.length + 1, value2.length)];
        }
        self.attributedText = attributeStr;
    }

}

- (void)setText:(NSString *)text withNuiClass:(NSString *)nuiClass {
    [self setText:text];
    [self setNuiClass:nuiClass];
    [self applyNUI];
}

- (void)setValue1:(NSString *)value1 value1NuiClass:(NSString *)value1NuiClass value2:(NSString *)value2 value2NuiClass:(NSString *)value2NuiClass withSeparator:(NSString *)separator {
    self.attributedText = Nil;
    if (value1.length) {
        NSString * fullStr;
        if (separator.length) {
            fullStr = [value1 stringByAppendingString:separator];
        }else{
            fullStr = value1;
        }
        if (value2.length) {
            fullStr = [fullStr stringByAppendingString:value2];
        }
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        UIFont * font = [NUISettings getFontWithClass:value1NuiClass];
        UIColor * color = [NUISettings getColor:@"font-color" withClass:value1NuiClass];
        if (separator.length) {
            [attributeStr addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color} range:NSMakeRange(0, value1.length + separator.length)];
        }else{
            [attributeStr addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color} range:NSMakeRange(0, value1.length)];
        }
        if (value2.length) {
            font = [NUISettings getFontWithClass:value2NuiClass];
            color = [NUISettings getColor:@"font-color" withClass:value2NuiClass];
            if (separator.length) {
                [attributeStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color} range:NSMakeRange(value1.length + separator.length, value2.length)];
            }else{
                [attributeStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color} range:NSMakeRange(value1.length, value2.length)];
            }
        }
        self.attributedText = attributeStr;
    }
}

- (void)setHighlightedWithSearchText:(NSString *)searchText{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSForegroundColorAttributeName:self.textColor, NSFontAttributeName:self.font}];
    [self markHightlighted:att searchText:searchText];
    self.attributedText = att;
}

- (void)markHightlighted:(NSMutableAttributedString *)attr searchText:(NSString *)searchText{
    for (NSString *word in [[searchText replaceAllWhitespacesWithSpace] componentsSeparatedByString:@" "]) {
        BOOL highlighted = NO;
        [attr hightlightedComponentsWithSearchText:word withColor:[UIColor redColor] highlighted:&highlighted];
    }
}

@end
