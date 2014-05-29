//
//  PGLogFormatter.m
//  HelloWorld-IOS
//
//  Created by liuzhaohui on 14-5-29.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import "PGLogFormatter.h"

@implementation PGLogFormatter

-(id)init
{
    if (self = [super init]) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [threadUnsafeDateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss:SSS"];
    }
    return self;
}

// implement protocol
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *loglevel;
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR:    loglevel = @"E"; break;
        case LOG_FLAG_WARN:    loglevel = @"W"; break;
        case LOG_FLAG_INFO:    loglevel = @"I"; break;
        case LOG_FLAG_DEBUG:    loglevel = @"D"; break;
        default:                loglevel = @"V"; break;
    }
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->timestamp)];
    NSString *logMsg = logMessage->logMsg;
    
    return [NSString stringWithFormat:@"%@ %@ %d %s %@", loglevel, dateAndTime,
            logMessage->lineNumber, logMessage->function,
            logMsg];
}

@end
