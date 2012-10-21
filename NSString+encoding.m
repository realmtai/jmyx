//
//  NSString+encoding.m
//  jobs
//
//  Created by Edwin on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+encoding.h"

@implementation NSString (encoding)
#pragma mark - utility functions
//TODO: upgrade to these char if needed ~!@#$%^&*():{}\”€!*’();:@&=+$,/?%#[]
- (NSString *)encodeStringForNetworkReady:(NSStringEncoding)encoding
{
    CFStringRef cffinal = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self,
                                                                  NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                                  CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString* result =  [((__bridge NSString *) cffinal) copy];
    CFRelease(cffinal);
    return result;
}
@end



@implementation NSString (parsering)

- (NSString*) stringBySearchForStringSegment: (NSString*) segment betweenBeginString: (NSString*) bstring andEndingString: (NSString*) endString{
    NSRange resultRange = NSMakeRange(0, self.length);
    
    // find the segment
    NSRange foundSegnemnt = [self rangeOfString:segment];
    if (foundSegnemnt.location == NSNotFound) {
        return @"";
    }
    //Search beginning;
    NSRange findBefore = NSMakeRange(0, foundSegnemnt.location);
    findBefore = [self rangeOfString:bstring options:NSBackwardsSearch range:findBefore];
    
    if (findBefore.location != NSNotFound) {
        resultRange.location = findBefore.location+1;
        resultRange.length = self.length - resultRange.location;
    }
    
    // search after the string
    
    NSRange findAfter = NSMakeRange(foundSegnemnt.location + foundSegnemnt.length, self.length - foundSegnemnt.location - foundSegnemnt.length);
    findAfter = [self rangeOfString:endString options:NSLiteralSearch range:findAfter];
    
    
    if (findAfter.location != NSNotFound) {
        resultRange.length = findAfter.location - resultRange.location;
    }
    
    return [self substringWithRange:resultRange];
}




- (NSString*) stringByRemoveContentBetweenStrings: (NSString*)beginningString andSecondString:(NSString*)endingString{
    NSString* beginningTag = beginningString;
    NSString* endingTag = endingString;
    NSMutableString * resultData = [[NSMutableString alloc] initWithString:self];
    //NSLog(@"%s looking for tags %@",__PRETTY_FUNCTION__, beginningTag);
    
    
    
    // NSLog(@"%@", NSStringFromRange([data rangeOfString:beginningTag options:NSBackwardsSearch]));
    NSRange beginning = [resultData rangeOfString:beginningTag options:NSCaseInsensitiveSearch];
    NSRange resultingRange;
    
    
    
    while (beginning.location != NSNotFound) {
        NSRange ending = [resultData rangeOfString:endingTag 
                                           options:NSCaseInsensitiveSearch 
                                             range:NSMakeRange(beginning.location, 
                                                               [resultData length] - beginning.location)];
        resultingRange = NSMakeRange(beginning.location, (ending.location - beginning.location)+ending.length);
        [resultData deleteCharactersInRange:resultingRange];
        beginning = [resultData rangeOfString:beginningTag options:NSCaseInsensitiveSearch];
    }
    
    return resultData;
}




@end
