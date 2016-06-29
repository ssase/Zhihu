//
//  MyTableViewCell.m
//  ZhihuApp
//
//  Created by SASE on 5/31/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Article.h"

@interface MyTableViewCell()

@property (nonatomic) UILabel *articleTitleLabel;
@property (nonatomic) UIImageView *articleImageView;

@end

@implementation MyTableViewCell

- (void)configueWithArticle:(Article *)article
{
    if (![self.contentView.subviews lastObject]) {
        
        _articleImageView = [[UIImageView alloc]init];

        _articleTitleLabel = [[UILabel alloc]init];
        _articleTitleLabel.numberOfLines = 2;
        _articleTitleLabel.lineBreakMode =  NSLineBreakByCharWrapping;

        [self.contentView addSubview:_articleTitleLabel];
        [self.contentView addSubview:_articleImageView];

        //添加两个subview的约束
        [self constrainSubview:_articleTitleLabel andSecondSubview:_articleImageView toMatchWithSuperview:self.contentView];
    }
    
    _articleTitleLabel.text = article.articleTitle;
    _articleImageView.image = article.articleImage;
    
}

//constraints
- (void)constrainSubview:(UIView *)subview andSecondSubview:(UIView *)secondSubview toMatchWithSuperview:(UIView *)superview
{
    CGRect screenRect = [ UIScreen mainScreen ].bounds;
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    secondSubview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(subview,secondSubview);
    NSDictionary *secondViewsDictionary = NSDictionaryOfVariableBindings(subview,secondSubview);
    
    NSString *horizontalDistance;
    NSString *verticalDistance;
    NSString *secondHorizontalDistance;
    NSString *secondVerticalDistance;
    
    horizontalDistance = [NSString stringWithFormat:@"H:|-8-[subview]-%f-|",CGRectGetWidth(screenRect)/4];
    
    verticalDistance = [NSString stringWithFormat:@"V:|-8-[subview]-8-|"];
    
    secondHorizontalDistance = [NSString stringWithFormat:@"H:[subview]-10-[secondSubview]-8-|"];
    secondVerticalDistance = [NSString stringWithFormat:@"V:|-8-[secondSubview]-8-|"];
        
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:horizontalDistance
                                      options:0
                                      metrics:nil
                                      views:viewsDictionary];
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:verticalDistance
                                    options:0
                                    metrics:nil
                                    views:viewsDictionary];
    
    NSArray *secondHorizontalConstraints = [NSLayoutConstraint
                                        constraintsWithVisualFormat:secondHorizontalDistance
                                        options:0
                                        metrics:nil
                                        views:secondViewsDictionary];
    
    NSArray *secondVerticalConstraints = [NSLayoutConstraint
                                          constraintsWithVisualFormat:secondVerticalDistance
                                          options:0
                                          metrics:nil
                                          views:secondViewsDictionary];
    
    [superview addConstraints:horizontalConstraints];
    [superview addConstraints:verticalConstraints];
    [superview addConstraints:secondHorizontalConstraints];
    [superview addConstraints:secondVerticalConstraints];
    
}



@end
