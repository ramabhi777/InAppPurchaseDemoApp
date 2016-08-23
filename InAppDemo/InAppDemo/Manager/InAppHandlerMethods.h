//
//  InAppHandlerMethods.h
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 07/03/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMStore.h"
#import "MBProgressHUD.h"

@protocol InAppDelegates <NSObject>

@optional

// REQUEST
-(void)retrivingInAppProductsCompleted:(NSMutableArray *)products;
-(void)retrivingInAppProductsFailed:(NSError *)error;

// PURCAHSE & LOG.
-(void)purchaseInAppproductCompleted:(NSMutableDictionary *)transactionDetails;
-(void)purchaseInAppProductFailed:(NSMutableDictionary *)transactionDetails;

@end

@interface InAppHandlerMethods : NSObject
@property (weak, nonatomic) id<InAppDelegates> delagate;

// Methods
-(void)retrivingProductsInformation:(NSArray *)nameOfProducts andView:(UIView *)view;
-(void)requestingInAppProductPayment:(NSString *)productId andView:(UIView *)view;
-(void)restoreAlreadyPurchsedProductsWithView:(UIView *)view;

@end
