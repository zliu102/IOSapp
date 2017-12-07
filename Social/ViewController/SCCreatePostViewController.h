//
//  SCCreatePostViewController.h
//  Social
//
//  Created by Mengying Shu on 12/2/17.
//  Copyright © 2017 Mengying Shu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCreatePostViewControllerDelegate <NSObject>

- (void)didCreatePost;

@end
@interface SCCreatePostViewController : UIViewController

@property (nonatomic, weak) id<SCCreatePostViewControllerDelegate> delegate;

@end

