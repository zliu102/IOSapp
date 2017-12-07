#import "SCHomeViewController.h"
#import "SCPost.h"
#import "SCHomeTableViewCell.h"
#import "SCSignInViewController.h"
#import "SCUserManager.h"
#import "SCPostManager.h"
#import "SCLocationManager.h"
#import <MapKit/MapKit.h>
#import "SCCreatePostViewController.h"
static NSString * const SCHomeCellIdentifier = @"SCHomeCellIdentifier";

@interface SCHomeViewController () <UITableViewDelegate, UITableViewDataSource, SCSignInViewControllerDelegate, SCCreatePostViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<SCPost *> *posts;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
@implementation SCHomeViewController

- (void)loginSuccess
{
    [self loadPosts];
}
//call many times
//viewWillAppear from UIViewControll
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // check user login or not
    [self userLoginIfRequire];
}

#pragma mark -- private
- (void)userLoginIfRequire
{
    //not login
    if (![[SCUserManager sharedUserManager] isUserLogin]) {
        SCSignInViewController *signInViewController = [[SCSignInViewController alloc] initWithNibName:NSStringFromClass([SCSignInViewController class]) bundle:nil];
        signInViewController.delegate = self; //signInViewController.delegate = SCHomeViewController
        //present view controller sign in rather than push view controller.
        //push view controller: posts main core
        //present view controller: sign in single step
        [self presentViewController:signInViewController animated:YES completion:nil];
    }
    else {
        [self loadPosts];
    }
}


//call once
//viewDidLoad from UIViewControll
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self loadPosts];
    // load UI
    [self setupUI];
    
    // request location access
    [self updateLocation];
    
    // add observer, addObserver homeviewController, selector: response after get notification, object:nill = notification can be anything
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts) name:SCLocationUpdateNotification object:nil];
}
#pragma mark - UI
- (void)setupUI
{
    [self setupTableView];
    [self setupNavigationBarUI];
    
}

#pragma mark -- private

- (void)updateLocation
{
    if (![SCLocationManager isLocationServicesEnabled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location Required", nil) message:NSLocalizedString(@"Location is required for this app", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        SCLocationManager *locationManager  = [SCLocationManager sharedManager];
        [locationManager startLoadUserLocation];
    }
}

- (void)setupNavigationBarUI
{
    self.title = NSLocalizedString(@"Home", nil);
    self.navigationController.navigationBar.tintColor = [UIColor darkTextColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post"] style:UIBarButtonItemStyleDone target:self action:@selector(showCreatePostPage)];
}

//after ios9, could delete
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark -- public
- (void)loadResultPageWithPosts:(NSArray <SCPost *>*)posts
{
    self.posts = posts;
    [self.tableView reloadData];
}

#pragma mark -- load data
- (void)loadPosts
{
    __weak typeof(self) weakSelf = self;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.441883 longitude:-122.143019];
    NSInteger range = 300000;
    [SCPostManager getPostsWithLocation:location range:range andCompletion:^(NSArray<SCPost *> *posts, NSError *error) {
        if (posts) {
            weakSelf.posts = posts;
            [weakSelf.tableView reloadData];
            NSLog(@"get posts count:%ld", (long)posts.count);
        }
        else {
            NSLog(@"error: %@", error);
        }
    }];
}
#pragma mark - SCCreatePostViewControllerDelegate
- (void)didCreatePost
{
    [self loadPosts];
}

- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCHomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:SCHomeCellIdentifier];
}



#pragma mark -- Action
- (void)showCreatePostPage
{
    SCCreatePostViewController *creatPost = [SCCreatePostViewController new];
    creatPost.delegate = self;
    [self.navigationController pushViewController:creatPost animated:YES];
    
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCHomeCellIdentifier forIndexPath:indexPath];
    [cell loadCellWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SCHomeTableViewCell cellHeight];
}
@end


