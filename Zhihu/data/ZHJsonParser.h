//
//  ZHJsonParser.h
//  ZhihuApp
//
//  Created by SASE on 6/1/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHJsonParser : NSObject

+ (NSString *)parseNewsList;
+ (NSString *)parseTopNewsList;
+ (NSString *)parseNewsContents;

+ (NSString *)parseStoryExtra;
+ (NSString *)parseStoryLongcomments;
+ (NSString *)parseStoryShortcomments;

+ (NSString *)parseThemesList;
+ (NSString *)parseThemesContents;

//main function
+ (void)parseJSONDataWithURLString:(NSString *)URLString Option:(NSString *)option;

@end
