//
//  PredictorProAppDelegate.h
//  PredictorPro
//
//  Created by Oliver Relph on 22/06/2010.
//  Copyright Sumac 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SULaunchViewController.h"
#import "SULoginTableViewController.h"
#import "SULeaguesTableViewController.h"
#import "SULeagueDetailTableViewController.h"
#import <unistd.h>

@interface PredictorProAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	SULaunchViewController *launchViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) SULaunchViewController *launchViewController;
//- (void) changeSection;
- (void) loadApp;

@end
