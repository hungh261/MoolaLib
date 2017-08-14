//
//  NavigationTitleControl.m
//  Prism
//
//  Created by Hung Le on 9/20/16.
//  Copyright © 2016 Global Enterprise Mobility. All rights reserved.
//

#import "NavigationTitleControl.h"
@import Masonry;
@import NUI;

@interface UIView (Autolayout)

+ (instancetype)newForAutoLayout;
- (void)ext_rerenderViewWithCurrentNUIClass;
- (void)ext_rerenderViewWithCurrentNUIClassInDeep;

@end

@implementation UIView (Autolayout)

+ (instancetype)newForAutoLayout
{
    UIView *view = [[[self class] alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    return view;
}

- (void)ext_rerenderViewWithCurrentNUIClass
{
    self.nuiApplied = NO;
    [self applyNUI];
}

- (void)ext_rerenderViewWithCurrentNUIClassInDeep
{
    self.nuiApplied = NO;
    [self applyNUI];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj ext_rerenderViewWithCurrentNUIClassInDeep];
    }];
}

@end

@interface NavigationTitleControl ()

@property MASConstraint *dropdownImageViewCenterYConstraint;
@property MASConstraint *dropdownImageViewLeadingConstraint;
@property MASConstraint *topTitleLeadingConstraint;
@property MASConstraint *bottomTitleLeadingConstraint;
@property UILabel *topTitleLabel;
@property UILabel *bottomTitleLabel;
@property UIImageView *dropdownImageView;

@end

@implementation NavigationTitleControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _style = NavigationTitleControlStyle1();
    [self createSubview];
    return self;
}

- (CGFloat)maxWidth {
    CGFloat maxWidth = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    return maxWidth - 100;
}

- (void)createSubview
{
    self.topTitleLabel = [UILabel newForAutoLayout];
    self.topTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.topTitleLabel.nuiClass = self.style.topTitleLabelNuiClass;
    self.topTitleLabel.highlightedTextColor = [UIColor lightGrayColor];
    self.topTitleLabel.minimumScaleFactor = 0.5;
    self.topTitleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.topTitleLabel];
    
    self.bottomTitleLabel = [UILabel newForAutoLayout];
    self.bottomTitleLabel.nuiClass = self.style.bottomTitleLabelNuiClass;
    self.bottomTitleLabel.minimumScaleFactor = 0.5;
    self.bottomTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.bottomTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.bottomTitleLabel];
    self.bottomTitleLabel.highlightedTextColor = [UIColor lightGrayColor];
    
    self.dropdownImageView = [UIImageView newForAutoLayout];
    self.dropdownImageView.image = [UIImage imageNamed:@"icon_dropdown_white" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    [self addSubview:self.dropdownImageView];
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabel.mas_bottom);
        make.centerX.equalTo(self.topTitleLabel);
        make.bottom.equalTo(self).priorityHigh();
    }];
    [self.dropdownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.dropdownImageViewCenterYConstraint = make.centerY.equalTo(self);
        self.dropdownImageViewLeadingConstraint = make.leading.equalTo(self);
    }];
    [self setNeedsUpdateConstraints];
}

- (void)updateViewConstraint
{
    CGSize topTitleSize = [self.topTitleLabel sizeThatFits:CGSizeMake(50, 1000)];
    CGSize bottomSize = [self.bottomTitleLabel sizeThatFits:CGSizeMake(50, 1000)];
    CGSize imageSize = self.dropdownImageView.image.size;
    
    BOOL alignHorizImageViewByTop = topTitleSize.width >= bottomSize.width;
    [self.dropdownImageViewLeadingConstraint uninstall];
    [self.dropdownImageViewCenterYConstraint uninstall];
    
    [self.dropdownImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        switch (self.style.dropdownIconPosision) {
            case DropdownIconPositionTop: {
                self.dropdownImageViewCenterYConstraint = make.centerY.equalTo(self.topTitleLabel);
                self.dropdownImageViewLeadingConstraint = make.leading.equalTo(self.topTitleLabel.mas_trailing);
                break;
            }
            case DropdownIconPositionBottom: {
                self.dropdownImageViewCenterYConstraint = make.centerY.equalTo(self.bottomTitleLabel);
                self.dropdownImageViewLeadingConstraint = make.leading.equalTo(self.bottomTitleLabel.mas_trailing);
                break;
            }
            case DropdownIconPositionMiddle:{
                self.dropdownImageViewCenterYConstraint = make.centerY.equalTo(self);
                if (alignHorizImageViewByTop) {
                    self.dropdownImageViewLeadingConstraint = make.leading.equalTo(self.topTitleLabel.mas_trailing);
                } else {
                    self.dropdownImageViewLeadingConstraint = make.leading.equalTo(self.bottomTitleLabel.mas_trailing);
                }
                break;
            }
            default: {
                break;
            }
        }
    }];
    if (alignHorizImageViewByTop) {
        if (self.bottomTitleLeadingConstraint) {
            [self.bottomTitleLeadingConstraint uninstall];
        }
        [self.topTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            self.topTitleLeadingConstraint = make.leading.greaterThanOrEqualTo(self).offset(imageSize.width);
        }];
    } else {
        if (self.topTitleLeadingConstraint) {
            [self.topTitleLeadingConstraint uninstall];
        }
        [self.bottomTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomTitleLeadingConstraint = make.leading.greaterThanOrEqualTo(self).offset(imageSize.width);
        }];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setTopTitle:(NSString *)topTitle
{
    self.topTitleLabel.text = topTitle;
}

