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
    self.tableView.tableHeaderView =[[TableHeadView alloc]init];
    NSLog(@"viewDidLoad");
    
    //start dowmloading data
    [ZHJsonParser parseJSONDataWithURLString:lastestNewsListURLString Option:ZHJsonParser.parseNewsList];

    //let navigation bar transparent and table header view on the top
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //initialize a left bar button
    UIBarButtonItem *naviBarButon = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"≡", @"")
                              style:UIBarButtonItemStylePlain
                             target:self
                             action:@selector(naviBarButonAction:)];
    naviBarButon.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = naviBarButon;

//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
//    NSDictionary *attrsDictionary =
//    [NSDictionary dictionaryWithObject:font
//                                forKey:NSFontAttributeName];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:attrsDictionary forState:UIControlStateNormal];

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

- (IBAction)naviBarButonAction:(UIBarButtonItem *)sender {
    NSLog(@"naviBarButonAction:");
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

