//
//  NSString+DIS.m
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import "NSString+DIS.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const trueString = @"true";
NSString *const falseString = @"false";

@implementation NSString (DIS)

#pragma mark -
#pragma mark Class methods
static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

+ (NSString *)base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *UUIDstring = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return UUIDstring;
}

+ (NSString *)stringWithBool:(BOOL)value
{
    if (value) {
        return trueString;
    } else {
        return falseString;
    }
}

+ (NSString *)append:(NSString *)tailString to:(NSString *)headString separatedBy:(NSString *)separator
{
    tailString = [tailString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!tailString.length) {
        return headString;
    }
    if (!headString.length) {
        return tailString;
    }
    return [NSString stringWithFormat:@"%@%@%@", headString, separator, tailString];
}

+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) buildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self buildVersion];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

+ (NSString *)appName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    return prodName;
}

#pragma mark -
#pragma mark Instance methods
- (BOOL)isValidEmail {
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidEmailList:(NSString *)checkString{
    if (!checkString) {
        return NO;
    }
    BOOL __block valid = YES;
    NSString *removeSpaceString = [checkString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *emails = [removeSpaceString componentsSeparatedByString:@";"];
    [emails enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        valid = [obj isValidEmail];
        *stop = !valid;
    }];
    return valid;
}

- (BOOL)isWhitespaceAndNewlines {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEmptyOrWhitespace {
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (NSString *)md5 {
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, (CC_LONG)strlen(string), result);
	NSString * hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                       result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
	return [hash lowercaseString];
}

- (NSString *)trimWhiteSpace {
	NSMutableString *s = [self mutableCopy];
	CFStringTrimWhitespace ((CFMutableStringRef) s);
	return (NSString *) [s copy];
}

- (NSString *)removeWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// even in the middle, like strange whitespace due &nbsp;
- (NSString *)removeAllWhitespaces {
    return [[self componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
}

- (NSString *)replaceAllWhitespacesWithSpace {
    return [[self componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @" "];
}

- (NSString *)objcVariableNameStyleToDBNameStyle {
    NSMutableArray *array1 = [NSMutableArray array];
    NSInteger currentLocation = 0;
    NSInteger location = 1;
    for (; location < self.length; location ++) {
        NSString *sub = [self substringWithRange:NSMakeRange(location, 1)];
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[sub characterAtIndex:0]]) {
            NSString *addedString = [self substringWithRange:NSMakeRange(currentLocation, location - currentLocation)];
            [array1 addObject:[addedString lowercaseString]];
            currentLocation = location;
        }
    }
    [array1 addObject:[[self substringWithRange:NSMakeRange(currentLocation, location - currentLocation)] lowercaseString]];
    return [array1 componentsJoinedByString:@"_"];
}

- (float) getHeightWithFont:(UIFont*)font maxSizeHeight:(float)max andWidth:(float)width{
    CGSize sizeOfText = [self boundingRectWithSize: CGSizeMake(width, max)
                                           options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes: [NSDictionary dictionaryWithObject:font
                                                                                forKey:NSFontAttributeName]
                                           context: nil].size;
    
    return ceilf(sizeOfText.height);
}

- (float) getWidthWithFont:(UIFont*)font maxSizeWidth:(float)max{
    CGSize sizeOfText = [self boundingRectWithSize: CGSizeMake(max, font.lineHeight)
                                           options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes: [NSDictionary dictionaryWithObject:font
                                                                                forKey:NSFontAttributeName]
                                           context: nil].size;
    
    return ceilf(sizeOfText.width);
    
}

- (BOOL)containsAString:(NSString *)text
{
    return [self.uppercaseString containsString:text.uppercaseString];
}

- (BOOL)isValidPhone
{
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:&error];
    NSUInteger numberOfMatches = [detector numberOfMatchesInString:self
                                                           options:0
                                                             range:NSMakeRange(0, [self length])];
    return numberOfMatches > 0 && [[self uppercaseString] rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location == NSNotFound;
}
- (BOOL)isNumber
{
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    NSString *format = [NSString stringWithFormat:@"0123456789%@", symbol];
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:format] invertedSet];
    if ( [self rangeOfCharacterFromSet:characterSet].location != NSNotFound ) {
        return NO;
    }
    else
        return YES;
}
- (BOOL)isIntegerValue
{
    NSString *format = @"0123456789";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:format] invertedSet];
    if ( [self rangeOfCharacterFromSet:characterSet].location != NSNotFound ) {
        return NO;
    }
    else
        return YES;
}
- (BOOL)isStringEmpty{
    if([self length] == 0) { //string is empty or nil
        return YES;
    }
    if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    return NO;
}

+ (NSString *)inverveString:(NSString *)originString{
   NSMutableString *reversedString = [NSMutableString stringWithCapacity:[originString length]];
    [originString enumerateSubstringsInRange:NSMakeRange(0,[originString length])
                                 options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                              usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                  [reversedString appendString:substring];
                              }];
    return [reversedString copy];
}

