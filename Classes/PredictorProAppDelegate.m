//
//  PredictorProAppDelegate.m
//  PredictorPro
//
//  Created by Oliver Relph on 22/06/2010.
//  Copyright Sumac 2010. All rights reserved.
//

#import "PredictorProAppDelegate.h"


@implementation PredictorProAppDelegate

@synthesize window;
@synthesize launchViewController;
@synthesize tabBarController;


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	
	// Add a global background image
	UIView *backgroundView = [[UIView alloc] initWithFrame: window.frame];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainBackground" ofType:@"png" inDirectory:@"/"]]];
	[window addSubview:backgroundView];
	[backgroundView release];
	
	
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *email = [defaults stringForKey:@"email_preference"];
	NSString *pass = [defaults stringForKey:@"password_preference"];
	
	// Show the splash for a bit longer
	sleep(1);
	
	BOOL loggedIn = NO;
	if (email != nil && pass != nil) {
		// try logging in
		loggedIn = [[SUAPIInterface sharedSUAPIInterface] loginUserWithEmail:email password:pass];
	} 

	if (loggedIn) {
		// jump straight to the app
		[self loadApp];
	} else {
		// throw in the login/ register screens
		
		// Add the Navigation Controller for login/ register stuff
		SULaunchViewController *_launchViewController = [[SULaunchViewController alloc] initWithNibName:@"SULaunchViewController" bundle:[NSBundle mainBundle]];
		self.launchViewController = _launchViewController;
		[_launchViewController release];
		[window addSubview:launchViewController.view];	
		
		// Push in the loginTableViewController
		SULoginTableViewController *loginTableViewController = [[SULoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[[self launchViewController] pushViewController:loginTableViewController animated:YES];
		[loginTableViewController release];
	}

	
    
    [window makeKeyAndVisible];

    return YES;
}

- (void) changeSection:(NSInteger) section {
	self.tabBarController.selectedIndex = section;
}

- (void)loadApp {
	for(UIView *subview in [self.window subviews]) {
		if([subview isKindOfClass:[UIView class]]) {
			[subview removeFromSuperview];
		} else {
			// Do nothing - not the SULoginViewController
		}
	}
	
	// add the tab controller	
	[window addSubview:tabBarController.view];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


@end

