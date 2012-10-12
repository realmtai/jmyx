//
//  jobmineApi.h
//  jobmineApi
//
//  Created by edwin on 8/19/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jobmineDictionary.h"
#import "RequestFactory.h"
#import "JobmineInfo.h"

@class jobmineApi;

@protocol jobmineNetworkDelegate <NSObject>
@optional
- (void) jobmineLoadDataReachEndState: (jobmineApi*) jobmine withHTMLString: (NSString* ) aHTMLString;

@end



@interface jobmineApi : NSObject <ASIHTTPRequestDelegate>

typedef enum{
    CategoryListingApplicationShortList = 10,
    CategoryListingAllApplicationList,
    CategoryListingActiveApplicationList,
	CategoryListingJobApplicationDetail = 100
}CategoryListing;



// Jobmine Login userName
@property (nonatomic, strong) NSString* userName;
// Jobmine Password
@property (nonatomic, strong) NSString* passWord;
// jobmine URLs
@property (nonatomic, strong) jobmineDictionary* jobmineURLLookUpDictionary;
// switch indeicate if jobmine object is able to update right away.
@property (nonatomic) BOOL ableToAcceptRequest;
// ICSID easy for other object to get Login Info
@property (nonatomic, strong) NSString* ICSID;
// request stack to keep the response in the heap to hear back from the request.
@property (nonatomic, strong) NSMutableArray* requestStack;
// CoreData datebase document
@property (nonatomic, strong) UIManagedDocument* jobmineDoc;







// notifications:
// jobmine object is updating login require info
extern NSString*const JobmineNotificationAccpetingRequest;
// jobmine object finished updateing login info and ready to use
extern NSString*const JobmineNotificationDecliningRequest;
// coredata is ready to use.
extern NSString*const JobmineNotificationDocumentIsReady;

extern NSString*const JobmineNotificationLoginInfoIncorrect;


extern NSString*const JobmineUserDefaultUserName;
extern NSString*const JobmineUserDefaultPassWord;






// ask jobmine object to update a Category
- (void) loginToJobmineWithUserName: (NSString* )uName andPassWord: (NSString* ) pWord;
- (void) updateLoginInfo;

- (void) updateSessionsWithListing: (CategoryListing) aListing;
- (void) updateApplicationDetailWithAppInfo: (JobmineInfo* ) aJobmineInfo withResponser: (__weak id<jobmineNetworkDelegate>) aResponder;

- (void) removeUserInfo;





@end
