//
//  NetworkQueryComposer.m
//  NetworkLayer
//
//  Created by Haider, Wali (Contractor) on 06/01/2017.
//  Copyright (c) 2017 Haider, Wali (Contractor). All rights reserved.
//

#import "NetworkQueryComposer.h"

@implementation NetworkQueryComposer

#pragma Service Endpoints
+ (NSString *)addSubscriptionScreenInfoServicesURL
{
    return @"/subscription/userpref/getScanInfo";
}
+ (NSString *)getPinBoardDetailsApiURL
{
    return @"raw/wgkJgazE";

}
@end
