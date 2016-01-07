    //
//  SUAllLeaguesTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 09/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUAllLeaguesTableViewController.h"



@implementation SUAllLeaguesTableViewController

@synthesize leagues, searchResults, searchBar;

- (void)dealloc {
	self.leagues = nil;
	self.searchResults = nil;
	
	
	
    [super dealloc];
}

#define sectionHeaderHeight 30

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
		self.tableView.backgroundColor = [UIColor blackColor];
		
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
	
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	self.tableView.separatorColor = [UIColor blackColor];
	
}



-(void)loadDataById {
	
	// get our data
	NSDictionary *data = [[SUAPIInterface sharedSUAPIInterface] getAllLeagues];
	// and our leagues
	NSMutableArray *allLeagues = [data objectForKey:@"Leagues"];
	// the leagues property is split into sections
	self.leagues = [[[NSMutableArray alloc] initWithCapacity:26] autorelease];
	
	// temp array for the current section
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	char lastChar = 0;
	BOOL finishedFeatured = false;
	// this messed up logic works, try and keep up...
	// go through all of the leagues
	for (int x = 0; x < [allLeagues count]; x++) {
		NSDictionary *currentLeague = [allLeagues objectAtIndex:x];
		// get the title to find what letter we are up to
		NSString *title = [[currentLeague objectForKey:@"LeagueName"] uppercaseString];
		char currentChar = [title characterAtIndex:0];
		// the league has a position if it is featured
		int position = [[currentLeague objectForKey:@"FeaturedPosition"] intValue];
		// at first we are just adding to the featured leagues array, so if we hit one that
		// is not a league, we need to start a new group
		if (position == 0) {
			// check to see if we are finishing the featured leagues
			if (!finishedFeatured) {
				finishedFeatured = true;
				// add this group and start a new one
				[self.leagues addObject:tmpArray];
                [tmpArray release];
                tmpArray = nil;
				tmpArray = [[NSMutableArray alloc] init];
			// otherwise check to see if we are finishing a different group
			} else if (currentChar >= 'A' && currentChar <= 'Z') {
				if (currentChar > lastChar) {
					// add this group and start a new one
					[self.leagues addObject:tmpArray];
                    [tmpArray release];
                    tmpArray = nil;
					tmpArray = [[NSMutableArray alloc] init];
					lastChar = currentChar;
				}
			}
		}
		// add this league to the current group
		[tmpArray addObject:currentLeague];
	}
	// add the final league group
	[self.leagues addObject:tmpArray];
	
	
	[self.tableView setNeedsLayout];
	[self.tableView reloadData];
    
    [tmpArray release];
	
	[self synchingDone:NULL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];		
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;	
	
	
	// show loading
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading";	
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(loadDataById) onTarget:self withObject:nil animated:YES];
	
	
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,50)] autorelease];
	self.searchBar.barStyle = UIBarStyleBlackTranslucent;
	self.searchBar.showsCancelButton = NO;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchBar;
	isSearching = NO;
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	
	if (sectionTitle == nil) {
		return nil;
	}
	
	SUPredictionsTableViewSectionHeader *sectionHeader = [[[SUPredictionsTableViewSectionHeader alloc] 
														   initWithFrame:CGRectMake(0, 0, 320, sectionHeaderHeight) 
														   sectionTitle:sectionTitle] 
														  autorelease];
	return sectionHeader;
}


/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Search Bar delegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if (isSearching) {
		isSearching = FALSE;
		[self.tableView reloadData];
	}
	[self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSLog(@"Searching for text: %@", searchText);
	
	[self populateSearchResults:searchText];
		
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	NSLog(@"start editing");
	// we want to remove the right hand side stuff
	if (!isSearching) {
		isSearching = TRUE;
		
		self.searchBar.showsScopeBar = YES;
		[self.searchBar sizeToFit];		
		[self.searchBar setShowsCancelButton:YES animated:YES];
		
		// load up the start of the search results
		[self populateSearchResults:@""];
		[self.searchBar becomeFirstResponder];
		return YES;
	} else {
		return NO;
	}

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	self.searchBar.showsScopeBar = NO;
	[self.searchBar sizeToFit];
	
	[self.searchBar setShowsCancelButton:NO animated:YES];
	
	return YES;
}

