//
//  jobmineApi.m
//  jobmineApi
//
//  Created by edwin on 8/19/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "jobmineApi.h"
#import "RequestResponser.h"
#import "NSString+extraction.h"

#import "JobmineInfo.h"
#import "JobmineApplicationDetail.h"


@interface jobmineApi ()

@property (nonatomic) BOOL isCookieRenewvalNeeded;
@property (nonatomic) BOOL isICSIDRenewvalNeeded;
- (void) usejobmineDocument;
- (NSURL *)applicationDocumentsDirectory;


@end



@implementation jobmineApi

NSString*const JobmineNotificationAccpetingRequest = @"JobmineNotificationAccpetingRequest";
NSString*const JobmineNotificationDecliningRequest = @"JobmineNotificationDecliningRequest";
NSString*const JobmineNotificationDocumentIsReady = @"JobmineNotificationDocumentIsReady";
NSString*const JobmineNotificationLoginInfoIncorrect = @"JobmineNotificationLoginInfoIncorrect";
NSString*const JobmineUserDefaultUserName = @"JobmineUserDefaultUserName";
NSString*const JobmineUserDefaultPassWord = @"JobmineUserDefaultPassWord";


#pragma mark - inits
- (id) init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extractInfo:) name:RequestResponserNotificationEndStateReached object:nil];
    }
    return self;
}


#pragma mark - getters
- (jobmineDictionary*) jobmineURLLookUpDictionary{
    if (!_jobmineURLLookUpDictionary) {
        _jobmineURLLookUpDictionary = [[jobmineDictionary alloc] init];
    }
    return _jobmineURLLookUpDictionary;
}

- (NSMutableArray*) requestStack {
    if (!_requestStack) {
        _requestStack = [NSMutableArray new];
    }
    return _requestStack;
}



#pragma mark - login & reponse stack


- (void) upDateLoginInformation{
    
    self.ableToAcceptRequest = NO;
    self.isCookieRenewvalNeeded = YES;
    self.isICSIDRenewvalNeeded = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationDecliningRequest object:nil];

    
    
    RequestResponser* loginResponder = [[RequestResponser alloc] init];
    [loginResponder setCurrentRequestState:JobmineRequestTypeEnd];
    [self.requestStack addObject:loginResponder];
    
    dispatch_queue_t loginQuee = dispatch_queue_create("login quee", NULL);
    
    dispatch_async(loginQuee, ^{
        ASIFormDataRequest* newReq = [RequestFactory newJobmineLoginRequestwithUserName:self.userName andPassWord:self.passWord];
        //[newReq setShouldRedirect:NO];
        [newReq setDelegate:[self.requestStack lastObject]];
        [newReq startAsynchronous];
    });
    
}


- (void) extractInfo: (NSNotification *) aNSNotification{
    
    
    if (![self ableToAcceptRequest]) {
        if (self.isCookieRenewvalNeeded) {
            if ([[aNSNotification object] isKindOfClass:[RequestResponser class]]) {
                NSString* loginHTML = [[NSString alloc] initWithData:[[aNSNotification object] respondData] encoding:NSUTF8StringEncoding];
                if ([loginHTML containOracleCopyRightNotic]) {
                    self.isCookieRenewvalNeeded = NO;
                    [self.requestStack removeObject:((RequestResponser*)[aNSNotification object])];
                    
                    ASIFormDataRequest* newReq = [RequestFactory newJobmineRequestWithType:JobmineRequestTypeLoadPageWithICSID withICSID:@""];
                    RequestResponser* aRequest = [[RequestResponser alloc] init];
                    [aRequest setCurrentRequestState:JobmineRequestTypeEnd];
                    [self.requestStack addObject:aRequest];
                    [newReq setDelegate:aRequest];
                    [newReq startAsynchronous];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:JobmineUserDefaultUserName];
                    [[NSUserDefaults standardUserDefaults] setObject:self.passWord forKey:JobmineUserDefaultPassWord];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self setupDocument];

                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationLoginInfoIncorrect object:nil];
                }
            }
        }else if([self isICSIDRenewvalNeeded]){
            if ([[aNSNotification object] isKindOfClass:[RequestResponser class]]) {
                
                RequestResponser* thisICSIDResponder = ((RequestResponser*)[aNSNotification object]);
                
                NSString* lineWithICSID = [[[NSString alloc] initWithData:[thisICSIDResponder respondData] encoding:NSUTF8StringEncoding]
                                           stringBySearchForStringSegment:@"ICSID"
                                                        betweenBeginString:@"<"
                                                           andEndingString:@">"];
                self.ICSID = [lineWithICSID stringBySearchBetweenBeginningString:@"value='" andEndingString:@"'"];
                NSLog(@"%@", self.ICSID);
                [self.requestStack removeObject:thisICSIDResponder];
                
                self.isICSIDRenewvalNeeded = NO;
                self.ableToAcceptRequest = YES;
                
				[SVProgressHUD showSuccessWithStatus:@"Login Successful"];
                [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationAccpetingRequest object:nil];
            }
        }
    }else{
        if ([[aNSNotification object] isKindOfClass:[RequestResponser class]]) {
            [self.requestStack removeObject:[aNSNotification object]];
        }
    }
    
}



