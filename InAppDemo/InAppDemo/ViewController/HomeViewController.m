//
//  HomeViewController.m
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 09/03/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import "HomeViewController.h"
#import "InAppHandlerMethods.h"
#import "Constants.h"

@interface HomeViewController ()

@end

@implementation HomeViewController{
    InAppHandlerMethods *inAppHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self intializeObjects];
}

-(void)intializeObjects{
    inAppHandler= [[InAppHandlerMethods alloc]init];
}



- (IBAction)clickedRequestForListOfproducts:(id)sender {
    
}


- (IBAction)restoreProduct_Clicked:(id)sender {
    
}

-(IBAction)clickedRestoreProductButton:(id)sender{
    // Restore
    [inAppHandler restoreAlreadyPurchsedProductsWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
