//
//  MyTableViewCell.h
//  ZhihuApp
//
//  Created by SASE on 5/31/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface MyTableViewCell : UITableViewCell

- (void)configueWithArticle:(Article *)article;

@end
