//
//  WMMasterViewController.m
//  WalmartTest
//
//  Created by Amr Aboelela on 12/8/15.
//  Copyright (c) 2015 Amr Aboelela. All rights reserved.
//

#import "WMMasterViewController.h"
#import "WMDetailViewController.h"
#import "WMProductCell.h"

#define ProductCellIdentifier   @"ProductCell"

@interface WMMasterViewController ()

@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (assign, nonatomic) int currentPageNumber;

- (void)setupData;
- (void)loadNextPage;

@end

@implementation WMMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize products;
@synthesize receivedData;
@synthesize currentPageNumber;
//@synthesize selectedRow;

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMProductCell" bundle:nil] forCellReuseIdentifier:ProductCellIdentifier];
    [self setupData];
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

- (void)setupData
{
    self.products = [NSMutableArray arrayWithCapacity:100];
    self.currentPageNumber = 1;
    [self loadNextPage];
}

#pragma mark - Network calls

- (void)loadNextPage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://walmartlabs-test.appspot.com/_ah/api/walmart/v1/walmartproducts/06076dd0-8675-4616-a46b-a609488e3710/%d/20", self.currentPageNumber++]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    self.receivedData = [NSMutableData dataWithCapacity:1000];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData");
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"dataString: %@", dataString);
    [self.receivedData appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"dataString: %@", [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];
    if (error) {
        //NSLog(@"error: %@", error);
        //NSString *dataString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        //NSLog(@"dataString: %@", [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
        return;
    }
    for (NSMutableDictionary *product in [responseDictionary objectForKey:@"products"]) {
        [self.products addObject:product];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[product objectForKey:@"productImage"]]];
            [product setObject:imageData forKey:kImageData];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
            });
        });
    }
    [self.tableView reloadData];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];

    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    cell.productLabel.text = [product objectForKey:@"productName"];
    cell.priceLabel.text = [product objectForKey:@"price"];
    NSData *imageData = [product objectForKey:kImageData];
    if (imageData) {
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    if (indexPath.row > self.products.count - 10) {
        [self loadNextPage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"productDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WMDetailViewController class]]) {
        WMDetailViewController *vc = segue.destinationViewController;
        vc.products = self.products; // objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        vc.currentProductIndex = [self.tableView indexPathForSelectedRow].row;
    }
}

@end

