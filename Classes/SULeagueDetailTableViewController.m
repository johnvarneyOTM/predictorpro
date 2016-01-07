//
//  SULeagueDetailTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULeagueDetailTableViewController.h"


@implementation SULeagueDetailTableViewController
@synthesize segBar, viewMode, leagueId, league, success, apiMode, currentUserIsPartOfLeague, currentUserIsCreatorOfLeague, detailControl;

- (void)dealloc {
	self.league = nil;
	
    [super dealloc];
}

-(BOOL) currentUserIsPartOfLeague {
	if (self.league != nil) {
		
		NSString *isCreator = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"UserIsCreator"]];
		NSString *isMember = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"UserIsMember"]];	
		
		if ([isCreator isEqualToString:@"1"] || [isMember isEqualToString:@"1"]) {
			return YES;
		}
	}	
	return NO;
}
-(BOOL) currentUserIsCreatorOfLeague {
	if (self.league != nil) {		
		NSString *isCreator = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"UserIsCreator"]];
		return [isCreator isEqualToString:@"1"];	
	}	
	return NO;
}

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		self.view.backgroundColor = [UIColor blackColor];
		self.tableView.backgroundColor = [UIColor blackColor];//UIColorFromRGB(0x303132);
		self.tableView.separatorColor = [UIColor blackColor];//UIColorFromRGB(0x4f4e4e);
		
		self.segBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, 320.0f, 40.0f)] autorelease];
		
		CAGradientLayer *layerGradient = [CAGradientLayer layer];
		layerGradient.frame = segBar.frame;		
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x222121) CGColor], (id)[UIColorFromRGB(0x000000) CGColor], nil];
		
		[segBar.layer insertSublayer:layerGradient atIndex:0];

		
		UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"League", @"Banter", nil]];
		[segControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		segControl.frame = CGRectMake(15, 4, 200, 30);
		segControl.segmentedControlStyle = UISegmentedControlStyleBar;
		segControl.momentary = YES;
		[segControl setTintColor:[UIColor whiteColor]];
		[self.segBar addSubview:segControl];
		[segControl release];
		
		self.detailControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"About", nil]] autorelease];
		[self.detailControl addTarget:self action:@selector(descriptionAction:) forControlEvents:UIControlEventValueChanged];
		self.detailControl.frame = CGRectMake(225, 4, 80, 30);
		self.detailControl.segmentedControlStyle = UISegmentedControlStyleBar;
		self.detailControl.momentary = YES;
		[self.detailControl setTintColor:[UIColor whiteColor]];
		[segBar addSubview:self.detailControl];
		
		self.tableView.tableHeaderView = segBar;
	}
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.viewMode = SULeagueDetailTableViewControllerModeLeague;
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
		
	[self loadLeague];
													  
}

