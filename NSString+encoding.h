//
//  NSString+encoding.h
//  jobs
//
//  Created by Edwin on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encoding)
- (NSString *)encodeStringForNetworkReady:(NSStringEncoding)encoding;

@end




@interface NSString (parsering)

- (NSString*) stringBySearchForStringSegment: (NSString*) segment betweenBeginString: (NSString*) bstring andEndingString: (NSString*) endString;

- (NSString*) stringByRemoveContentBetweenStrings: (NSString*)beginningString andSecondString:(NSString*)endingString;
@end



