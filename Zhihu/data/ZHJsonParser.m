//
//  ZHJsonParser.m
//  ZhihuApp
//
//  Created by SASE on 6/1/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import "ZHJsonParser.h"
#import "Article.h"
#import "Comment.h"

static NSString *extraURLString = @"http://news-at.zhihu.com/api/4/story-extra/";
static NSString *longCommentsURLString = @"http://news-at.zhihu.com/api/4/story/%@/long-comments";
static NSString *shortCommentsURLString = @"http://news-at.zhihu.com/api/4/story/%@/short-comments";
static NSString *articleTextURLHeadString = @"http://news-at.zhihu.com/api/4/news/";

static NSString *baseHTMLString = @"<!DOCTYPE html><html><head lang=\"zh\"><meta charset=\"UTF-8\"><link  rel=\"stylesheet\" type=\"text/css\" href=%@></head><body>%@</body></html>";

//用来封装Json Parser，进行数据处理，还在完成中


@interface ZHJsonParser ()


@end

@implementation ZHJsonParser

#pragma mark - some strings

+ (NSString *)parseNewsList
{
    return @"parseNewsList";
}

+ (NSString *)parseTopNewsList{
    return @"parseTopNewsList";
}

+ (NSString *)parseNewsContents
{
    return @"parseNewsContents";
}

+ (NSString *)parseStoryExtra
{
    return @"parseStoryExtra";
}
+ (NSString *)parseStoryLongcomments
{
    return @"parseStoryLongComits";
}
+ (NSString *)parseStoryShortcomments
{
    return @"parseStoryShortcomments";
}

+ (NSString *)parseThemesList
{
    return @"parseThemesList";
}
+ (NSString *)parseThemesContents
{
    return @"parseThemesContents";
}


#pragma mark - parse JSON data

+ (void)parseJSONDataWithURLString:(NSString *)URLString Option:(NSString *)option
{
    
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    // create an session data task to obtain and download the app icon
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           
           [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
               
               // back on the main thread, check for errors, if no errors start the parsing
               //
               if (error != nil && response == nil) {
                   if (error.code == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                       
                       // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                       // then your Info.plist has not been properly configured to match the target server.
                       //
                       NSAssert(NO, @"NSURLErrorAppTransportSecurityRequiresSecureConnection");
                   }
                   else {
                       // use KVO to notify our client of this error
//                       [self willChangeValueForKey:@"error"];
//                       self.error = error;
//                       [self didChangeValueForKey:@"error"];
                   }
               }
               
               // here we check for any returned NSError from the server,
               // "and" we also check for any http response errors check for any response errors
               if (response != nil) {
                   
                   [[NSOperationQueue new]addOperationWithBlock:^() {
                       
                       NSDictionary *tempContentDic = [ZHJsonParser parseJSONWithdata:data];
                       
                       if ([option isEqualToString:ZHJsonParser.parseNewsList]) {
                           //news list
                           [ZHJsonParser parseNewsListWithDictionary:tempContentDic Option:option];
                       
                       }else if ([option isEqualToString:ZHJsonParser.parseNewsContents]) {
                           
                           NSArray *CSSArray = [tempContentDic valueForKey:@"css"];
                           
                           NSString *HTMLString = [NSString stringWithFormat:baseHTMLString,CSSArray[0],[tempContentDic valueForKey:@"body"]];
                           //story content
                           [ZHJsonParser postNotificationWithMessage:HTMLString Option:option];
                           
                       }else if ([option isEqualToString:ZHJsonParser.parseStoryExtra]) {
                           //news extra
                           [ZHJsonParser postNotificationWithMessage:tempContentDic Option:option];
                           
                       }else if ([option isEqualToString:ZHJsonParser.parseStoryLongcomments]) {
                           //story long comments
                           [ZHJsonParser parseCommentsListWithDictionary:tempContentDic Option:option];
                           
                       }else if ([option isEqualToString:ZHJsonParser.parseStoryShortcomments]) {
                           //story short comments
                           [ZHJsonParser parseCommentsListWithDictionary:tempContentDic Option:option];

                       }else if ([option isEqualToString:ZHJsonParser.parseThemesList]) {
                           //themes list
                           
                       }else if ([option isEqualToString:ZHJsonParser.parseThemesContents]) {
                           //theme content
                           
                       }
                       
                       
                       //other options
                       
                       
                   }];
//                   else {
////                       NSString *errorString =
////                       NSLocalizedString(@"HTTP Error", @"Error message displayed when receiving an error from the server.");
////                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorString};
////                       
////                       // use KVO to notify our client of this error
////                       [self willChangeValueForKey:@"error"];
////                       self.error = [NSError errorWithDomain:@"HTTP"
////                                                        code:httpResponse.statusCode
////                                                    userInfo:userInfo];
////                       [self didChangeValueForKey:@"error"];
//                   }
               }
           }];
       }];
    
    [sessionTask resume];

}


