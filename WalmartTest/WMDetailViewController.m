//
//  WMDetailViewController.m
//  WalmartTest
//
//  Created by Amr Aboelela on 12/8/15.
//  Copyright (c) 2015 Amr Aboelela. All rights reserved.
//

#import "WMMasterViewController.h"
#import "WMDetailViewController.h"

@interface WMDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productDescription;

- (void)updateData;
- (void)setupUI;

@end

@implementation WMDetailViewController

@synthesize products;
@synthesize productTitle;
@synthesize priceLabel;
@synthesize productImage;
@synthesize productDescription;
@synthesize currentProductIndex;

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateData];
    [self setupUI];
}

- (void)viewDidUnload
{
    [self setProductTitle:nil];
    [self setPriceLabel:nil];
    [self setProductImage:nil];
    [self setProductDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Data

- (void)updateData
{
    NSDictionary *product = [self.products objectAtIndex:self.currentProductIndex];
    self.productTitle.text = [product objectForKey:@"productName"];
    self.priceLabel.text = [product objectForKey:@"price"];
    NSData *imageData = [product objectForKey:kImageData];
    if (imageData) {
        [UIView transitionWithView:self.productImage
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.productImage.image = [UIImage imageWithData:imageData];
                        } completion:NULL];
    }
    self.productDescription.text = [product objectForKey:@"shortDescription"];
}

#pragma mark - User interface

- (void)setupUI
{
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeRecognizer];
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
}

#pragma mark - Actions

- (void)rightSwip:(UISwipeGestureRecognizer *)swipeRecognizer
{
    if (self.currentProductIndex > 0) {
        self.currentProductIndex--;
        [self updateData];
    }
}

- (void)leftSwip:(UISwipeGestureRecognizer *)swipeRecognizer
{
    if (self.currentProductIndex < self.products.count-1) {
        self.currentProductIndex++;
        [self updateData];
    }
}

@end
