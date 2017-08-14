//
//  UIImage+Extension.m
//  Pods
//
//  Created by Henry on 8/14/17.
//
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)imageName:(NSString *)name ofType:(NSString *)type inBundle:(NSBundle *)bundle{
    if (bundle == nil) {
        return [self imageNamed:name];
    }
    NSString *imagePath = [bundle pathForResource:name ofType:type];
    return [self imageWithContentsOfFile:imagePath];
}

@end
