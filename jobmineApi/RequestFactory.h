//
//  RequestFactory.h
//  jobmineApi
//
//  Created by edwin on 8/24/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface RequestFactory : NSObject


typedef enum{
    JobmineRequestTypeStart,
    JobmineRequestTypeEnd,
    JobmineRequestTypeError,
    
    JobmineRequestTypeLogin,
    JobmineRequestTypeResume,
    JobmineRequestTypeLoadPageWithICSID,
    JobmineRequestTypeSearch1,
    JobmineRequestTypeSearch2,
    JobmineRequestTypeSearch3,
    
    JobmineRequestTypeApplicationShortList1,
    JobmineRequestTypeApplicationShortList2,
    
    JobmineRequestTypeActiveApplication1,
    JobmineRequestTypeActiveApplication2,
    JobmineRequestTypeAllApplication1,
    JobmineRequestTypeAllApplication2,
    JobmineRequestTypeInterview1,
    JobmineRequestTypeInterview2,
    JobmineRequestTypeGroupedInterview1,
    JobmineRequestTypeGroupedInterview2,
    JobmineRequestTypeSpcialRequestInterview1,
    JobmineRequestTypeSpcialRequestInterview2,
    JobmineRequestTypeCanceledInterview1,
    JobmineRequestTypeCanceledInterview2,
    JobmineRequestTypeRanking1,
    JobmineRequestTypeRanking2,
}JobmineRequestType;


typedef enum{
    RequestTypeStandardPOSTRequest,
    RequestTypeJobminePOSTRequest,
}RequestType;




+ (ASIFormDataRequest* ) newRequest: (RequestType) aCustumRequest withURL: (NSString*) aURL;
+ (ASIFormDataRequest*) newJobmineLoginRequestwithUserName: (NSString*) userName andPassWord: (NSString*) passWord;
+ (ASIFormDataRequest*) newJobmineRequestWithType: (JobmineRequestType) aJobmineRequestType withICSID: (NSString* ) aICSID;


@end
