//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOMainViewController.h"

#import <Parse/Parse.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    self.window.rootViewController = mainViewController;
    
    [self.window makeKeyAndVisible];
    
    
    [Parse setApplicationId:@"2MS1N1zfmK380WV1zOYR1jhJWAj5BEz6uuZsAbIW" clientKey:@"Ke6SEnngzAwKRSWoPumG22ojb7UOjLl312uwOAp8"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    bool isRegistered = [prefs stringForKey:@"isRegistered"];
    
    if (isRegistered)
    {
        NSLog(@"User already registered, logging in.");
        
        if (![self resetPointsIfMonday :prefs])
        {
            [self deductPointsIfNotLoggedIn :prefs];
        }
        
        [self loginUser:idfv :prefs];
        [self pushPointsHistoryToParse :prefs];
        
    } else {
        
        NSLog(@"User not registered, let's register!");
        [self registerUser:idfv :prefs];
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    // last login is now
    [prefs setObject:now forKey:@"lastOpen"];
    
    return YES;
}



-(void)pushPointsHistoryToParse:(NSUserDefaults *)prefs
{
    NSMutableArray *pointsHistory = [prefs objectForKey:@"pointsHistory"];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"points"] = pointsHistory;
    [currentUser save];

    [PFCloud callFunctionInBackground:@"updateLifetimePoints" withParameters: @{ @"username" : currentUser.username, @"points":pointsHistory } block:^(NSString *result, NSError *error)
     {
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error saving your data. Try restarting the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(bool)resetPointsIfMonday:(NSUserDefaults *)prefs
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    bool wasScoreReset = false;
    
    NSDate *lastScoreReset = [prefs objectForKey:@"lastScoreReset"];
    
    int daysSinceLastReset = [self getNumberOfDaysSince:now :lastScoreReset];
    
    if (daysSinceLastReset < 7)
    {
        int daysAgo = 0;
        int interval = 0;
        
        while (daysAgo < daysSinceLastReset)
        {
            if (daysAgo != 0)
            {
                interval = 86400 * daysAgo;
            }
            
            if ([[gregorian components:NSWeekdayCalendarUnit | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[now dateByAddingTimeInterval:-interval]] weekday] == 2)
            {
                [self resetScore :prefs];
                [self pushPointsHistoryToParse :prefs];
                wasScoreReset = true;
            }
            
            daysAgo++;
        }
    } else {
        [self resetScore :prefs];
        [self pushPointsHistoryToParse :prefs];
        wasScoreReset = true;
    }
    
    return wasScoreReset;
    
    
}

-(void)deductPointsIfNotLoggedIn:(NSUserDefaults *)prefs
{
    NSInteger currentScore = [prefs integerForKey:@"score"];
    NSDate *now = [[NSDate alloc] init];
    NSDate *lastOpen = [prefs objectForKey:@"lastOpen"];
    
    // check how many days the user has not logged in for
    
    int daysSinceLastLogin = [self getNumberOfDaysSince:now :lastOpen];
    NSNumber *daysSinceLastLoginNum = [NSNumber numberWithInt:daysSinceLastLogin];
    NSLog(@"%d", [daysSinceLastLoginNum integerValue]);
    
    if (daysSinceLastLogin > 0)
    {
        int pointsLost = daysSinceLastLogin * 15;
        [prefs setInteger:(currentScore - pointsLost) forKey:@"score"];
    }
    
    
}

-(void)loginUser:(NSString *)idfv :(NSUserDefaults *)prefs
{
    [PFUser logInWithUsernameInBackground:idfv password:[self sha256HashFor:idfv] block:^(PFUser *user, NSError *error) {
        
        if (user)
        {
            // yay successful login
            NSLog(@"User Successfully logged in.");
            [prefs setBool:YES forKey:@"isLoggedIn"];
            
        } else {
            // not successful
            [prefs setBool:NO forKey:@"isLoggedIn"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you could not be logged in. Try re-launching the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void)registerUser:(NSString *)idfv :(NSUserDefaults *)prefs
{
    PFUser *user = [PFUser user];
    
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:8];
    for ( int i = 1 ; i <= 8 ; i ++ )
        [points addObject:[NSNumber numberWithInt:0]];
    
    user.username = idfv;
    user.password = [self sha256HashFor:idfv];
    user[@"points"] = points;
    user[@"lifetime_points"] = points;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"Successfully Registered!");
             [prefs setBool:YES forKey:@"isRegistered"];
             
             // set a starting score
             [prefs setInteger:150 forKey:@"score"];
             
             // set last opened date to now
             NSDate *now = [[NSDate alloc] init];
             //             [prefs setObject:now forKey:@"lastOpen"];
             [prefs setObject:now forKey:@"lastScoreReset"];
             
             // set points history mutable dictionary
             NSMutableArray *pointsHistory = [[NSMutableArray alloc] init];
             [prefs setObject:pointsHistory forKey:@"pointsHistory"];
             
             // login
             [self loginUser:idfv :prefs];
             
         } else {
             [prefs setBool:NO forKey:@"isRegistered"];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you could not be registered. Try re-launching the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
     }];
}

-(void)resetScore:(NSUserDefaults *)prefs
{
    [prefs setInteger:150 forKey:@"score"];
    [prefs setObject:[[NSDate alloc] init] forKey:@"lastScoreReset"];
    NSLog(@"Reseting score to 150 because Monday has passed.");
}

-(int)getNumberOfDaysSince:(NSDate *)from :(NSDate *)to
{
    NSNumber *timeInterval = [[NSNumber alloc] initWithDouble:[from timeIntervalSinceDate:to]];
    
    int daysSinceLastLogin = [timeInterval intValue] / 86400;
    
    return daysSinceLastLogin;
}

-(NSString*) sha256HashFor:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[45]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:45];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


@end
