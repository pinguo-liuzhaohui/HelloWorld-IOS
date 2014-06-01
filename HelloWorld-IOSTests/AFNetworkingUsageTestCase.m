//
//  AFNetworkingUsageTestCase.m
//  HelloWorld-IOS
//
//  Created by liuzhaohui on 14-5-30.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFHTTPRequestOperationManager.h"
#import "PGLog.h"
#import "OHHTTPStubs.h"

@interface AFNetworkingUsageTestCase : XCTestCase
{
    BOOL _done;
}
@end

@implementation AFNetworkingUsageTestCase

- (void)setUp
{
    [super setUp];
    _done = NO;
    //[PGLog setUp:LOG_LEVEL_DEBUG];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)waitFinish
{
    int waitLoop = 10;
    while (!_done && waitLoop > 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        waitLoop --;
    }
    XCTAssertTrue(waitLoop > 0, @"Failed");
}

-(void)done
{
    _done = YES;
}

-(void)setStub:(BOOL)success
{
    id<OHHTTPStubsDescriptor> stub;
    if (success) {
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.host isEqualToString:@"cctest.camera360.com"]; // Stub ALL requests without any condition
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"test.json",nil)
                                                     statusCode:200
                                                        headers:@{@"Content-Type":@"text/json"}]
                    requestTime:0.1 responseTime:OHHTTPStubsDownloadSpeedGPRS];
        }];
    } else {
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.host isEqualToString:@"cctest.camera360.com"]; // Stub ALL requests without any condition
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            // Stub all those requests with "Hello World!" string
            return [[OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                               code:kCFURLErrorNetworkConnectionLost
                                                                           userInfo:nil]]
                    requestTime:0.1 responseTime:0.1];
        }];
    }
    
    // 下面这两行代码是可选的
    stub.name = @"cctest stub";
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"[OHHTTPStubs] Request to %@ has been stubbed with %@", request.URL, stub.name);
    }];
}

// test common case
- (void)testAFHTTPRequestOperationManager
{
    [self setStub:YES];  // comment this to go with real network
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://cctest.camera360.com/feed/all" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self done];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self done];
    }];
    [self waitFinish];
}

// test lost connection
- (void)testAFHTTPRequestOperation
{
    [self setStub:NO]; // comment this to go with real network
    NSURL *url = [NSURL URLWithString:@"http://cctest.camera360.com/feed/all"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        [self done];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        [self done];
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
    [self waitFinish];
}

@end
