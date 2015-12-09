//
//  WMMasterViewController.h
//  WalmartTest
//
//  Created by Amr Aboelela on 12/8/15.
//  Copyright (c) 2015 Amr Aboelela. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMDetailViewController;

#define kImageData              @"ImageData"

@interface WMMasterViewController : UITableViewController

@property (strong, nonatomic) WMDetailViewController *detailViewController;

@end
