//
//  SCPost.m
//  Social
//
//  Created by 刘子誉 on 2017/11/16.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import "SCPost.h"
@import CoreLocation;

@implementation SCPost
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self != nil) { //= if (self)
        self.name = dict[@"user"];
        self.message = dict[@"message"];
        CLLocationDegrees latitute = [dict[@"location"][@"lat"] doubleValue];
        CLLocationDegrees longtitude = [dict[@"location"][@"lon"] doubleValue];
        self.location = [[CLLocation alloc] initWithLatitude:latitute longitude:longtitude];
        self.imageURL = dict[@"url"];
    }
    return self;
}
@end

