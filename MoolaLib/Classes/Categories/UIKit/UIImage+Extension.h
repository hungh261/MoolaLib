//
//  UIImage+Extension.h
//  Pods
//
//  Created by Henry on 8/14/17.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (instancetype)imageName:(NSString *)name ofType:(NSString *)type inBundle:(NSBundle *)bundle;

@end
