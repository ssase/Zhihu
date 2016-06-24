//
//  MyTableViewController.m
//  ZhihuApp
//
//  Created by SASE on 5/31/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import "MyTableViewController.h"
#import "Article.h"
#import "MyTableViewCell.h"
#import "ViewController.h"
#import "ZHJsonParser.h"
#import "TableHeadView.h"

static NSString *lastestNewsListURLString = @"http://news-at.zhihu.com/api/4/news/latest";

@interface MyTableViewController()

@property (nonatomic) NSMutableArray *stories;

@property (nonatomic) id latestNewsObserver;

@end

@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   _latestNewsObserver = [[NSNotificationCenter defaultCenter]
                  addObserverForName:ZHJsonParser.parseNewsList
                  object:nil
                  queue:nil
                  usingBlock:^(NSNotification *notification) {

                      self.stories = [notification.userInfo valueForKey:ZHJsonParser.parseNewsList];
                      //self.tableView.tableHeaderView = _referencedView;
                      //NSLog(@"notification--parseNewsList");

                }];
    
    //headerView...

   // [self.navigationController setNavigationBarHidden:YES];
    //[self.navigationController setStatus
    
    CGRect rect = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen height%frect.origin.y%f",rect.size.height,rect.origin.y);


    
    [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:self options:nil];
    self.tableView.tableHeaderView =_referencedView;
    NSLog(@"viewDidLoad");
    
    //start dowmloading data
    [ZHJsonParser parseJSONDataWithURLString:lastestNewsListURLString Option:ZHJsonParser.parseNewsList];

}

- (void)setStories:(NSMutableArray *)stories
{
    _stories = stories;
    [self.tableView reloadData];
    //NSLog(@"setStories");

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"viewDidAppear");
    
}

#pragma mark - table view load data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"self.storiesMutableArray%lu",(unsigned long)self.storiesMutableArray.count);
    
    return self.stories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"storyCell"];
    
    Article * article = self.stories[indexPath.row];
    
    [cell configueWithArticle:article];
    
    return cell;
        
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //top story how
    
    if ([segue.identifier isEqualToString:@"articleContentSegue"]) {
        
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
            ViewController *doVC = (ViewController *)segue.destinationViewController;
            
            NSIndexPath *tempPath = [self.tableView indexPathForSelectedRow];
            Article * article = self.stories[tempPath.row];
            
            doVC.storyContentURLString = article.articleTextURLString;
        }
    }
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_latestNewsObserver];
    
}

@end