- (void) loadLeague {
	
	self.apiMode = SULeagueDetailTableViewControllerAPIModeLoadLeague;
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	
	// show loading
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
	// Add HUD to screen
	[window addSubview:HUD];
	
	// Register for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Loading";	
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(loadDataById) onTarget:self withObject:nil animated:YES];
		
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)loadDataById {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *userId = [[SUAPIInterface sharedSUAPIInterface] userId];
	NSDictionary *data = [[SUAPIInterface sharedSUAPIInterface] getLeague:leagueId userId:userId];
	
	
	self.league = [[[data objectForKey:@"League"] copy] autorelease];
	
	NSString *isCreator = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"UserIsCreator"]];
	NSString *isMember = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"UserIsMember"]];	
	
	NSLog(@"Creator = %@, Member = %@", isCreator, isMember);
	
	if ([isCreator isEqualToString:@"1"]) {
		UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" 
																		  style:UIBarButtonItemStyleBordered 
																		 target:self 
																		 action:@selector(editLeagueClicked)] autorelease];
		self.navigationItem.rightBarButtonItem = editButton;
	} else if ([isMember  isEqualToString:@"1"]) {
		UIBarButtonItem *leaveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Leave" 
																		  style:UIBarButtonItemStyleBordered 
																		 target:self 
																		 action:@selector(leaveLeagueClicked)] autorelease];
		self.navigationItem.rightBarButtonItem = leaveButton;
	} else {
		UIBarButtonItem *joinButton = [[[UIBarButtonItem alloc] initWithTitle:@"Join" 
																		style:UIBarButtonItemStyleBordered 
																	   target:self 
																	   action:@selector(joinLeagueClicked)] autorelease];
		self.navigationItem.rightBarButtonItem = joinButton;
	}
	
	
	NSString *description = [self.league objectForKey:@"LeagueDescription"];
	if ([description isEqualToString:@""]) {
		self.detailControl.enabled = NO;
		self.detailControl.alpha = 0.5;
	} else {
		self.detailControl.enabled = YES;
		self.detailControl.alpha = 1;
	}
	
	self.navigationItem.title = [self.league objectForKey:@"LeagueName"];
	
	[self.tableView setNeedsLayout];
	
	[self.tableView reloadData];
	[self synchingDone:NULL];
	
	[pool release];
	pool = nil;
}

#pragma mark -
#pragma mark Pull to refresh overrides

- (void)synchingDone:(NSNotification *)notification {
	[super dataSourceDidFinishLoadingNewData];
	refreshHeaderView.lastUpdatedDate = [NSDate date];
}

- (void)reloadTableViewDataSource {	
	[self performSelectorInBackground:@selector(loadDataById) withObject:nil ];
	
}


- (void)editLeagueClicked {

	SUEditLeagueTableViewController *editLeagueViewController = [[[SUEditLeagueTableViewController alloc] initWithStyle:UITableViewStyleGrouped viewMode:SUEditLeagueTableViewModeEdit] autorelease];
	editLeagueViewController.league = self.league;
	[self.navigationController pushViewController:editLeagueViewController animated:YES];
	
}

