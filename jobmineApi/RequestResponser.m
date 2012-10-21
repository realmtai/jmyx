//
//  RequestResponser.m
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "RequestResponser.h"
#import "TFHpple+CoreData.h"

@implementation RequestResponser
@synthesize currentRequestState = _currentRequestState;
@synthesize respondData = _respondData;
@synthesize isDebug = _isDebug;
@synthesize jobmine = _jobmine;
@synthesize requestResponseForCategoryListing = _requestResponseForCategoryListing;

NSString*const RequestResponserNotificationEndStateReached = @"RequestResponserNotificationEndStateReached";

- (id) init{
    if (self = [super init]) {
        
    }
    return self;
}



- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([self currentRequestState] == JobmineRequestTypeEnd) {
        self.respondData = [request responseData];
        if (self.isDebug) {
            NSLog(@"=================END END\n%@\n================ENDED", [request responseString]);
        }
        [TFHpple insertDataString:self.respondData forCategory:self.requestResponseForCategoryListing withManagedContext:self.jobmine.jobmineDoc.managedObjectContext];
		
		if ([self.jobmineDataResponder conformsToProtocol:@protocol(jobmineNetworkDelegate)]) {
			[self.jobmineDataResponder jobmineLoadDataReachEndState:self.jobmine
													 withHTMLString:[TFHpple insertJobmineApplicationDetail:self.respondData
																								withContext:self.jobmine.jobmineDoc.managedObjectContext]];
		}
		
        [[NSNotificationCenter defaultCenter] postNotificationName:RequestResponserNotificationEndStateReached object:self];
    }else if ([self currentRequestState] == JobmineRequestTypeError){
        
    }else{
        [Oracle nextStpeWithInput:(ASIFormDataRequest*)request withState:[self currentRequestState] andResponder:self];
        if (self.isDebug) {
            NSLog(@"RESULT: ===================");
            NSLog(@"%@", [request responseString]);
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"Network Failure"];
    if (self.isDebug) {
        NSLog(@"%@", [request error]);
    }
}

- (void) fromState: (JobmineRequestType) fromState translatedToState: (JobmineRequestType) toState withRequest: (ASIFormDataRequest* ) aRequest{
    [self setCurrentRequestState:toState];
    [aRequest startAsynchronous];
}

@end
