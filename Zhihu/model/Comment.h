//
//  Comment.h
//  ZhihuApp
//
//  Created by SASE on 6/17/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Comment : NSObject

@property (nonatomic) NSString *author;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *likes;
//improve to a NSDate is a strange time
@property (nonatomic) NSString *time;
@property (nonatomic) UIImage *avatar;

@property (nonatomic) NSArray *replyTo;

@end
