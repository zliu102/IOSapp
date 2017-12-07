//
//  SCUser.m
//  Social
//
//  Created by 刘子誉 on 2017/11/24.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import "SCUser.h"

@implementation SCUser

- (instancetype)initWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if (self = [super init]) {
        self.userName = username;
        self.password = password;
    }
    return self;
}

@end
