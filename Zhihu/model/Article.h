//
//  Article.h
//  ZhihuApp
//
//  Created by SASE on 5/31/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Article : UITableViewCell

@property (nonatomic) NSString *articleID;
@property (nonatomic) NSString *articleTitle;

@property (nonatomic) NSString *articleTextURLString;

@property (nonatomic) NSURL    *articleImageURL;
@property (nonatomic) UIImage  *articleImage;
@property (nonatomic) UIImage *articleLargeImage;

@property (nonatomic) NSURL    *articleExtraURL;
@property (nonatomic) NSURL    *articleShortCommentsURL;
@property (nonatomic) NSURL    *articleLongCommentsURL;

//- (void)setArticleImage:(UIImage *)articleImage;

@end
