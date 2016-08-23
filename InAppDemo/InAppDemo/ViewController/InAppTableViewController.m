//
//  InAppTableViewController.m
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 29/02/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import "InAppTableViewController.h"
#import "RMStore.h"
#import "InAppProduct.h"
#import "MBProgressHUD.h"
#import "InAppHandlerMethods.h"
#import "Constants.h"

// Cell UITableViewCell
#define CELL_IDENTIFER @"InAppProductIdentifer"

@interface InAppTableViewController ()<RMStoreObserver, InAppDelegates>

@end

@implementation InAppTableViewController{
    
    IBOutlet UITableView *productListTableView;
    NSArray *productsName;
    NSMutableArray *arrayOfInAppProductsObject;
    InAppHandlerMethods *inAppHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self intializeObjects];
    
    /*
     productsName = [[NSArray alloc] initWithObjects:
     pricing_day,
     pricing_week,
     pricing_month,
     pricing_year,
     nil];
     */
    
    //Delagate Callbacks
    inAppHandler.delagate = self;
    
    productsName = [[NSArray alloc] initWithObjects:
                    silverPlan,
                    goldPlan,
                    freeCoins,
                    nil];
    
    [self requestForInAppProducts];
    
    
}


-(void)intializeObjects{
    arrayOfInAppProductsObject = [[NSMutableArray alloc]init];
    inAppHandler = [InAppHandlerMethods new];
}

#pragma mark InApp Initializer Methods

-(void)requestForInAppProducts{
    
    [inAppHandler retrivingProductsInformation:productsName andView:self.view];
}

// Selected Product From List
-(void)choosenInAppProduct:(NSIndexPath *)indexPath{
    
    NSString *selectedProductId = [[arrayOfInAppProductsObject objectAtIndex:indexPath.row] productID];
    
    // Pay for Product
    [inAppHandler requestingInAppProductPayment:selectedProductId andView:self.view];
    
}

#pragma mark - Table Delaget Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayOfInAppProductsObject.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFER forIndexPath:indexPath];
    
    cell.textLabel.text = [[arrayOfInAppProductsObject objectAtIndex:indexPath.row] productName];
    cell.detailTextLabel.text = [[arrayOfInAppProductsObject objectAtIndex:indexPath.row] productDescription];
    ;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Choose Product
    [self choosenInAppProduct:indexPath];
}

#pragma mark - InApp Handler Delegate Methods

-(void)retrivingInAppProductsCompleted:(NSMutableArray *)products{
    
    // Successfully Collected InApp Products
    arrayOfInAppProductsObject = products;
    [productListTableView reloadData];
}

-(void)retrivingInAppProductsFailed:(NSError *)error{
    
    // There is Some Error in iTunes.
}

-(void)purchaseInAppproductCompleted:(NSMutableDictionary *)transactionDetails{
    // On Successfull Purchase
    NSLog(@"---- %@", transactionDetails);
    
}

-(void)purchaseInAppProductFailed:(NSMutableDictionary *)transactionDetails{
    // On Failed Purchase
    NSLog(@"---- %@", transactionDetails);
}

@end