#pragma mark - basic actions
//needs notification
+ (void) parseNewsListWithDictionary:(NSDictionary *)dic Option:(NSString *)option

{
    //top_stories
    
    if (!dic) {
        //deal with the nil dic
    }
    
    NSMutableArray *articles = [[NSMutableArray alloc]init];

    NSArray *stories = dic[@"stories"];
    NSArray *topStories = dic[@"top_stories"];
    
    if (topStories) {
        
        NSMutableArray *topArticles = [[NSMutableArray alloc]init];
        
        for (NSDictionary *tempDic in topStories) {
            
            Article * article = [[Article alloc]init];
            
            //id
            NSNumber *tempID = [tempDic valueForKey:@"id"];
            article.articleID = [NSString stringWithFormat:@"%@",tempID];
            
            //title
            article.articleTitle = [tempDic valueForKey:@"title"];
            
            //image
            NSData *tempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tempDic valueForKey:@"image"]]];
            if (!tempData) {
                //deal with the nil tempData
                //return nil;
            }
            article.articleLargeImage = [UIImage imageWithData:tempData];
            
            //text
            article.articleTextURLString = [articleTextURLHeadString stringByAppendingString:article.articleID];
            
            [topArticles addObject:article];
        }
        
        [ZHJsonParser postNotificationWithMessage:topArticles Option:ZHJsonParser.parseTopNewsList];
        
    }
    
    for (NSDictionary *tempDic in stories) {
        
        Article * article = [[Article alloc]init];
        
        //id
        NSNumber *tempID = [tempDic valueForKey:@"id"];
        article.articleID = [NSString stringWithFormat:@"%@",tempID];
        
        //title
        article.articleTitle = [tempDic valueForKey:@"title"];
        
        //imageURL
        NSArray *imageArray =[[NSArray alloc]init];
        imageArray = [tempDic valueForKey:@"images"];
        article.articleImageURL = [NSURL URLWithString:imageArray[0]];
        
        //image
        NSData *tempData = [NSData dataWithContentsOfURL:article.articleImageURL];
        if (!tempData) {
            //deal with the nil tempData
            //return nil;
        }
        article.articleImage = [UIImage imageWithData:tempData];
        
        //text
        article.articleTextURLString = [articleTextURLHeadString stringByAppendingString:article.articleID];
        
        //comments
        article.articleExtraURL = [NSURL URLWithString:[extraURLString stringByAppendingString:article.articleTitle]];
        article.articleLongCommentsURL = [NSURL URLWithString:[NSString stringWithFormat:longCommentsURLString,article.articleTitle]];
        article.articleShortCommentsURL = [NSURL URLWithString:[NSString stringWithFormat:shortCommentsURLString,article.articleTitle]];
        
        [articles addObject:article];
        
        [ZHJsonParser postNotificationWithMessage:articles Option:option];

    }
    
}

+ (void) parseCommentsListWithDictionary:(NSDictionary *)dic Option:(NSString *)option

{
    //top_stories
    
    if (!dic) {
        //deal with the nil dic
    }
    
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    NSArray *stories = dic[@"comments"];
    
    for (NSDictionary *tempDic in stories) {
        
        Comment * comment = [[Comment alloc]init];
        
        //author
        comment.author = [tempDic valueForKey:@"author"];
        
        //content
        comment.content = [tempDic valueForKey:@"content"];
        
        //avatar
        //together makes mistakes
        comment.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tempDic valueForKey:@"avatar"]]]];
        
        //likes
        comment.likes = [tempDic valueForKey:@"likes"];

        //reply_to
        NSDictionary *RTDic = [tempDic valueForKey:@"reply_to"];
        NSString *RTauthor = [RTDic valueForKey:@"author"];
        NSString *RTcontent = [RTDic valueForKey:@"content"];
        comment.replyTo = [NSArray arrayWithObjects:RTauthor,RTcontent, nil];

        [comments addObject:comment];
        
    }
    
    [ZHJsonParser postNotificationWithMessage:comments Option:option];

}

//parse JSON data to be a NSDictionary
+ (NSDictionary *)parseJSONWithdata:(NSData *)data
{
    NSError *error;
    
    NSDictionary *tempArticleDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        
        //deal with the error
        return nil;
    }
    
    return tempArticleDic;
}

//post notification
+ (void)postNotificationWithMessage:(id)message Option:(NSString *)option
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:option object:self userInfo:@{option:message}];
    });
}
@end
