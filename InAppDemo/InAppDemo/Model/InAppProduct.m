//
//  InAppProduct.m
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 29/02/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import "InAppProduct.h"

@implementation InAppProduct

-(void)intializeInAppProduct:(NSString *)productName withProductDescription:(NSString *)productDescription withProductPrice:(NSString *)productPrice withProductID:(NSString *)productID andProductLocale:(NSLocale *)productLocale{
    
    self.productName = productName;
    self.productDescription = productDescription;
    self.productPrice = productPrice;
    self.productID = productID;
    self.productLocale = productLocale;
    
}

@end
