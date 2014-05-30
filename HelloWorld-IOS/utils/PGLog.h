//
//  PGLog.h
//  HelloWorld-IOS
//
//  Created by liuzhaohui on 14-5-29.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

// 这里定义了一个全局变量ddLogLevel，使用简单
// 也可以在每个需要打印的文件里使用 static const int ddLogLevel; 定义局部变量分别控制
extern int ddLogLevel;
#define PGLogError(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_ERROR,   LOG_LEVEL_DEF, LOG_FLAG_ERROR,   0, frmt, ##__VA_ARGS__)
#define PGLogWarn(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_WARN,    LOG_LEVEL_DEF, LOG_FLAG_WARN,    0, frmt, ##__VA_ARGS__)
#define PGLogInfo(frmt, ...)    LOG_C_MAYBE(LOG_ASYNC_INFO,    LOG_LEVEL_DEF, LOG_FLAG_INFO,    0, frmt, ##__VA_ARGS__)
#define PGLogDebug(frmt, ...)   LOG_C_MAYBE(LOG_ASYNC_DEBUG,   LOG_LEVEL_DEF, LOG_FLAG_DEBUG,   0, frmt, ##__VA_ARGS__)
#define PGLogVerbose(frmt, ...) LOG_C_MAYBE(LOG_ASYNC_VERBOSE, LOG_LEVEL_DEF, LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

@interface PGLog : NSObject
+(void)setUp:(int)logLevel;
@end
