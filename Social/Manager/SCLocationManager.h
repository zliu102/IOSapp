//
//  SCLocationManager.h
//  Social
//
//  Created by 刘子誉 on 2017/12/2.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

extern NSString * const SCLocationUpdateNotification;

@interface SCLocationManager : NSObject

+ (instancetype)sharedManager; //CLLOcationManager singleton
- (void)getUserPermission;
+ (BOOL)isLocationServicesEnabled;
- (void)startLoadUserLocation;
- (void)stopLoadUserLocation;
- (CLLocation *)getUserCurrentLocation;//getter, not property because not allowed set

@end

