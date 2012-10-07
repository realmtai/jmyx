//
//  NSString+extraction.h
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (extraction)



- (NSString*) stringBySearchForStringSegment: (NSString*) segment betweenBeginString: (NSString*) bstring andEndingString: (NSString*) endString;
- (NSString* ) stringBySearchBetweenBeginningString: (NSString* ) aBeginningString andEndingString: (NSString* ) aEndingString;
- (BOOL) containOracleCopyRightNotic;

@end
