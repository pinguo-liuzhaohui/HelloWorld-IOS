//
//  PGLogFormatter.h
//  HelloWorld-IOS
//
//  Created by liuzhaohui on 14-5-29.
//  Copyright (c) 2014年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface PGLogFormatter : NSObject<DDLogFormatter>
{
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end