- (void)populateSearchResults:(NSString *)searchString {
	searchString = [searchString uppercaseString];
	NSMutableArray *output = [[NSMutableArray alloc] init];
	
	// go through the featured
	NSMutableArray *tempSection = [self.leagues objectAtIndex:0];
	NSString *name;
	NSDictionary *tempLeague;
	for (int x = 0; x < [tempSection count]; x++) {
		tempLeague = [tempSection objectAtIndex:x];
		name = [[tempLeague objectForKey:@"LeagueName"] uppercaseString];
		if ([name hasPrefix:searchString] || [searchString isEqualToString:@""]) {
			[output addObject:tempLeague];
		}
	}
	
	// we can speed things up a bit by choosing the right section based on the first letter
	if ([searchString length] > 0) {
		char firstLetter = [[searchString uppercaseString] characterAtIndex:0];
		
		if (firstLetter < 'A' || firstLetter > 'Z') {
			
			NSMutableArray *tempSection = [self.leagues objectAtIndex:1];
			
			for (int x = 0; x < [tempSection count]; x++) {
				tempLeague = [tempSection objectAtIndex:x];
				name = [[tempLeague objectForKey:@"LeagueName"] uppercaseString];
				if ([name hasPrefix:searchString]) {
					[output addObject:tempLeague];
				}
			}
			
		} else {
			
			int index = (firstLetter - 'A') +2;
			NSMutableArray *tempSection = [self.leagues objectAtIndex:index];
			
			for (int x = 0; x < [tempSection count]; x++) {
				tempLeague = [tempSection objectAtIndex:x];
				name = [[tempLeague objectForKey:@"LeagueName"] uppercaseString];
				if ([name hasPrefix:searchString]) {
					[output addObject:tempLeague];
				}
			}
		}
		
	}
	
	self.searchResults = output;
    [output release];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Pull to refresh overrides

- (void)synchingDone:(NSNotification *)notification {	
	[super dataSourceDidFinishLoadingNewData];
	refreshHeaderView.lastUpdatedDate = [NSDate date];
	
}

- (void)reloadTableViewDataSource {	
	// pull completed
	[self performSelectorInBackground:@selector(loadDataById) withObject:nil];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (isSearching) {
		return 1;
	}
    return [self.leagues count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (isSearching) {
		return ([self.searchResults count]);
	}
	return [[self.leagues objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (isSearching) {
		return nil;
	}
		
	if (section == 0) {
		return @"Featured Leagues";
	} else if (section == 1) {
		return @"#";
	}
	// 'cause the chars go from A to Z in order, we can just add on our section number to A
	// and treat it just like a char (even though it's really just an int).
	return [NSString stringWithFormat:@"%c", ('A'+(section-2))]; // -2 for the top two headings
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    SUAllLeaguesTableViewCell *cell = (SUAllLeaguesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SUAllLeaguesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *selectedLeague;
	
	// if we are searching get the details from the search results
	if (isSearching) {
		// get the league for this section and index
		selectedLeague = [self.searchResults objectAtIndex:[indexPath indexAtPosition:1]];
		
	} else {
		// get the league for this section and index
		NSMutableArray *tempRow = [self.leagues objectAtIndex:[indexPath indexAtPosition:0]];
		selectedLeague = [tempRow objectAtIndex:[indexPath indexAtPosition:1]];
	}
	
	
	// populate the cells with the required info
	cell.textLabel.text = [selectedLeague objectForKey:@"LeagueName"];
	cell.memberLabel.text = [NSString stringWithFormat:@"%@", [selectedLeague objectForKey:@"MemberCount"]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if (isSearching) {
		return nil;
	} else {
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		[tempArray addObject:@""];
		[tempArray addObject:@"#"];
		// add headings from A to Z, sexy eh?
		for (int x = 0; x < 26; x++) {
			[tempArray addObject:[NSString stringWithFormat:@"%c", ('A'+x)]];
		}
		return tempArray;
	}
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	return index;
	
	//NSLog(@"index clicked: %i", [[self.leagueIndexes objectAtIndex:index] intValue]);
	
	//return [[self.leagueIndexes objectAtIndex:index] intValue];
	
	//return 0;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)loadDetailForLeague:(NSString *)leagueId {
	// push league detail  view with the league object
	
	SULeagueDetailTableViewController *controller = [[[SULeagueDetailTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	// get the league id for the league at this index
		
	controller.leagueId = leagueId;
	[self.navigationController pushViewController:controller animated:YES];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[self searchBarShouldEndEditing:self.searchBar];
	if (isSearching) {
		NSDictionary *league = [searchResults objectAtIndex: indexPath.row];
		[self loadDetailForLeague:[league objectForKey:@"Id"]];
		
	} else {
		NSDictionary *league = [[leagues objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
		[self loadDetailForLeague:[league objectForKey:@"Id"]];
	}
	
}

#pragma mark -
#pragma mark MBProgressHUD delegate methods
- (void)hudWasHidden {
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



@end

