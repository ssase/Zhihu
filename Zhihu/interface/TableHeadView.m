//
//  TableHeadView.m
//  GoodsSearcher
//
//  Created by SASE on 6/22/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#define TableHeaderViewOriginY -20

#import "TableHeadView.h"
#import "ZHJsonParser.h"
#import "Article.h"

@interface TableHeadView ()

@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) id topStoriesObserver;
@property (nonatomic) NSMutableArray *topStories;
@property (nonatomic) NSMutableArray *storyImageViews;
@property (nonatomic) NSMutableArray *titleLabels;

@end

@implementation TableHeadView


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //initialize the header view
        CGRect Vrect = [TableHeadView getHeaderViewFrame];
        Vrect.origin.y = TableHeaderViewOriginY;
        self.frame = Vrect;

        CGRect rect = [TableHeadView getHeaderViewFrame];
        _scrollView = [[UIScrollView alloc]initWithFrame:rect];
        _pageControl = [[UIPageControl alloc]init];
        
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        //self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        self.scrollView.contentSize =rect.size;
        
        [self addSubview:_pageControl];
        NSString *horizontalDistance = [NSString stringWithFormat:@"H:|-%f-[subview]-%f-|",CGRectGetWidth(rect)/3,CGRectGetWidth(rect)/3];
        NSString *verticalDistance = [NSString stringWithFormat:@"V:[subview(40)]|"];
        [self constrainSubview:_pageControl toMatchWithSuperview:self WithHorizontalFormatString:horizontalDistance verticalFormatString:verticalDistance];
        
        //[self insertSubview:_scrollView belowSubview:_topLabel];
        [self addSubview:_scrollView];
        [self sendSubviewToBack:_scrollView];

        _topStoriesObserver = [[NSNotificationCenter defaultCenter]
               addObserverForName:ZHJsonParser.parseTopNewsList
               object:nil
               queue:nil
               usingBlock:^(NSNotification *notification) {
                   
                   self.topStories = [notification.userInfo valueForKey:ZHJsonParser.parseTopNewsList];
                   
                   //deal with data
                   
                   NSUInteger numberPages = self.topStories.count;
                   
                   // in the meantime, load the array with placeholders which will be replaced on demand
                   NSMutableArray *imageViews = [[NSMutableArray alloc] init];
                   for (NSUInteger i = 0; i < numberPages; i++) {
                       [imageViews addObject:[NSNull null]];
                   }
                   self.storyImageViews = imageViews;

                   NSMutableArray *labels = [[NSMutableArray alloc] init];
                   for (NSUInteger i = 0; i < numberPages; i++) {
                       [labels addObject:[NSNull null]];
                   }
                   self.titleLabels = labels;
                   
                   CGSize tempRect = self.scrollView.contentSize;
                   tempRect.width *= numberPages;
                   self.scrollView.contentSize = tempRect;
                   
                   self.pageControl.numberOfPages = numberPages;
                   self.pageControl.currentPage = 0;
                   
                   // pages are created on demand
                   // load the visible page
                   // load the page on either side to avoid flashes when the user starts scrolling
                   //
                   [self loadScrollViewWithPage:0];
                   [self loadScrollViewWithPage:1];
                   [self loadScrollViewWithPage:2];

               }];
        
        NSLog(@"initWithCoder");
        
        
    }
    return self;
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    //extra? 
    if (page >= _topStories.count)
        return;
    
    // replace the placeholder if necessary
    UIImageView *imageView = [self.storyImageViews objectAtIndex:page];
    UILabel *label = [self.titleLabels objectAtIndex:page];

    Article *article = _topStories[page];

    //image
    if ((NSNull *)imageView == [NSNull null]) {
        
        imageView = [[UIImageView alloc]initWithImage:article.articleLargeImage];
        
        [_storyImageViews replaceObjectAtIndex:page withObject:imageView];
        
    }
    
    //title
    if ((NSNull *)label == [NSNull null]) {
        
        label = [[UILabel alloc]init];
        
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        label.lineBreakMode =  NSLineBreakByCharWrapping;

        [_titleLabels replaceObjectAtIndex:page withObject:label];
        
    }


    if (imageView.superview == nil) {
        CGRect frame = [TableHeadView getHeaderViewFrame];

        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        
        [_scrollView addSubview:imageView];
        
    }
    
    if (label.superview == nil) {
        CGRect frame = [TableHeadView getHeaderViewFrame];
        
        frame.origin.x = CGRectGetWidth(frame) * page + 10;
        frame.size.width -= 10;
        frame.origin.y = frame.size.height/3.5;
        
        //frame.size.height = 40;
        label.frame = frame;
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        NSDictionary *attrsDictionary =
        [NSDictionary dictionaryWithObject:font
                                    forKey:NSFontAttributeName];
        NSAttributedString *attrString =
        [[NSAttributedString alloc] initWithString:article.articleTitle
                                        attributes:attrsDictionary];
        label.attributedText = attrString;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0, -0.5);
        //label.tintColor = [UIColor whiteColor];
        [_scrollView addSubview:label];

    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGRect rect = [TableHeadView getHeaderViewFrame];

    CGFloat pageWidth = CGRectGetWidth(rect);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    NSLog(@"pageWidth%f",pageWidth);
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    [self loadScrollViewWithPage:page + 2];

}


- (IBAction)pageControlAction:(UIPageControl *)sender
{
    
    NSLog(@"pageControlAction");
    
}

//constraints
- (void)constrainSubview:(UIView *)subview toMatchWithSuperview:(UIView *)superview WithHorizontalFormatString:(NSString *)HString verticalFormatString:(NSString *)VString
{
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(subview);
        
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:HString
                                      options:0
                                      metrics:nil
                                      views:viewsDictionary];
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:VString
                                    options:0
                                    metrics:nil
                                    views:viewsDictionary];
    
    [superview addConstraints:horizontalConstraints];
    [superview addConstraints:verticalConstraints];
    
}



+ (CGRect)getHeaderViewFrame
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //rect.origin.y -= 20;
    
    rect.size.height = rect.size.width/1.7;
    return rect;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_topStoriesObserver];
    
}
@end
