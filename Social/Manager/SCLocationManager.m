
#import "SCLocationManager.h"
#import <MapKit/MapKit.h>

NSString * const SCLocationUpdateNotification = @"SCLocationUpdateNotification";

@interface SCLocationManager () <CLLocationManagerDelegate>
//in explore, read singleton same location, return same object CLManager
//user location => callback, when user
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *CLManager;

@end
//SCLocationManager singleton
@implementation SCLocationManager

+ (instancetype)sharedManager
{
    static SCLocationManager *locationManager = nil;
    //if self=nil, execute once, else skip
    @synchronized (self) {
        if (locationManager == nil) {
            locationManager = [SCLocationManager new];
            locationManager.CLManager = [CLLocationManager new];
            locationManager.CLManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.CLManager.distanceFilter = 1000.0; //data within 1000km
        }
    }
    //after 1st time
    return locationManager;
}
//ask user for permission
- (void)getUserPermission
{
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) ||
        ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)) {
        [self.CLManager requestWhenInUseAuthorization];
    }
}

+ (BOOL)isLocationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

- (CLLocation *)getUserCurrentLocation
{
    return self.currentLocation;
}

- (void)stopLoadUserLocation
{
    [self.CLManager stopUpdatingLocation];
}

- (void)startLoadUserLocation
{
    self.CLManager.delegate = self;
    [self getUserPermission];
    [self.CLManager startMonitoringSignificantLocationChanges];
    [self.CLManager startUpdatingLocation];
}

- (BOOL)coordinateA:(CLLocationCoordinate2D)coordianteA isSameAsCoordinateB:(CLLocationCoordinate2D)coordinateB
{
    if ((fabs(coordianteA.latitude - coordinateB.latitude) <= 0.005) &&
        (fabs(coordianteA.longitude - coordinateB.longitude) <= 0.005)) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldUpdateLocationWithLastLocation:(CLLocationCoordinate2D)coordianteA andNewLocation:(CLLocationCoordinate2D)coordinateB
{
    if ((fabs(coordianteA.latitude - coordinateB.latitude) > 1) ||
        (fabs(coordianteA.longitude - coordinateB.longitude) > 1)) {
        return YES;
    }
    return NO;
}

//user location updation, array of locations, store user from beginning to end, last object in array is what we wanted
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    BOOL shouldUpdateLocation = NO;
    //check currentLocation is empty, and lastObject has sth
    if (!self.currentLocation && locations.lastObject) {
        shouldUpdateLocation = YES;
    }//in a range, no update, else update
    else if ([self shouldUpdateLocationWithLastLocation:self.currentLocation.coordinate andNewLocation:locations.lastObject.coordinate]) {
        shouldUpdateLocation = YES;
    }
    if (shouldUpdateLocation) {
        self.currentLocation = locations.lastObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:SCLocationUpdateNotification object:nil];
    }
}

@end