- (void)setBottomTitle:(NSString *)bottomTitle
{
    self.bottomTitleLabel.text = bottomTitle;
}

- (void)setStyle:(NavigationTitleControlStyle)style
{
    _style = style;
    self.topTitleLabel.nuiClass = _style.topTitleLabelNuiClass;
    [self.topTitleLabel ext_rerenderViewWithCurrentNUIClass];
    
    self.bottomTitleLabel.nuiClass = _style.bottomTitleLabelNuiClass;
    [self.bottomTitleLabel ext_rerenderViewWithCurrentNUIClass];
    [self updateViewConstraint];
    
}

- (void)setDropdownIconImage:(NSString *)imageName
{
    self.dropdownImageView.image = [UIImage imageNamed:imageName];
    [self updateViewConstraint];
}

- (CGSize)getUpdatedSize
{
    [self ext_rerenderViewWithCurrentNUIClassInDeep];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat maxWidth = [self maxWidth];
    if (size.width > maxWidth) {
        size.width = maxWidth;
    }
    return size;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEnabled) {
        [self setHighlighted:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEnabled) {
        [self setHighlighted:NO];
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)setHighlighted:(BOOL)state
{
    [self.topTitleLabel setHighlighted:state];
    [self.bottomTitleLabel setHighlighted:state];
}

- (void)setEnabled:(BOOL)enabled
{
    self.dropdownImageView.hidden = !enabled;
    [super setEnabled:enabled];
}

- (void)setDropdownIconImageHidden:(BOOL)isHidden
{
    self.dropdownImageView.hidden = isHidden;
    
}

- (void)sizeToFit
{
    CGFloat currentHeight = CGRectGetHeight(self.frame);
    CGSize newSize = [self getUpdatedSize];
    CGFloat deltaY = (newSize.height - currentHeight) / 2;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - deltaY, newSize.width, newSize.height);
}

@end

@implementation NavigationTitleControl (Utilities)

+ (instancetype)controlWithStyle:(NavigationTitleControlStyle)style
{
    NavigationTitleControl *control = [[NavigationTitleControl alloc] initWithFrame:CGRectZero];
    control.style = style;
    return control;
}

+ (instancetype)controlWithStyle1
{
    return [NavigationTitleControl controlWithStyle:NavigationTitleControlStyle1()];
}
+ (instancetype)controlWithStyle2
{
    return [NavigationTitleControl controlWithStyle:NavigationTitleControlStyle2()];
}
+ (instancetype)controlWithStyle3
{
    return [NavigationTitleControl controlWithStyle:NavigationTitleControlStyle3()];
}
+ (instancetype)controlWithStyle4
{
    NavigationTitleControl *object = [NavigationTitleControl controlWithStyle:NavigationTitleControlStyle4()];
    object.dropdownImageView.image = nil;
    [object.dropdownImageView removeFromSuperview];
    return object;
    
}
+ (instancetype)controlWithStyle5
{
    return [NavigationTitleControl controlWithStyle:NavigationTitleControlStyle5()];
}

@end

NavigationTitleControlStyle NavigationTitleControlStyle1()
{
    NavigationTitleControlStyle style;
    style.dropdownIconPosision = DropdownIconPositionTop;
    style.topTitleLabelNuiClass = @"T1";
    style.bottomTitleLabelNuiClass = @"T11";
    return style;
};

NavigationTitleControlStyle NavigationTitleControlStyle2(){
    NavigationTitleControlStyle style;
    style.dropdownIconPosision = DropdownIconPositionBottom;
    style.topTitleLabelNuiClass = @"T11";
    style.bottomTitleLabelNuiClass = @"T1";
    return style;
};

NavigationTitleControlStyle NavigationTitleControlStyle3()
{
    NavigationTitleControlStyle style;
    style.dropdownIconPosision = DropdownIconPositionBottom;
    style.topTitleLabelNuiClass = @"T1";
    style.bottomTitleLabelNuiClass = @"T11";
    return style;
};

NavigationTitleControlStyle NavigationTitleControlStyle4(){
    NavigationTitleControlStyle style;
    style.dropdownIconPosision = DropdownIconPositionTop;
    style.topTitleLabelNuiClass = @"T1";
    style.bottomTitleLabelNuiClass = @"T11";
    return style;
};

NavigationTitleControlStyle NavigationTitleControlStyle5()
{
    NavigationTitleControlStyle style;
    style.dropdownIconPosision = DropdownIconPositionMiddle;
    style.topTitleLabelNuiClass = @"T1";
    style.bottomTitleLabelNuiClass = @"T11";
    return style;
};
