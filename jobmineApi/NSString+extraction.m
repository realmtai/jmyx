//
//  NSString+extraction.m
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "NSString+extraction.h"

@implementation NSString (extraction)


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


- (NSString* ) stringBySearchBetweenBeginningString: (NSString* ) aBeginningString andEndingString: (NSString* ) aEndingString{
    
    NSRange FinalRange;
    NSError* matchError= nil;
    NSString* matachRegex = [NSString stringWithFormat:@"%@.*%@", aBeginningString, aEndingString];
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:matachRegex options:NSRegularExpressionCaseInsensitive error:&matchError];
    FinalRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (!NSEqualRanges(FinalRange, NSMakeRange(NSNotFound, 0))) {
        FinalRange = NSMakeRange(FinalRange.location + aBeginningString.length,
                                 FinalRange.length - aEndingString.length - aBeginningString.length );
        return [self substringWithRange:FinalRange];
    }else{
        return @"";
    }
}

- (BOOL) containOracleCopyRightNotic{
    NSString* orc = @"Copyright (c) 2000, 2010, Oracle and/or its affiliates. All rights reserved";
    return !(NSEqualRanges([self rangeOfString:orc], NSMakeRange(NSNotFound, 0)));
}


@end
