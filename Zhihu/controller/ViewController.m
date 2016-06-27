//
//  ViewController.m
//  ZhihuApp
//
//  Created by SASE on 5/31/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import "ViewController.h"
#import "ZHJsonParser.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *storyContentWebView;
@property (nonatomic) NSString *HTMLString;
@property (nonatomic) id storyContentObserver;

@end

@implementation ViewController


//这里用来展现知乎具体文章内容，还在进行中
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    CGRect frame = self.storyContentWebView.frame;
//    frame.origin.y -= 20;
//    self.storyContentWebView.frame = frame;
    
    _storyContentObserver = [[NSNotificationCenter defaultCenter]
               addObserverForName:ZHJsonParser.parseNewsContents
               object:nil
               queue:nil
               usingBlock:^(NSNotification *notification) {
                   self.HTMLString = [notification.userInfo valueForKey:ZHJsonParser.parseNewsContents];
               }];

   // _navigationItem = nil;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //hide the back button
    self.navigationItem.hidesBackButton = YES;

    //self.navigationController.navigationBar.backItem
    //remove the back item
//    [self.navigationItem setImage:[UIImage imageNamed:@"LeftButton_back_Icon"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [ZHJsonParser parseJSONDataWithURLString:_storyContentURLString Option:ZHJsonParser.parseNewsContents];
}

- (void)setHTMLString:(NSString *)HTMLString
{
    
    _HTMLString = HTMLString;
    
    [self.storyContentWebView loadHTMLString:self.HTMLString baseURL:nil];//加载

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_storyContentObserver];
    
}

@end
