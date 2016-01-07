//
//  SUTeamTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUTeamTableViewController.h"


@implementation SUTeamTableViewController
@synthesize userLeagues, teamId, userDetails;
#define sectionHeaderHeight 25


- (void)dealloc {
	self.userDetails = nil;
	self.teamId = nil;
	self.userLeagues = nil;
	
    [super dealloc];
}

-(void)loadDataById {
		
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (self.teamId == nil) {
		self.teamId = [[SUAPIInterface sharedSUAPIInterface] userId];
	} 
	
	NSDictionary *user = [[SUAPIInterface sharedSUAPIInterface] getUserDetails:self.teamId];
	[self.userDetails setData:[user objectForKey:@"User"]];
	NSDictionary *data = [[SUAPIInterface sharedSUAPIInterface] getLeaguesForUser:self.teamId];
	
	self.navigationItem.title = [[user objectForKey:@"User"] objectForKey:@"TeamName"];
	
	self.userLeagues = [[[data objectForKey:@"Leagues"] copy] autorelease];
	
	if ([self.teamId isEqual:[[SUAPIInterface sharedSUAPIInterface] userId]]) {
		
		UIBarButtonItem * editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonSystemItemAction target:self action:@selector(editTeam)] autorelease];	
		self.navigationItem.rightBarButtonItem = editButton;
		
	}
	
	[self.tableView setNeedsLayout];
	[self.tableView reloadData];
	
	[pool release];
	pool = nil;
}

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.userDetails = [[[SUTeamDetailView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 444.0f)] autorelease];	
	self.userDetails.parentController = self;
	[self.tableView setTableHeaderView:self.userDetails];
	
	self.view.backgroundColor = UIColorFromRGB(0x2e2f30); 
	
	
}
- (void)editTeam {	
	SUEditTeamTableViewController *editTeamViewController = [[[SUEditTeamTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:editTeamViewController animated:YES];
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
	return [userLeagues count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary *currentLeague = [self.userLeagues objectAtIndex:indexPath.row]; // en fix bug
	
	cell.backgroundColor = UIColorFromRGB(0x292727);
	//cell.backgroundColor = [UIColor clearColor];
	
	cell.textLabel.text = [currentLeague objectForKey:@"LeagueName"];
	cell.textLabel.shadowColor = UIColorFromRGB(0x666666);
	cell.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	// the number of participants is added as a 
	int numberOfParticipants = [[currentLeague objectForKey:@"Users"] count];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", numberOfParticipants];
	cell.detailTextLabel.backgroundColor = UIColorFromRGB(0x00ff00);
	
	UIView *accessoryFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
	
	UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"leaguePlaceBackground"]];
	backgroundImg.frame = CGRectMake(15,5,33,20);
	[accessoryFrame addSubview:backgroundImg];
	[backgroundImg release];
	
	UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 35, 30)];
	positionLabel.backgroundColor = [UIColor clearColor];
	int position = [[NSString stringWithFormat:@"%@",	[currentLeague objectForKey:@"UsersPosition"]] intValue];
	if (position == 0) {
		positionLabel.text = [NSString stringWithFormat:@"%i" , position];
	} else if (position == 1) {
		positionLabel.text = [NSString stringWithFormat:@"%ist" , position];	
	} else if (position == 2) {
		positionLabel.text = [NSString stringWithFormat:@"%ind" , position];	
	} else if (position == 3) {
		positionLabel.text = [NSString stringWithFormat:@"%ird" , position];	
	} else {
		positionLabel.text = [NSString stringWithFormat:@"%ith" , position];	
	}
	positionLabel.font = [UIFont systemFontOfSize:11];
	positionLabel.shadowColor = UIColorFromRGB(0x8c8c8c);
	positionLabel.textAlignment = UITextAlignmentCenter;
	positionLabel.textColor = UIColorFromRGB(0xFFFFFF);
	
	[accessoryFrame addSubview:positionLabel];
	[positionLabel release];  
	
	cell.accessoryView = accessoryFrame;
	[accessoryFrame release];
	
	
	return cell;
	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"LEAGUES"; 
}

- (CGFloat)tableView:(UITableView *)predictionsTableView heightForHeaderInSection:(NSInteger)section {
	if ([self tableView:predictionsTableView titleForHeaderInSection:section] != nil) {
		return sectionHeaderHeight;
	}
	else {
		// If no section header title, no section header needed
		return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	
	if (sectionTitle == nil) {
		return nil;
	}
	
	UIView *output = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,sectionHeaderHeight)] autorelease];
	output.opaque = YES;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,0,300, sectionHeaderHeight)];
	label.backgroundColor = UIColorFromRGB(0x2e2f30);
	label.text = sectionTitle;
	label.textColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0.0, -1.0);
	label.shadowColor = [UIColor blackColor];
	label.font = [UIFont boldSystemFontOfSize:11];
	label.opaque = YES;
	[output addSubview:label];
	[label release];
	return output;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//  DISALLOW CLICK THROUGH FOR ALL
//	if ([self.teamId isEqual:[[SUAPIInterface sharedSUAPIInterface] userId]]) {
//		SULeagueDetailTableViewController *leagueDetailViewController = [[[SULeagueDetailTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
//		// Pass the selected object to the new view controller.
//		NSDictionary *league = [userLeagues objectAtIndex:indexPath.row];
//		// this conversion of object -> string -> int seems the most reliable method :s
//		leagueDetailViewController.leagueId = [league objectForKey:@"Id"];
//		[self.navigationController pushViewController:leagueDetailViewController animated:YES];
//	}
	
}


#pragma mark -
#pragma mark HUD delegate methods
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

