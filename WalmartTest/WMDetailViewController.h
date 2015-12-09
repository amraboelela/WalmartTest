//
//  WMDetailViewController.h
//  WalmartTest
//
//  Created by Amr Aboelela on 12/8/15.
//  Copyright (c) 2015 Amr Aboelela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMDetailViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *products;
@property (assign, nonatomic) int currentProductIndex;

@end
