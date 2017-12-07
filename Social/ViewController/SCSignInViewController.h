//
//  SCSignInViewController.h
//  Social
//
//  Created by Mengying Shu on 11/23/17.
//  Copyright © 2017 Mengying Shu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSignInViewControllerDelegate <NSObject>

- (void)loginSuccess;

@end

@interface SCSignInViewController : UIViewController
//id == any object, any object implement delegate
@property (nonatomic, weak) id<SCSignInViewControllerDelegate> delegate;
@end

