//
//  Utils.m
//  InAppDemo
//
//  Created by Abhishek Kumar Ravi on 12/04/16.
//  Copyright © 2016 Abhishek Kumar Ravi. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"

@implementation Utils

+(BOOL)isInternetAvailable{
    
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    [hostReach startNotifier];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }

    
}

@end
