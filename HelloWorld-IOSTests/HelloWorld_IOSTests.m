//
//  HelloWorld_IOSTests.m
//  HelloWorld-IOSTests
//
//  Created by liuzhaohui on 14-5-27.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"

@interface HelloWorld_IOSTests : XCTestCase

@end

@implementation HelloWorld_IOSTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnectionSuccess
{
    id<OHHTTPStubsDescriptor> stub;
    stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"cctest.camera360.com"]; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"test.json",nil)
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"text/json"}]
                requestTime:0.1 responseTime:OHHTTPStubsDownloadSpeedGPRS];
        // Stub all those requests with "Hello World!" string
        //NSData* stubData = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
        //return [OHHTTPStubsResponse responseWithData:stubData statusCode:200 headers:nil];
    }];
    
    // 下面这两行代码是可选的
    stub.name = @"success stub";
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"[OHHTTPStubs] Request to %@ has been stubbed with %@", request.URL, stub.name);
    }];
    //[OHHTTPStubs setEnabled:NO];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://cctest.camera360.com/feed/all"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"get %@, data: %@, err: %@", url, strData, err);
    
    [OHHTTPStubs removeAllStubs];
}

- (void)testConnectionFailed
{
    id<OHHTTPStubsDescriptor> stub;
    stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"cctest.camera360.com"]; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with "Hello World!" string
        return [[OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                          code:kCFURLErrorNetworkConnectionLost
                                                                      userInfo:nil]]
            requestTime:0.1 responseTime:0.1];
    }];
    
    // 下面这两行代码是可选的
    stub.name = @"failed stub";
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"[OHHTTPStubs] Request to %@ has been stubbed with %@", request.URL, stub.name);
    }];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://cctest.camera360.com/feed/all"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"get %@, data: %@, err: %@", url, strData, err);
    
    [OHHTTPStubs removeAllStubs];
}

- (void)testA
{
    //[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//    code
//} withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//    code
//}]
}


@end