#pragma mark - init for CoreData

- (void) usejobmineDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.jobmineDoc.fileURL path]]) {
        [self.jobmineDoc saveToURL:self.jobmineDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationDocumentIsReady object:nil];
        }];
    }else if (self.jobmineDoc.documentState == UIDocumentStateClosed){
        [self.jobmineDoc openWithCompletionHandler:^(BOOL success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationDocumentIsReady object:nil];
        }];
    }else if (self.jobmineDoc.documentState == UIDocumentStateNormal){
        [self.jobmineDoc openWithCompletionHandler:^(BOOL success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationDocumentIsReady object:nil];
        }];
    }else{
        [NSException raise:@"document Error UNknow doucment State: " format:@"%i", self.jobmineDoc.documentState];
    }
}


- (void) setJobmineDoc:(UIManagedDocument *)ajobmineDoc{
    if (_jobmineDoc != ajobmineDoc) {
        _jobmineDoc = ajobmineDoc;
        [self usejobmineDocument];
    }
}

- (void) setupDocument{
    NSURL* dburl = [self applicationDocumentsDirectory];
    dburl = [dburl URLByAppendingPathComponent:self.userName];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jobmineDoc = [[UIManagedDocument alloc] initWithFileURL:dburl];
    });
    
}




#pragma mark - setup init requests
//
//- (void)initApplicationShortListRequest {
//    RequestResponser* aResponder = [[RequestResponser alloc] init];
//    aResponder.isDebug = NO;
//    [aResponder setCurrentRequestState:JobmineRequestTypeStart];
//    [aResponder setJobmine:self];
//    [aResponder setRequestResponseForCategoryListing:CategoryListingApplicationShortList];
//    [self.requestStack addObject:aResponder];
//    
//    
//    dispatch_queue_t applicationShortListQuee = dispatch_queue_create("shortList", NULL);
//    dispatch_async(applicationShortListQuee, ^{
//        ASIFormDataRequest* aDummyGetRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:jobmineApplicationShortListURL];
//        [aDummyGetRequest setDelegate:[self.requestStack lastObject]];
//        [aDummyGetRequest startAsynchronous];
//        
//    });
//}
//
//
//
//- (void)initAllApplicationListRequest {
//    RequestResponser* aResponder = [[RequestResponser alloc] init];
//    aResponder.isDebug = YES;
//    [aResponder setCurrentRequestState:JobmineRequestTypeStart];
//    [aResponder setJobmine:self];
//    [aResponder setRequestResponseForCategoryListing:CategoryListingAllApplicationList];
//    [self.requestStack addObject:aResponder];
//    dispatch_queue_t applicationShortListQuee = dispatch_queue_create("Allapplication", NULL);
//    dispatch_async(applicationShortListQuee, ^{
//        ASIFormDataRequest* aDummyGetRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:jobmineApplicationListURL];
//        [aDummyGetRequest setDelegate:[self.requestStack lastObject]];
//        [aDummyGetRequest startAsynchronous];
//    });
//}

- (void) initJobmineMineRequest: (CategoryListing) aTypeOfRequest withURL: (NSString*) aRequestURL{
	
    RequestResponser* aResponder = [[RequestResponser alloc] init];
//    aResponder.isDebug = YES;
    [aResponder setCurrentRequestState:JobmineRequestTypeStart];
    [aResponder setJobmine:self];
    [aResponder setRequestResponseForCategoryListing:aTypeOfRequest];
    [self.requestStack addObject:aResponder];
    dispatch_queue_t applicationShortListQuee = dispatch_queue_create("aRequest", NULL);
    dispatch_async(applicationShortListQuee, ^{
        ASIFormDataRequest* aDummyGetRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:aRequestURL];
        [aDummyGetRequest setDelegate:[self.requestStack lastObject]];
        [aDummyGetRequest startAsynchronous];
    });
}

