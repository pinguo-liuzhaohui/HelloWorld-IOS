//
//  PGLog.m
//  HelloWorld-IOS
//
//  Created by liuzhaohui on 14-5-29.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import "PGLog.h"

#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "PGLogFormatter.h"
#import "DDFileLogger.h"

int ddLogLevel = LOG_LEVEL_WARN;

@implementation PGLog

+(void)setUp:(int)logLevel
{
    // 使用 asl+tty 或者 file+tty
    id<DDLogger> ttyLogger = [DDTTYLogger sharedInstance];
    id<DDLogger> fileLogger = [[DDFileLogger alloc] init];
    [ttyLogger setLogFormatter:[[PGLogFormatter alloc] init]];
    [fileLogger setLogFormatter:[[PGLogFormatter alloc] init]];
    [DDLog addLogger:ttyLogger]; // tty
    [DDLog addLogger:fileLogger]; // file
    //[DDLog addLogger:[DDASLLogger sharedInstance]]; // apple system logger
    ddLogLevel = logLevel;
    
    NSString *logDir = [[(DDFileLogger*)fileLogger logFileManager] logsDirectory];
    
    PGLogInfo(@"init loglevel: %d, log dir: %@", ddLogLevel, [[logDir mutableCopy] stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]);
}
@end
