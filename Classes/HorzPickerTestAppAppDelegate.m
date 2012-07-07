//
//  HorzPickerTestAppAppDelegate.m
//  HorzPickerTestApp
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TestViewController.h"
#import "HorzPickerTestAppAppDelegate.h"

@implementation HorzPickerTestAppAppDelegate

@synthesize window;
@synthesize testView;


#pragma mark - Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Override point for customization after application launch.
	testView = [[TestViewController alloc] init];
	[window addSubview:testView.view];

	[window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application { }

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }


#pragma mark - Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application { }

@end
