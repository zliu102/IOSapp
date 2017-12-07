//
//  SCUser.h
//  Social
//
//  Created by 刘子誉 on 2017/11/24.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUser : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;

- (instancetype)initWithUsername:(NSString *)username andPassword:(NSString *)password;

@end

