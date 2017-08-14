//
//  NSString+DIS.h
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DIS)

#pragma mark -
#pragma mark Class methods
+ (NSString *)stringWithUUID;

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;

#pragma mark -
#pragma mark Instance methods
/**
 *  Check if string is valid email address
 *
 *  @return true if is valid email, false if invalid email string
 */
- (BOOL)isValidEmail;

/**
 * Check if string is a list of email separate by ";"
 * @return true if valid, false if invalid
 **/
- (BOOL) isValidEmailList:(NSString *)checkString;
/**
 *  Check if string is white space and new line
 *
 *  @return bool
 */

- (BOOL)isWhitespaceAndNewlines;

/**
 *  Check if string is empty or white space
 *
 *  @return bool
 */
- (BOOL)isEmptyOrWhitespace;

/**
 *  Return md5 string from original string
 *
 *  @return md5 string
 */
- (NSString *)md5;

/**
 *  trim white space in string
 *  eg: @"   abc   xyz   " will become @"abc   xyz"
 *
 *  @return string with no space in head and tail
 */
- (NSString *)trimWhiteSpace;

/**
 *  Remove all white spaces of string
 *  eg: @"  a a   a   " become @"aaa"
 *
 *  @return string without space
 */
- (NSString *)removeAllWhitespaces;
- (NSString *)replaceAllWhitespacesWithSpace;

+ (NSString *)append:(NSString *)tailString to:(NSString *)headString separatedBy:(NSString *)separato;
/**
 * Eg: viewController -> view_controller
 */
- (NSString *)objcVariableNameStyleToDBNameStyle;

+ (NSString *)stringWithBool:(BOOL)value;

- (BOOL)containsAString:(NSString *)text;

- (float) getHeightWithFont:(UIFont*)font maxSizeHeight:(float)max andWidth:(float)width;
- (float) getWidthWithFont:(UIFont*)font maxSizeWidth:(float)max;

- (BOOL)isValidPhone;
- (BOOL)isStringEmpty;
+ (NSString *) appVersion;
+ (NSString *) buildVersion;
+ (NSString *) versionBuild;
+ (NSString *)appName;
- (BOOL)isNumber;
- (BOOL)isIntegerValue;
+ (NSString *)inverveString:(NSString *)originString;
- (BOOL) isAlphaNumeric;
- (BOOL) isContainNumber;

+ (NSString *)maxCharInString;
+ (NSString *)minCharInString;
- (NSArray *)getWords;
- (NSString *)getFirstCharacterEachWord;
- (NSString *)removeUTF8Accents;
- (NSString *)uppercaseFirstString;

@end

@interface NSString (EquipmentSectionName)

+ (NSString *)unknownEquipmentStoreNumber;

@end

@interface NSString (VariableConvention)

- (NSString *)camelcase;
- (NSString *)underscore;

+ (NSString *)biggistCharacterInString;
- (BOOL)insensitiveSearchWithString:(NSString *)string;
@end

@interface NSString (CombineString)

+ (NSString *)combineStringBySeperator:(NSString *)seperator strings:(NSString *)component, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString*) mimeTypeForFileAtPath: (NSString *) path;

@end

@interface NSString (Encrypt)

- (NSData *)encryptAES256SettingsWithKey:(NSString *)key error:(NSError **)error;
+ (NSString *)decryptAES256SettingData:(NSData *)data key:(NSString *)key error:(NSError **)error;

@end

@interface NSString (RequireFormatText)
- (NSAttributedString *)requireTextWithMainFont:(UIFont *)font mainTextColor:(UIColor *)color hightlightedText:(NSString *)hText appendText:(NSString *)aText;
- (NSAttributedString *)requireTextWithMainFont:(UIFont *)font mainTextColor:(UIColor *)color hightlightedText:(NSString *)hText appendText:(NSString *)aText hightlightedTextColor:(UIColor *)hColor;

- (NSAttributedString *)requireTextStyle1WithMainNuiClass:(NSString *)nuiClass; // Title *:
- (NSAttributedString *)requireTextStyle2WithMainNuiClass:(NSString *)nuiClass; // Title *
- (NSAttributedString *)disableRequireTextStyle1WithMainNuiClass:(NSString *)nuiClass; // Title *:
- (NSAttributedString *)disableRequireTextStyle2WithMainNuiClass:(NSString *)nuiClass; // Title *

@end

@interface NSString (Convertion)

- (NSString *)convertToAsciiString;
- (NSString *)replaceDWithStrokeByStringUpperCase:(NSString *)upperCase lowerCase:(NSString *)lowerCase;
- (NSString *)reveseReplaceDWithStrokeByStringUpperCase:(NSString *)upperCase lowerCase:(NSString *)lowerCase;

@end
