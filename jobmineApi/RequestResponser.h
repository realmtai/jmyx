//
//  RequestResponser.h
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "Oracle.h"
#import "jobmineApi.h"

@interface RequestResponser : NSObject <ASIHTTPRequestDelegate, OracleResponder>

@property (nonatomic) JobmineRequestType currentRequestState;

// need to set these 2 fields
@property (nonatomic, weak) jobmineApi* jobmine;
@property (nonatomic) CategoryListing requestResponseForCategoryListing;

// set the jobmineData Responder if want to be called with result html string
@property (nonatomic, weak) id<jobmineNetworkDelegate> jobmineDataResponder;

extern NSString*const RequestResponserNotificationEndStateReached;

@property (nonatomic, strong) NSData* respondData;

@property (nonatomic) BOOL isDebug;


@end
