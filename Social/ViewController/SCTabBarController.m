//
//  SCTabBarController.m
//  Social
//
//  Created by Mengying Shu on 11/11/17.
//  Copyright © 2017 Mengying Shu. All rights reserved.
//

#import "SCTabBarController.h"
#import "SCHomeViewController.h"
#import "SCExploreViewController.h"

@interface SCTabBarController ()

@end

@implementation SCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self viewControllerArray];
    self.selectedIndex = 0;
}

- (NSArray <UIViewController *> *)viewControllerArray
{
    UIViewController *homeController = [self homeViewController];
    UIViewController *exploreController = [self exploreViewController];
    NSArray<UIViewController *> *array = @[homeController, exploreController];
    return array;
}

- (UIViewController *)homeViewController
{
    SCHomeViewController *homeController = [[SCHomeViewController alloc] init];
    homeController.title = @"home";
    
    homeController.view.backgroundColor = [UIColor blueColor];
    homeController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"homeSelected"]];
    homeController.tabBarItem.tag = 0;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    return navigationController; //why change to home, home on title disappear.
}

- (UIViewController *)exploreViewController
{
    SCExploreViewController *exploreController = [SCExploreViewController new];
    exploreController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Explore" image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"mapSelected"]];
    exploreController.tabBarItem.tag = 1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:exploreController];
    return navigationController;
}


@end
