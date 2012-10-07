//
//  URLLoader.m
//  jobmineApi
//
//  Created by edwin on 8/19/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "URLLoader.h"





@implementation URLLoader
@synthesize cookieString = _cookieString;
@synthesize postMassage = _postMassage;
@synthesize connection = _connection;
@synthesize connectionStatus = _connectionStatus;
@synthesize responseDelegate = _responseDelegate;



-(id) init{
    
    if (self = [self init:@"" httpHeader:@"" postMassage:[NSDictionary new] startAfterInit:NO]) {
        
    }
    return self;
}


- (id) init: (NSString*) aURL
 httpHeader: (NSString*) aCookie
postMassage: (NSDictionary*) apostMassage
startAfterInit:(BOOL)start{
    
    if (self = [super init]) {
        self.cookieString = aCookie;
        self.URL = aURL;
        [self setPostMassageWithDictionary:apostMassage];
        [self setConnectionStatus:ConnectionStatusStarted];
        if (start) {
            [self startLoading];
        }
    }
    
    return self;
}

/*
-(void) setCookieStringWithDictionary:(NSDictionary *)httpHeader{
    //NSString* temp = [self genPostMassageString:httpHeader];
    if (!_cookieString && ![_cookieString isEqualToString:temp]) {
        _cookieString = temp;
    }
    
    
}
*/
-(void) setPostMassageWithDictionary:(NSDictionary *)postMassage{
    NSString* temp = [self genPostMassageString:postMassage];
    
    
    if (!_postMassage && ![_postMassage isEqualToString:temp]) {
        _postMassage = temp;
    }
}

- (void) setConnection:(NSURLConnection *)connection{
    if (!_connection && connection!=_connection) {
        [self resetConnection];
        _connection = connection;
    }
}

- (NSURLConnection*) connectionWithURLRequest:(NSURLRequest*) aRequest{
    if (!_connection) {
        _connection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:NO];
    }
    return _connection;
}



- (NSMutableData*) resultData{
    if (!_resultData) {
        _resultData = [NSMutableData new];
    }
    return _resultData;
}

- (NSString*) result{
    if (!_resultData) {
        _result = @"";
    }else if(_result.hash != self.resultData.hash){
        _result = [[NSString alloc] initWithData:self.resultData encoding:NSUTF8StringEncoding];
    }
    return _result;
}

- (NSString*) genPostMassageString: (NSDictionary* ) massageDictionary{
    __block NSString* result = @"";
    [massageDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (![result isEqualToString:@""]) {
            result = [result stringByAppendingString:@"&"];
        }
        result = [result stringByAppendingString:
                  [((NSString*)key)
                   stringByAppendingString:[@"="
                                            stringByAppendingString:obj]]];
    }];
    
    NSLog(@"read OUT A POST :\n%@", result);
    
    return result;
}



- (void) startLoading{
    NSMutableURLRequest* tempRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.URL]
                                                                    cachePolicy:NSURLCacheStorageNotAllowed
                                                                timeoutInterval:3600];
    
    
    if (self.connectionType == HTTPMethodPost) {
        [tempRequest setHTTPMethod:@"POST"];
    }else if (self.connectionType == HTTPMethodGet){
        [tempRequest setHTTPMethod:@"GET"];
    }
    
    //set http body
    [tempRequest setHTTPBody:[self.postMassage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //add cookie
    [tempRequest addValue:self.cookieString forHTTPHeaderField:@"Cookie"];
    
    //set additional http header fileds
    [tempRequest addValue:@"jobmine.ccol.uwaterloo.ca" forHTTPHeaderField:@"Host"];
    [tempRequest addValue:@"Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:11.0) Gecko/20100101 Firefox/11.0"
        forHTTPHeaderField:@"User-Agent"];
    [tempRequest addValue:@"text/html,application/xhtml+xml,application/xml,application/vnd.ms-excel;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [tempRequest addValue:@"gzip, deflate, chunked" forHTTPHeaderField:@"Accept-Encoding"];
    [tempRequest addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    
    NSLog(@"%@", [[NSString alloc] initWithData:[tempRequest HTTPBody] encoding:NSUTF8StringEncoding]);
    
    [self connectionWithURLRequest:tempRequest];
    [self.connection start];
    [self setConnectionStatus:ConnectionStatusLoading];
    if (!self.connection) {
        [NSException raise:@"Connection was not created: " format:@""];
    }
}


/*
 
 
 @protocol NSURLConnectionDataDelegate <NSURLConnectionDelegate>
 @optional
 - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
 - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
 - (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
 totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
 
 - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
 
 @end

 */


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Has response");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Has data");
    [self.resultData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self setConnectionStatus:ConnectionStatusFinshedSuccessful];
    [self.responseDelegate URLLoader:self FinshedSuccessfullWithLoadString:self.result];
}


/*
 
 
 
 @protocol NSURLConnectionDelegate <NSObject>
 @optional
 - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
 - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 
 // Deprecated authentication delegates.
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 @end
 
 */




- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self setConnectionStatus:ConnectionStatusFinshedWithError];
    [self.responseDelegate URLLoader:self FinshedWithError:[error copy]];
}


- (void) setConnectionStatus:(ConnectionStatus)connectionStatus{
    _connectionStatus = connectionStatus;
}


- (void) resetConnection{
    [self setConnectionStatus:ConnectionStatusStarted];
    self.result = @"";
    self.resultData = [NSMutableData new];
    
}




@end