static NSCharacterSet *unwantedCharacters;
- (BOOL) isAlphaNumeric
{
    if (!unwantedCharacters) {
        unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    }
    
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

- (BOOL)isContainNumber{
    NSCharacterSet *numberSet= [NSCharacterSet decimalDigitCharacterSet];
    if ([self rangeOfCharacterFromSet:numberSet].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)maxCharInString
{
    int asciiCode = 254;
    NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
    return string;
}

+ (NSString *)minCharInString
{
    int asciiCode = 33;
    NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
    return string;
}
- (NSArray *)getWords
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)getFirstCharacterEachWord
{
    NSString * firstCharacters = @"";
    NSArray * words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringWithRange:[word rangeOfComposedCharacterSequenceAtIndex:0]];
            firstCharacters = [firstCharacters stringByAppendingString:firstLetter.uppercaseString];
        }
    }
    return firstCharacters;
}
- (NSString *)removeUTF8Accents
{
    NSString * result = self.mutableCopy;
    CFStringTransform((__bridge CFMutableStringRef)result, NULL, kCFStringTransformStripCombiningMarks, NO);
    result = [result stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    result = [result stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    return result;
}

- (NSString *)uppercaseFirstString
{
    NSString *capitalisedSentence = nil;
    if (self.length > 0) {
        capitalisedSentence = [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                  withString:[[self substringToIndex:1] capitalizedString]];
    }
    return capitalisedSentence;
}
@end

@implementation NSString (EquipmentSectionName)

+ (NSString *)unknownEquipmentStoreNumber
{
    int asciiCode = 35;
    NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
    return string;
}

@end

@implementation NSString (VariableConvention)

- (NSString *)camelcase
{
    NSArray *components = [self componentsSeparatedByString:@"_"];
    NSMutableString *output = [NSMutableString string];

    for (NSUInteger i = 0; i < components.count; i++) {
        if (i == 0) {
            [output appendString:components[i]];
        } else {
            [output appendString:[components[i] capitalizedString]];
        }
    }

    return [NSString stringWithString:output];
}

- (NSString *)underscore
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            if (idx == 0) {
                [output appendFormat:@"%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
            } else {
                [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
            }
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

+ (NSString *)biggistCharacterInString
{
    char charactor = CHAR_MAX;
    return [NSString stringWithFormat:@"%c", charactor];
}
- (BOOL)insensitiveSearchWithString:(NSString *)string
{
    return self.trimWhiteSpace.length && [self rangeOfString:string.trimWhiteSpace options:NSCaseInsensitiveSearch].location != NSNotFound;
}
@end

@implementation NSString (CombineString)

+ (NSString *)combineStringBySeperator:(NSString *)seperator strings:(NSString *)component, ...
{
    va_list args;
    va_start(args, component);
    NSMutableArray *compts = [NSMutableArray array];
    for (NSString *arg = component; arg != nil; arg = va_arg(args, NSString*))
    {
        [compts addObject:arg];
    }
    va_end(args);
    return [compts componentsJoinedByString:seperator];
}

+ (NSString*) mimeTypeForFileAtPath: (NSString *) path {
    // NSURL will read the entire file and may exceed available memory if the file is large enough. Therefore, we will write the first fiew bytes of the file to a head-stub for NSURL to get the MIMEType from.
    NSFileHandle *readFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fileHead = [readFileHandle readDataOfLength:100]; // we probably only need 2 bytes. we'll get the first 100 instead.
    
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent: @"tmp/fileHead.tmp"];
    
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil]; // delete any existing version of fileHead.tmp
    if ([fileHead writeToFile:tempPath atomically:YES])
    {
        NSURL* fileUrl = [NSURL fileURLWithPath:path];
        NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:.1];
        
        NSError* error = nil;
        NSURLResponse* response = nil;
        [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
        return [response MIMEType];
    }
    return nil;
}

@end

@import Security;
@import RNCryptor_objc;

@implementation NSString (Encrypt)

- (NSData *)encryptAES256SettingsWithKey:(NSString *)key error:(NSError **)error {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:key
                                               error:error];
    return encryptedData;
}

+ (NSString *)decryptAES256SettingData:(NSData *)data key:(NSString *)key error:(NSError **)error {
    NSData *decryptedData = [RNDecryptor decryptData:data
                                        withPassword:key
                                               error:error];
    if (decryptedData.length > 0) {
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
    
}

@end

#import "NSMutableAttributedString+Hightlighted.h"
#import "UIColor+DIS.h"

@implementation NSString (RequireFormatText)

- (NSAttributedString *)requireTextWithMainFont:(UIFont *)font mainTextColor:(UIColor *)color hightlightedText:(NSString *)hText appendText:(NSString *)aText hightlightedTextColor:(UIColor *)hColor {
    NSString *newText = [self stringByAppendingString:aText];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:newText];
    [attributeStr addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName:color} range:NSMakeRange(0, newText.length)];
    [attributeStr hightlightedWithSearchText:hText withColor:hColor];
    return attributeStr;
}

- (NSAttributedString *)requireTextWithMainFont:(UIFont *)font mainTextColor:(UIColor *)color hightlightedText:(NSString *)hText appendText:(NSString *)aText {
    return [self requireTextWithMainFont:font mainTextColor:color hightlightedText:hText appendText:aText hightlightedTextColor:[UIColor redColor]];
}

@end

@implementation NSString (Convertion)

- (NSString *)convertToAsciiString {
    return [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
}

- (NSString *)replaceDWithStrokeByStringUpperCase:(NSString *)upperCase lowerCase:(NSString *)lowerCase {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"Đ" withString:upperCase];
    result = [result stringByReplacingOccurrencesOfString:@"đ" withString:lowerCase];
    return result;
}

- (NSString *)reveseReplaceDWithStrokeByStringUpperCase:(NSString *)upperCase lowerCase:(NSString *)lowerCase {
    NSString *result = [self stringByReplacingOccurrencesOfString:upperCase withString:@"Đ"];
    result = [result stringByReplacingOccurrencesOfString:lowerCase withString:@"đ"];
    return result;
}

@end
