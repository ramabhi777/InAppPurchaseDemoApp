//
//  InAppProduct.h
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 29/02/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppProduct : NSObject

@property NSString *productName;
@property NSString *productDescription;
@property NSString *productPrice;
@property NSString *productID;
@property NSLocale *productLocale;

-(void)intializeInAppProduct:(NSString *)productName withProductDescription:(NSString *)productDescription withProductPrice:(NSString *)productprice withProductID:(NSString *)productID andProductLocale:(NSLocale *)productLocale;
@end
