//
//  SCPost.h
//  Social
//
//  Created by 刘子誉 on 2017/11/16.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface SCPost : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message; //copy not allowed to change, strong allow to change
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
