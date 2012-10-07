//
//  Oracle.h
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "jobmineDictionary.h"
#import "RequestFactory.h"


@protocol OracleResponder;


@interface Oracle : NSObject


+ (void) nextStpeWithInput: (ASIFormDataRequest* ) aPrivousRequest withState: (JobmineRequestType) aInputState andResponder: (id<OracleResponder>) aResponder;

@end


@protocol OracleResponder <NSObject>

@optional

- (void) fromState: (JobmineRequestType) fromState translatedToState: (JobmineRequestType) toState withRequest: (ASIFormDataRequest* ) aRequest;

@end

