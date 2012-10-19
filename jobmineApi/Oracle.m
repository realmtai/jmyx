//
//  Oracle.m
//  jobmineApi
//
//  Created by edwin on 8/25/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "Oracle.h"
#import "NSString+extraction.h"
#import "RequestResponser.h"
#import "jobmineApi.h"

@implementation Oracle

+ (void) nextStpeWithInput: (ASIFormDataRequest* ) aPrivousRequest withState: (JobmineRequestType) aInputState andResponder: (id<OracleResponder>) aResponder{
    switch (aInputState) {
            
        case JobmineRequestTypeStart:{
            
            if ([[[aPrivousRequest url] absoluteString] isEqualToString:jobmineApplicationShortListURL]) {
                
                NSString* ICSID = @"";
                if ([[aPrivousRequest delegate] isKindOfClass:[RequestResponser class]]) {
                    RequestResponser* tempResp = [aPrivousRequest delegate];
                    ICSID = tempResp.jobmine.ICSID;
                    
                    ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeApplicationShortList1 withICSID:ICSID];
                    [aRequest setDelegate:[aPrivousRequest delegate]];
                    [aResponder fromState:aInputState translatedToState:JobmineRequestTypeApplicationShortList1 withRequest:aRequest];
                }
                
            }else if ([[[aPrivousRequest url] absoluteString] isEqualToString:jobmineApplicationListURL]){
				if ([[aPrivousRequest delegate] isKindOfClass:[RequestResponser class]]) {
					if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingAllApplicationList) {
						NSString* ICSID = @"";
						RequestResponser* tempResp = [aPrivousRequest delegate];
						ICSID = tempResp.jobmine.ICSID;
						
						ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeAllApplication1 withICSID:ICSID];
						[aRequest setDelegate:[aPrivousRequest delegate]];
						[aResponder fromState:aInputState translatedToState:JobmineRequestTypeAllApplication1 withRequest:aRequest];
						
					}else if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingActiveApplicationList){
						
					}
				}
			}else if ([[[aPrivousRequest url] absoluteString] isEqualToString:jobmineInterviewURL]){
				if ([[aPrivousRequest delegate] isKindOfClass:[RequestResponser class]]) {
					if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingCencelledInterview) {
						NSString* ICSID = @"";
						RequestResponser* tempResp = [aPrivousRequest delegate];
						ICSID = tempResp.jobmine.ICSID;
						
						ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeCanceledInterview1 withICSID:ICSID];
						[aRequest setDelegate:[aPrivousRequest delegate]];
						[aResponder fromState:aInputState translatedToState:JobmineRequestTypeCanceledInterview1 withRequest:aRequest];
						
					}else if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingSinglePersonInterview){
						NSString* ICSID = @"";
						RequestResponser* tempResp = [aPrivousRequest delegate];
						ICSID = tempResp.jobmine.ICSID;
						
						ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeInterview1 withICSID:ICSID];
						[aRequest setDelegate:[aPrivousRequest delegate]];
						[aResponder fromState:aInputState translatedToState:JobmineRequestTypeInterview1 withRequest:aRequest];
						
						
					}else if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingGroupInterview){
						NSString* ICSID = @"";
						RequestResponser* tempResp = [aPrivousRequest delegate];
						ICSID = tempResp.jobmine.ICSID;
						
						ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeGroupedInterview1 withICSID:ICSID];
						[aRequest setDelegate:[aPrivousRequest delegate]];
						[aResponder fromState:aInputState translatedToState:JobmineRequestTypeGroupedInterview1 withRequest:aRequest];
						
						
					}else if ([((RequestResponser*)[aPrivousRequest delegate]) requestResponseForCategoryListing] == CategoryListingSpecialRequestInterview){
						NSString* ICSID = @"";
						RequestResponser* tempResp = [aPrivousRequest delegate];
						ICSID = tempResp.jobmine.ICSID;
						
						ASIFormDataRequest* aRequest = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeSpcialRequestInterview1 withICSID:ICSID];
						[aRequest setDelegate:[aPrivousRequest delegate]];
						[aResponder fromState:aInputState translatedToState:JobmineRequestTypeSpcialRequestInterview1 withRequest:aRequest];
						
						
					}
				}
			}else{
                [NSException raise:@"At Start State Invalid URL" format:@""];
            }
        }
            
            break;
             
             
        case JobmineRequestTypeApplicationShortList1:{
            
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeApplicationShortList2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
        }
            break;
        case JobmineRequestTypeApplicationShortList2:{
            
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
        }
            break;
		case JobmineRequestTypeAllApplication1:{
			
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeAllApplication2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
		case JobmineRequestTypeAllApplication2:{
			
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
			
		case JobmineRequestTypeCanceledInterview1:{
			
			
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeCanceledInterview2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
			
			
		}
			break;
		case JobmineRequestTypeCanceledInterview2:{
			
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
				[nextRequest setURL:[NSURL URLWithString:@"http://localhost/canceledinterview.xls"]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
			
		case JobmineRequestTypeInterview1:{
			
			
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeInterview2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
			
			
		}
			break;
		case JobmineRequestTypeInterview2:{
			
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
				[nextRequest setURL:[NSURL URLWithString:@"http://localhost/interview.xls"]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
			
		case JobmineRequestTypeGroupedInterview1:{
			
			
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeGroupedInterview2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
			
			
		}
			break;
		case JobmineRequestTypeGroupedInterview2:{
			
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
				[nextRequest setURL:[NSURL URLWithString:@"http://localhost/groupinterview.xls"]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
			
			
			
		case JobmineRequestTypeSpcialRequestInterview1:{
			
			
            NSString *nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"'" andEndingString:@"'"];
            if (![nextStep isEqualToString:@""]) {
                
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
                //[nextRequest setRequestCookies:[aPrivousRequest requestCookies]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeSpcialRequestInterview2 withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
			
			
		}
			break;
		case JobmineRequestTypeSpcialRequestInterview2:{
			
            NSString* nextStep = [[aPrivousRequest responseString] stringBySearchForStringSegment:@"ps.xls" betweenBeginString:@"\n" andEndingString:@"\r"];
            
            if (![nextStep isEqualToString:@""]) {
                ASIFormDataRequest* nextRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:nextStep];
				[nextRequest setURL:[NSURL URLWithString:@"http://localhost/spicalrequestinterview.xls"]];
                [nextRequest setDelegate:[aPrivousRequest delegate]];
                [aResponder fromState:aInputState translatedToState:JobmineRequestTypeEnd withRequest:nextRequest];
            }else{
                NSLog(@"ps.xls Not Found");
            }
		}
			break;
			
			
        default:
            [NSException raise:@"State Not Found" format:@""];
            break;
    }
}


@end
