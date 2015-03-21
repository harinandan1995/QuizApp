//
//  GlobalFn.h
//  Officecat
//
//  Created by Harinandan Teja on 9/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalFn : NSObject

+ (void)jsonRequestWithBaseURL:(NSString *)baseURL function:(NSString *)function parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *json, BOOL success))completion;
+ (void)GetRequestWithBaseURL:(NSString *)baseURL function:(NSString *)function parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *json, BOOL success))completion;

+ (UIColor *)getColor:(NSInteger)string;
+ (UIColor*)colorWithHexString:(NSString*)hex;

@end
