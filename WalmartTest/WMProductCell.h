//
//  WMProductCell.h
//  WalmartTest
//
//  Created by Amr Aboelela on 12/8/15.
//  Copyright (c) 2015 Amr Aboelela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *productLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
