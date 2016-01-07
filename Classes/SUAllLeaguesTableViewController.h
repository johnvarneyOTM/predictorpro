//
//  SUAllLeaguesTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 09/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PullToRefreshTableViewController.h"
#import "SUPredictionsTableViewSectionHeader.h"
#import "SUAllLeaguesTableViewCell.h"
#import "SULeagueDetailTableViewController.h"

//#import "SULeagueDetailViewController.h"

@interface SUAllLeaguesTableViewController : PullToRefreshTableViewController <UISearchBarDelegate, MBProgressHUDDelegate> {
	
	MBProgressHUD *HUD;
	NSMutableArray *searchResults;
	NSMutableArray *leagues;
	UISearchBar *searchBar;
	BOOL isSearching;
}

- (void)synchingDone:(NSNotification *)notification;
- (void)populateSearchResults:(NSString *)searchString;
@property (nonatomic, retain) NSMutableArray *leagues;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) UISearchBar *searchBar;


@end

