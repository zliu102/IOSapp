#import "SCUserManager.h"
#import "SCUser.h"
#import "AFNetworking.h"

static NSString * const SCBaseURLString = @"https://around-75015.appspot.com";

@interface SCUserManager ()

@property (nonatomic, strong) SCUser *currentUser; //private,only set once thus nonatomic, object need currentuser thus strong, reference count = 1
@end

@implementation SCUserManager

//singleton
+ (SCUserManager *)sharedUserManager
{
    //1st mine initialize, then not nil
    static SCUserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    //dispatch only execute once
    dispatch_once(&onceToken, ^{
        sharedUserManager = [SCUserManager new];
    });
    return sharedUserManager;
}

- (void)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password
{
    self.currentUser = [SCUser new];
    self.currentUser.userName = username;
    self.currentUser.password = password;
}

- (BOOL)isUserLogin
{
    //if not login, currentUser=nil,return 0, false
    return self.currentUser.userName.length > 0; //username is getter
}

- (void)loginWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password andCompletionBlock:(void(^)(NSError *error))completionBlock
{
    //edge case: username or password is empty string
    
    NSString *urlString = [NSString stringWithFormat:@"%@/login",  SCBaseURLString];
    
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *body = @{@"username" : [username lowercaseString],
                           @"password" : password,
                           };
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    
    // API call with completion block
    __weak typeof(self) weakSelf = self;
    //block request success/fail => block callback completionHandler => callback completionBlock
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            weakSelf.currentUser = [[SCUser alloc] initWithUsername:username andPassword:password];
            NSString *token = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            weakSelf.currentUser.token = [NSString stringWithFormat:@"Bearer %@", token];
            NSLog(@"user successfully login with token: %@", token);
        }
        else {
            NSLog(@"user login fail: %@", error);
        }
        if (completionBlock) { //if nil, will crush, not nil can, this is not nil
            completionBlock(error);
        }
    }] resume];
}
//username, password, completionBlock
- (void)signupWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password andCompletionBlock:(void(^)(NSError *error))completionBlock
{
    //create new string %@=SCBaseURLString,
    NSString *urlString = [NSString stringWithFormat:@"%@/signup",  SCBaseURLString];
    
    //remove space
    [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *body = @{@"username" : [username lowercaseString],
                           @"password" : password,
                           };
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer]; //NSSet many values
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    // API call with completion block
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Sign up API response: %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            [self loginWithUsername:username password:password andCompletionBlock:^(NSError * _Nullable error) {
                if (completionBlock) {
                    completionBlock(error);
                }
            }];
        }
        else {
            NSLog(@"fail to sign up: %@", error);
            if (completionBlock) {
                completionBlock(error);
            }
        }
    }] resume];
}


@end

