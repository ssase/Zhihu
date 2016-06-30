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
@property (nonatomic) UIView *topView;

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

                }];
    
    //headerView...
    self.tableView.tableHeaderView =[[TableHeadView alloc]init];
    NSLog(@"viewDidLoad");
    
    //start dowmloading data
    [ZHJsonParser parseJSONDataWithURLString:lastestNewsListURLString Option:ZHJsonParser.parseNewsList];

    self.automaticallyAdjustsScrollViewInsets = false;
   
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
    
    //used to change the status bar's background color
    CGRect rect = [TableHeadView getHeaderViewFrame];
    rect.origin.y = -20;
    rect.size.height = 20;
    self.topView = [[UIView alloc]initWithFrame:rect];
    [self.navigationController.navigationBar addSubview:_topView];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self setNeedsStatusBarAppearanceUpdate];

    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    NSLog(@"preferredStatusBarStyle");
//    return UIStatusBarStyleLightContent;
//}


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


# pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITableView *tableView = object;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        float colorAlpha = tableView.contentOffset.y/[TableHeadView getHeaderViewFrame].size.height;
        
        [self changeTopBarBackGroundColorAlpha:colorAlpha];
            
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)changeTopBarBackGroundColorAlpha:(float)colorAlpha
{
    UIColor *color = [UIColor colorWithRed:81.0/255.0 green:167.0/255.0 blue:1 alpha:colorAlpha];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController.navigationBar setBackgroundColor:color];
        [_topView setBackgroundColor:color];
        
    });
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_latestNewsObserver];
    
}

@end

