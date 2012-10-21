//
//  RequestFactory.m
//  jobmineApi
//
//  Created by edwin on 8/24/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "RequestFactory.h"
#import "jobmineDictionary.h"

@implementation RequestFactory


+ (ASIFormDataRequest*) newJobmineRequestWithType: (JobmineRequestType) aJobmineRequestType withICSID: (NSString* ) aICSID{
    
    ASIFormDataRequest* aJobmineRequest = nil;
    
    switch (aJobmineRequestType) {
        case JobmineRequestTypeLogin:
            [NSException raise:@"Can't request Login with this Method" format:@""];
        case JobmineRequestTypeSearch1:
            
        case JobmineRequestTypeSearch2:
            
        case JobmineRequestTypeSearch3:
            
            break;
            
            
        case JobmineRequestTypeLoadPageWithICSID:
        case JobmineRequestTypeResume:
            aJobmineRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:jobmineResumeURL];
            break;
            
        case JobmineRequestTypeApplicationShortList1:
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineApplicationShortListURL];
            [aJobmineRequest addPostValue:jobminePostICActionApplicationShortList forKey:@"ICAction"];
            
            break;
        case JobmineRequestTypeApplicationShortList2:
            aJobmineRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:jobmineApplicationShortListURL];
            
            break;
        case JobmineRequestTypeActiveApplication1:
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineApplicationListURL];
            [aJobmineRequest addPostValue:jobminePostICActionActiveApplication forKey:@"ICAction"];
			break;
        case JobmineRequestTypeAllApplication1:
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineApplicationListURL];
            [aJobmineRequest addPostValue:jobminePostICActionAllApplication forKey:@"ICAction"];
            
            break;
        case JobmineRequestTypeActiveApplication2:
            
            break;
        case JobmineRequestTypeAllApplication2:
            
            break;
        case JobmineRequestTypeInterview1:
			
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineInterviewURL];
            [aJobmineRequest addPostValue:jobminePostICActionInterview forKey:@"ICAction"];
			break;
        case JobmineRequestTypeCanceledInterview1:
			
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineInterviewURL];
            [aJobmineRequest addPostValue:jobminePostICActionCanceledInterview forKey:@"ICAction"];
			break;
			
        case JobmineRequestTypeGroupedInterview1:
			
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineInterviewURL];
            [aJobmineRequest addPostValue:jobminePostICActionGroupedInterview forKey:@"ICAction"];
			break;
        case JobmineRequestTypeSpcialRequestInterview1:
			
            aJobmineRequest = [RequestFactory newRequest:RequestTypeJobminePOSTRequest withURL:jobmineInterviewURL];
            [aJobmineRequest addPostValue:jobminePostICActionSpcialRequestInterview forKey:@"ICAction"];
			break;
            
            break;
        case JobmineRequestTypeInterview2:
            
            break;
        case JobmineRequestTypeGroupedInterview2:
            
            break;
        case JobmineRequestTypeSpcialRequestInterview2:
            
            break;
        case JobmineRequestTypeCanceledInterview2:
            
            break;
        case JobmineRequestTypeRanking1:
            
            break;
        case JobmineRequestTypeRanking2:
            
            break;
        default:
            break;
    }
    
    if (![aICSID isEqualToString:@""]) {
        [aJobmineRequest addPostValue:aICSID forKey:@"ICSID"];
    }
    return aJobmineRequest;
    
}


+ (ASIFormDataRequest*) newJobmineLoginRequestwithUserName: (NSString*) userName andPassWord: (NSString*) passWord{
    ASIFormDataRequest* aRequest = [self newRequest:RequestTypeStandardPOSTRequest withURL:jobmineLoginURL];
    [aRequest addPostValue:@"" forKey:@"httpPort"];
    [aRequest addPostValue:@"240" forKey:@"timezoneOffset"];
    [aRequest addPostValue:userName forKey:@"userid"];
    [aRequest addPostValue:passWord forKey:@"pwd"];
    [aRequest addPostValue:@"Submit" forKey:@"submit"];
    return aRequest;
}

+ (ASIFormDataRequest* ) newRequest: (RequestType) aCustumRequest withURL: (NSString*) aURL{
    ASIFormDataRequest* aRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:aURL]];
    
    switch (aCustumRequest) {
        case RequestTypeJobminePOSTRequest:
            [aRequest addPostValue:@"1" forKey:@"ICAJAX"];
            [aRequest addPostValue:@"0" forKey:@"ICNAVTYPEDROPDOWN"];
            [aRequest addPostValue:@"Panel" forKey:@"ICType"];
            [aRequest addPostValue:@"0" forKey:@"ICElementNum"];
            [aRequest addPostValue:@"0" forKey:@"ICXPos"];
            [aRequest addPostValue:@"0" forKey:@"ICYPos"];
            [aRequest addPostValue:@"-1" forKey:@"ResponsetoDiffFrame"];
            [aRequest addPostValue:@"None" forKey:@"TargetFrameName"];
            [aRequest addPostValue:@"" forKey:@"ICFocus"];
            [aRequest addPostValue:@"0" forKey:@"ICSaveWarningFilter"];
            [aRequest addPostValue:@"0" forKey:@"ICChanged"];
            [aRequest addPostValue:@"0" forKey:@"ICModalWidget"];
            [aRequest addPostValue:@"0" forKey:@"ICZoomGrid"];
            [aRequest addPostValue:@"0" forKey:@"ICZoomGridRt"];
            [aRequest addPostValue:@"" forKey:@"ICModalLongClosed"];
            [aRequest addPostValue:@"" forKey:@"ICActionPrompt"];
            [aRequest addPostValue:@"" forKey:@"ICFind"];
            [aRequest addPostValue:@"" forKey:@"ICAddCount"];
            break;
        default:
            
            break;
    }
    
    return aRequest;
}



@end
