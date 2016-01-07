//
//  SUFriendPickerTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 19/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"

@interface SUFriendPickerTableViewController : UITableViewController <UISearchBarDelegate, MBProgressHUDDelegate, UIAlertViewDelegate> {
	NSMutableArray *contacts;
	NSMutableArray *searchResults;
	UISearchBar *searchBar;
	BOOL isSearching;
	BOOL saveSuccessful;
	NSString *leagueId;
	MBProgressHUD *HUD;
    NSInteger selectedRow;

}
@property (readwrite, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSString *leagueId;
- (void)populateSearchResults:(NSString *)searchString;
@end
