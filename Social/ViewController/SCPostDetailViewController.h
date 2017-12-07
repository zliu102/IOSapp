//
//  SCPostDetailViewController.h
//  Social
//
//  Created by Mengying Shu on 12/2/17.
//  Copyright © 2017 Mengying Shu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCPostDetailViewController : UIViewController

- (void)loadDetailViewWithPost:(SCPost *)post;

@end
