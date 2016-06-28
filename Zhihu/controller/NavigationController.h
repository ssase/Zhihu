//
//  NavigationController.h
//  Zhihu
//
//  Created by SASE on 6/28/16.
//  Copyright © 2016 SASE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController  <UIGestureRecognizerDelegate>

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL canDragBack;

@end
