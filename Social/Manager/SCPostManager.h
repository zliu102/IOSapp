//
//  SCPostManager.h
//  Social
//
//  Created by 刘子誉 on 2017/11/26.
//  Copyright © 2017年 刘子誉. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SCPost;
@class CLLocation;

@interface SCPostManager : NSObject

/*
 * Create posts with message and image
 */
+ (void)createPostWithMessage:(NSString *)message imageFile:(UIImage *)image andCompletion:(void(^)(NSError *error))completionBlock;

/*
 * load all posts within a givin location and range
 */
+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <SCPost *>* posts, NSError *error))completionBlock;

@end