#pragma mark - public API

- (void) updateSessionsWithListing: (CategoryListing) aListing{
    if (self.ableToAcceptRequest) {
		[SVProgressHUD showWithStatus:@"Updating ... "];
        switch (aListing) {
            case CategoryListingApplicationShortList:{
                [self initJobmineMineRequest:aListing withURL:jobmineApplicationShortListURL];
            }
                break;
                
            case CategoryListingActiveApplicationList:{
				[self initJobmineMineRequest:aListing withURL:jobmineApplicationListURL];
			}
                break;
			case CategoryListingAllApplicationList:{
				[self initJobmineMineRequest:aListing withURL:jobmineApplicationListURL];
			}
                break;
				
			case CategoryListingCencelledInterview:{
				[self initJobmineMineRequest:aListing withURL:jobmineInterviewURL];
			}
				break;
			case CategoryListingSinglePersonInterview:{
				[self initJobmineMineRequest:aListing withURL:jobmineInterviewURL];
			}
				break;
			case CategoryListingGroupInterview:{
				[self initJobmineMineRequest:aListing withURL:jobmineInterviewURL];
			}
			case CategoryListingSpecialRequestInterview:{
				[self initJobmineMineRequest:aListing withURL:jobmineInterviewURL];
			}
				break;
                
            default:
                break;
        }
    }else{
		[SVProgressHUD showErrorWithStatus:@"Fail to login!"];
	}
}



- (void) updateApplicationDetailWithAppInfo: (JobmineInfo* ) aJobmineInfo
							  withResponser: (__weak id<jobmineNetworkDelegate>) ajobmineNetworkDelegate{
	
	NSString* resultHTML = aJobmineInfo.refreToApplication.jobDescription;
	if (!resultHTML) {
		NSString* jIDString = [NSString stringWithFormat:@"00%@", aJobmineInfo.refreToApplication.jID.stringValue];
		
		
		
		
		RequestResponser* aResponder = [[RequestResponser alloc] init];
		aResponder.isDebug = NO;
		[aResponder setCurrentRequestState:JobmineRequestTypeEnd];
		[aResponder setJobmine:self];
		[aResponder setJobmineDataResponder:ajobmineNetworkDelegate];
		[aResponder setRequestResponseForCategoryListing:CategoryListingJobApplicationDetail];
		[self.requestStack addObject:aResponder];
		dispatch_queue_t applicationShortListQuee = dispatch_queue_create("aRequest", NULL);
		dispatch_async(applicationShortListQuee, ^{
			ASIFormDataRequest* aDummyGetRequest = [RequestFactory newRequest:RequestTypeStandardPOSTRequest withURL:[jobmineApplicationDetailURL stringByAppendingString:jIDString]];
			[aDummyGetRequest setDelegate:[self.requestStack lastObject]];
			[aDummyGetRequest startAsynchronous];
		});
		
		
	}else{
		[ajobmineNetworkDelegate jobmineLoadDataReachEndState:self withHTMLString:resultHTML];
	}
}

- (void) loginToJobmineWithUserName: (NSString* )uName andPassWord: (NSString* ) pWord{
    
    if (![uName isEqualToString:@""]) {
        self.userName = uName;
        self.passWord = pWord;
        [self upDateLoginInformation];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationLoginInfoIncorrect object:nil];
    }
}

- (void) updateLoginInfo {
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:JobmineUserDefaultUserName]) {
        [self loginToJobmineWithUserName:[[NSUserDefaults standardUserDefaults] stringForKey:JobmineUserDefaultUserName]
                             andPassWord:[[NSUserDefaults standardUserDefaults] stringForKey:JobmineUserDefaultPassWord]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:JobmineNotificationLoginInfoIncorrect object:nil];
    }
}


- (void) removeUserInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JobmineUserDefaultUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JobmineUserDefaultPassWord];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateLoginInfo];
}




#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




//- (void) insertDummyEntry{
//    JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:@"JobmineInfo" inManagedObjectContext:self.jobmineDoc.managedObjectContext];
//    aInfo.jID = [NSNumber numberWithInt:8];
//    aInfo.applicationListing = [NSNumber numberWithInt:10];
//    aInfo.refreToApplication = [NSEntityDescription insertNewObjectForEntityForName:@"JobmineApplicationDetail" inManagedObjectContext:self.jobmineDoc.managedObjectContext];
//    aInfo.refreToApplication.jID = aInfo.jID;
//}


@end
