//
//  InAppHandlerMethods.m
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 07/03/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import "InAppHandlerMethods.h"
#import "InAppProduct.h"
#import "Constants.h"
#import "Utils.h"

@implementation InAppHandlerMethods{
    
    InAppProduct *product;
    NSMutableArray *listOfProducts;
    UIAlertView *alertView;
    NSDateFormatter *dateFormat;
    NSString *transactionDate;
    NSString *transactionID;
    NSString *statusString;
    NSMutableDictionary *purchasedDeatails;
}

#define PURCHASE_CONSTANT @"PURCHASED"
#define FAILED_CONSTANT @"FAILED"
#define UNKNOWN_CONSTANT @"UNKNOWN"

#pragma mark - REQUEST FOR PRODUCTS

-(void)retrivingProductsInformation:(NSArray *)nameOfProducts andView:(UIView *)view{
    
    if([Utils isInternetAvailable]){
        
        // Parse it to NSSet
        NSSet *productIdSet = [NSSet setWithArray:nameOfProducts];
        listOfProducts= [[NSMutableArray alloc]init];
        
        [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        [[RMStore defaultStore] requestProducts:productIdSet success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            
            for(SKProduct *productObject in products)
            {
                
                //Fill Model
                product = [[InAppProduct alloc]init];
                
                product.productName = productObject.localizedTitle;
                product.productDescription = productObject.localizedDescription;
                product.productPrice = [RMStore localizedPriceOfProduct:productObject];
                product.productID = productObject.productIdentifier;
                product.productLocale = productObject.priceLocale;
                
                [listOfProducts addObject:product];
            }
            
            [MBProgressHUD hideHUDForView:view animated:YES];
            
            [self.delagate retrivingInAppProductsCompleted:listOfProducts];
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
            
            [self.delagate retrivingInAppProductsFailed:error];
        }];
    }
    else{
        // No Internet
    }
    
}

#pragma mark - PURCHASE PRODUCT

-(void)requestingInAppProductPayment:(NSString *)productId andView:(UIView *)view{
    
    if([Utils isInternetAvailable])
    {
        
        
        // Show Progress Bar
        [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
            // Hide Progress Bar
            [MBProgressHUD hideHUDForView:view animated:YES];
            [self logPurchasedData:transaction andproductID:productId];
            
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
            
            // Something Went Wrong
            alertView =[[UIAlertView alloc] initWithTitle:PURCHASE_ERROR message:@"" delegate:self cancelButtonTitle:POSITIVE_BUTTON otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
    }
    else{
        //No Internet
    }
    
}

#pragma mark - RESTORE PRODUCTS

-(void)restoreAlreadyPurchsedProductsWithView:(UIView *)view{
    
    if([Utils isInternetAvailable]){
        
        
        [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
            NSLog(@"Transactions restored");
            [MBProgressHUD hideHUDForView:view animated:YES];
            
            for(SKPaymentTransaction *product in transactions){
                NSLog(@"Restored Product : %@ \n",[[product payment] productIdentifier]);
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:view animated:YES];
            NSLog(@"Something went wrong");
        }];
    }
    else{
        // No Intrenet
    }
    
}

//-(void)purchaseSingleProduct:(NSString *)productId andView:(UIView *)view{
//    
//    [MBProgressHUD showHUDAddedTo:view animated:YES];
//    
//    [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
//        [MBProgressHUD hideHUDForView:view animated:YES];
//        
//        [self logPurchasedData:transaction andproductID:productId];
//        
//    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
//        
//        [MBProgressHUD hideHUDForView:view animated:YES];
//        
//        [self logPurchasedData:transaction andproductID:productId];
//    }];
//    
//}
#pragma mark - TRANSACTION DETAILS

-(void)logPurchasedData:(SKPaymentTransaction *)transaction andproductID:(NSString *)productId{
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    if(transaction){
        transactionDate= [dateFormat  stringFromDate:transaction.transactionDate];
        transactionID = transaction.transactionIdentifier;
    }
    else{
        transactionDate = [dateFormat  stringFromDate:[NSDate date]];
        transactionID = @"";
    }
    
    SKPaymentTransactionState state = transaction.transactionState;
    // Status Check
    if (state == SKPaymentTransactionStatePurchased)
    {
        statusString = PURCHASE_CONSTANT;
    }
    else if (state == SKPaymentTransactionStateFailed){
        statusString = FAILED_CONSTANT;
    }
    else{
        statusString = UNKNOWN_CONSTANT;
    }
    
    
    // Fill Dictionary
    purchasedDeatails = [[NSMutableDictionary alloc]init];
    [purchasedDeatails setObject:transactionDate forKey:@"transactionDate"];
    [purchasedDeatails setObject:transactionID forKey:@"tracnsactionID"];
    [purchasedDeatails setObject:productId forKey:@"transactionProductID"];
    [purchasedDeatails setObject:statusString forKey:@"transactionState"];
    
    // Check State and Call Respective Delegate Methods.
    [self checkStateOfTransaction:purchasedDeatails andState:statusString];
}

#pragma mark - DECISION PURCHASE STATE

-(void)checkStateOfTransaction:(NSMutableDictionary *)loggedData andState:(NSString *)state{
    
    if([state isEqualToString:PURCHASE_CONSTANT])
    {
        
        // On Successfull Purchase
        [self.delagate purchaseInAppproductCompleted:loggedData];
    }
    else
    {
        // On Failed Purchase
        [self.delagate purchaseInAppProductFailed:loggedData];
    }
}

@end