- (void)leaveLeagueClicked {
	
	SULeaveLeagueTableViewController *leaveLeagueViewController = [[[SULeaveLeagueTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	leaveLeagueViewController.leagueId = [self.league objectForKey:@"Id"];
	[self.navigationController pushViewController:leaveLeagueViewController animated:YES];

}


- (void)joinLeagueClicked {
	
	self.apiMode = SULeagueDetailTableViewControllerAPIModeJoinLeague;
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	
	// show loading
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
	// Add HUD to screen
	[window addSubview:HUD];
	
	// Register for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Loading";	
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(joinLeague) onTarget:self withObject:nil animated:YES];
	
}

- (void)joinLeague {
	self.success = [[SUAPIInterface sharedSUAPIInterface] joinLeague:self.leagueId] == YES;
}

- (void)hudWasHidden {
	switch ((int) self.apiMode) {
		case SULeagueDetailTableViewControllerAPIModeJoinLeague:
			if (self.success) {
				[self loadLeague];
			} else {
				UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message: [SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[errorAlert show];
			}
			break;
		default:
			// Do nothing, league was loading
			break;
	}
}

- (void)newBanter:(id)sender {
	NSLog(@"new banter");
	
	
	SUAddBanterTableViewController *addBanterViewController = [[SUAddBanterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	//detailViewController.teamId = [[[self.league objectForKey:@"Users"] objectAtIndex:[indexPath indexAtPosition:1]] objectForKey:@"Id"];
	// ...
	// Pass the selected object to the new view controller.
	addBanterViewController.league = self.league;
	
	
	[self.navigationController pushViewController:addBanterViewController animated:YES];
	[addBanterViewController release];
	
	
}
- (void)inviteFriends:(id)sender {
		
	SUFriendPickerTableViewController *detailViewController = [[SUFriendPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
	detailViewController.leagueId = [self.league objectForKey:@"Id"];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)segmentAction:(id)sender {
	
    UISegmentedControl *sc = (UISegmentedControl *)sender;
	
    NSInteger index = sc.selectedSegmentIndex;
	switch (index) {
		case 0: {
			self.viewMode = SULeagueDetailTableViewControllerModeLeague;
			break;
		}
		case 1:	{			
			self.viewMode = SULeagueDetailTableViewControllerModeBanter;
			break;
		}
	}
	
	[self.tableView reloadData];
	
}
- (void)descriptionAction:(id)sender {
	
	NSString *description = [self.league objectForKey:@"LeagueDescription"];
	
	SUTextViewController *helpView = [[[SUTextViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	helpView.detailLabel.text = description;
	
	[self.navigationController pushViewController:helpView animated:YES];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    // Return the number of rows in the section.
	if (self.viewMode == SULeagueDetailTableViewControllerModeLeague) {
		// we are viewing participants
		if (self.currentUserIsCreatorOfLeague) {
			return [[self.league objectForKey:@"Users"] count] +1; // +1 for the invite users cell
		} else {	
			return [[self.league objectForKey:@"Users"] count];	
		}
		
	} else if (self.viewMode == SULeagueDetailTableViewControllerModeBanter) {
		
		// we are viewing banter
		if (self.currentUserIsPartOfLeague) {
			return [[self.league objectForKey:@"Banter"] count]+1; // +1 for the add banter cell
		} else {	
			return [[self.league objectForKey:@"Banter"] count];		
		}

	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int index = [indexPath row];
	
	if (self.viewMode == SULeagueDetailTableViewControllerModeLeague) {
		
		// test to see whether we do the invite friends button
		if (index == 0 && self.currentUserIsCreatorOfLeague) {	
			
			NSString *CellIdentifier = @"BanterCell0";
			UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			}
			
			
			CAGradientLayer *lyrGradient = [CAGradientLayer layer];
			lyrGradient.frame = segBar.frame;		
			lyrGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x222121) CGColor], (id)[UIColorFromRGB(0x000000) CGColor], nil];
			
			[cell.contentView.layer insertSublayer:lyrGradient atIndex:0];
			
			UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Invite Friends", nil]];
			[segmentedControl addTarget:self action:@selector(inviteFriends:) forControlEvents:UIControlEventValueChanged];
			segmentedControl.frame = CGRectMake(15, 4, 290, 30);
			segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
			segmentedControl.momentary = YES;
			[segmentedControl setTintColor:UIColorFromRGB(0x222121)];
			[cell addSubview:segmentedControl];
			
			[segmentedControl release];
			
			return cell;
			
		} else {		
			
			// test to see whether we do the invite friends button
			if (self.currentUserIsCreatorOfLeague) {
				index--;
			}
			
			NSString *CellIdentifier = @"LeagueCell";
			SULeagueDetailMemberTableViewCell *cell = (SULeagueDetailMemberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[SULeagueDetailMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			}
			
			cell.memberPlace.text = [NSString stringWithFormat:@"%i", (index+1)];
			
			NSDictionary *currentUser = [[self.league objectForKey:@"Users"] objectAtIndex:index];
			
			NSURL *url = [NSURL URLWithString:[currentUser objectForKey:@"AvatarUrl"]];
			if (url != nil) {
				UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(26, 8, 22, 22)] autorelease];
				[iv loadFromURL:url];
				[cell addSubview:iv];
			}
			// populate the cells with our users
			
			cell.textLabel.text = [currentUser objectForKey:@"TeamName"];
			
			cell.memberPoints.text = [[currentUser objectForKey:@"Stats"] objectForKey:@"Points"];
				
			return cell;
		}
		
		
	} else {
		// test to see whether we do the new banter button
		
		if (index == 0 && self.currentUserIsPartOfLeague) {	
			
			NSString *CellIdentifier = @"BanterCell0";
			UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			}
			
			
			CAGradientLayer *lyrGradient = [CAGradientLayer layer];
			lyrGradient.frame = segBar.frame;		
			lyrGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x222121) CGColor], (id)[UIColorFromRGB(0x000000) CGColor], nil];
			
			[cell.contentView.layer insertSublayer:lyrGradient atIndex:0];
			
			UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Add Banter", nil]];
			[segmentedControl addTarget:self action:@selector(newBanter:) forControlEvents:UIControlEventValueChanged];
			segmentedControl.frame = CGRectMake(15, 4, 290, 30);
			segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
			segmentedControl.momentary = YES;
			[segmentedControl setTintColor:UIColorFromRGB(0x222121)];
			[cell addSubview:segmentedControl];
			
			[segmentedControl release];
						
			return cell;
			
		} else {
			// test to see whether we do the new banter button
						
			if (self.currentUserIsPartOfLeague) {
				index--;
			}
			
			NSMutableArray *banterSet = [self.league objectForKey:@"Banter"];
			NSDictionary *banterDetails = [banterSet objectAtIndex:index];
			
			NSString *CellIdentifier = [NSString stringWithFormat:@"BanterCell%@", [banterDetails objectForKey:@"BanterId"]];
			NSLog(@"Cell: %@", CellIdentifier);
			SULeagueDetailBanterTableViewCell *cell = (SULeagueDetailBanterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[SULeagueDetailBanterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			}
			
			[cell redrawLabel:[self banterTextForIndex:index]];
			
			NSDictionary *banterUser = [[banterDetails objectForKey:@"BanterMessageContent"] objectForKey: @"User"];
			cell.teamNameLabel.text = [NSString stringWithFormat:@"%@", [banterUser objectForKey:@"TeamName"]];
			cell.dateLabel.text = [NSString stringWithFormat:@"%@", [banterDetails objectForKey:@"DateString"]];
			
			
			NSURL *url = [NSURL URLWithString:[banterUser objectForKey:@"AvatarUrl"]];
			if (url != nil) {
				UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 40, 40)] autorelease];
				[iv loadFromURL:url];
				[cell addSubview:iv];
			}
			return cell;
			
			
		}
		
		
		
		
	}
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (self.viewMode == SULeagueDetailTableViewControllerModeLeague) {
		return 40;
	} else {
		//CGFloat *output = [SULeagueDetailBanterTableViewCell getHeightOfCell:@""];
		int index = indexPath.row;
		if (index == 0 && self.currentUserIsPartOfLeague) {
			return 40;
		} else {
			if (self.currentUserIsPartOfLeague) {
				index--;
			}
			NSMutableArray *banterSet = [self.league objectForKey:@"Banter"];
			NSLog(@"%i out of %i from %@", index, [banterSet count], [banterSet objectAtIndex:index]);
			CGFloat height = [SULeagueDetailBanterTableViewCell getHeightOfCell:[self banterTextForIndex:index]];
			return height;
		}
		//NSLog(@"cell height: %f", height);
	}
	
}

- (NSString *)banterTextForIndex:(NSInteger)indexNo {
	NSMutableArray *banterSet = [self.league objectForKey:@"Banter"];
	NSDictionary *banterDetails = [banterSet objectAtIndex:indexNo];
	NSString *output = [NSString stringWithFormat:@"%@", [banterDetails objectForKey:@"MessageContent"]];
	//NSLog(output);
	return output;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger index = indexPath.row;
	
	
	
	if (self.viewMode == SULeagueDetailTableViewControllerModeLeague) {
		
		if ([self currentUserIsCreatorOfLeague]) {
			index --;
		}
		
		// Navigation logic may go here. Create and push another view controller.
		SUTeamTableViewController *detailViewController = [[SUTeamTableViewController alloc] initWithNibName:nil bundle:nil];
		detailViewController.teamId = [[[self.league objectForKey:@"Users"] objectAtIndex:index] objectForKey:@"Id"];
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		
	}
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"Memory warning");
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.league = nil;
}




@end

