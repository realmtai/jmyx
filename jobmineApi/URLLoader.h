//
//  URLLoader.h
//  jobmineApi
//
//  Created by edwin on 8/19/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class URLLoader;

@protocol URLLoaderReponserDelegate <NSObject>

@optional

- (void) URLLoader: (URLLoader*) aLoader FinshedSuccessfullWithLoadString: (NSString*) loadString;
- (void) URLLoader:(URLLoader *)aLoader FinshedWithError:(NSError *)aError;

@end





@interface URLLoader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


typedef enum{
    ConnectionStatusStarted,
    ConnectionStatusLoading,
    ConnectionStatusFinshedWithError,
    ConnectionStatusFinshedSuccessful
}ConnectionStatus;


typedef enum{
    HTTPMethodPost,
    HTTPMethodGet
}HTTPMethod;

@property (nonatomic, strong) NSString* cookieString;
@property (nonatomic, strong) NSString* postMassage;
@property (nonatomic, strong) NSString* URL;
@property HTTPMethod connectionType;


@property (nonatomic, strong) NSString* result;
@property (nonatomic, strong) NSMutableData* resultData;
@property (readonly) ConnectionStatus connectionStatus;

@property (nonatomic, weak) id<URLLoaderReponserDelegate> responseDelegate;



- (id) init: (NSString*) aURL httpHeader: (NSString*) aCookie postMassage: (NSDictionary*) apostMassage startAfterInit:(BOOL)start;
- (void) startLoading;







// Shoulnt call directily; private implementations


@property (nonatomic, strong) NSURLConnection* connection;

- (NSString*) genPostMassageString: (NSDictionary* ) massageDictionary;
- (void) setConnectionStatus:(ConnectionStatus)connectionStatus;
- (void) resetConnection;

@end
