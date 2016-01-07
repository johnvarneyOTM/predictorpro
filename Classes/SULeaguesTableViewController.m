//
//  SULeaguesTableViewController.m
//  PredictorPro
//
//  Created by Sumac on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULeaguesTableViewController.h"
#import "SUPredictionsTableViewSectionHeader.h"
#import "SUAllLeaguesTableViewController.h"


@implementation SULeaguesTableViewController
@synthesize userLeagues;


- (void)dealloc {
//	[self.userLeagues release];
//	self.userLeagues = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}*/


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


-(void)loadDataById {
		
    @autoreleasepool {
        NSString *userId = [[SUAPIInterface sharedSUAPIInterface] userId];
        NSDictionary *data = [[SUAPIInterface sharedSUAPIInterface] getLeaguesForUser:userId];	
        
        
        //userLeagues = [[NSMutableArray alloc] init];
        userLeagues = [[data objectForKey:@"Leagues"] copy];
        //NSLog(@"league 0: %@", [[userLeagues objectAtIndex:0] objectForKey:@"LeagueName"]);
        //NSLog(@"leagues: %i", [userLeagues count]);
        
        [self.tableView setNeedsLayout];
        [self.tableView reloadData];
        
        [self synchingDone:NULL];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];		
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	
	self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
	
	self.tableView.separatorColor = UIColorFromRGB(0x4f4e4e);
	self.tableView.sectionHeaderHeight = 30;
	
	// Put up the button
	UIBarButtonItem *createButton = [[[UIBarButtonItem alloc] initWithTitle:@"Create" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(createLeagueClicked)] autorelease];
	self.navigationItem.rightBarButtonItem = createButton;
	
	//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainBackground" ofType:@"png" inDirectory:@"/"]]];
	
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
- (void)hudWasHidden {
	
}

-(void) createLeagueClicked {
	SUEditLeagueTableViewController *editLeagueViewController = [[[SUEditLeagueTableViewController alloc] initWithStyle:UITableViewStyleGrouped viewMode:SUEditLeagueTableViewModeCreate] autorelease];
	[self.navigationController pushViewController:editLeagueViewController animated:YES];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if ([userLeagues count] > 0) {
		return 2;
	}
	
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return 1; // for all leagues
	} else {
		// get a listing of the l
		
		return [userLeagues count];
	}
    //return number of rows in section;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Leagues";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if ([indexPath indexAtPosition:0] == 0) {
		// we are the "All Leagues" 
		cell.textLabel.text = @"All Leagues";
		cell.textLabel.shadowColor = UIColorFromRGB(0x666666);
		cell.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
		cell.backgroundColor = UIColorFromRGB(0x292727);
		//cell.backgroundColor = [UIColor clearColor];
		
		// white arrow
		UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"accDisclosureWhite"]];
		cell.accessoryView = accessory;
		[accessory release];
		
		return cell;
		
	} else {
		// we are one of the other buttons
        
		
		NSDictionary *currentLeague = [self.userLeagues objectAtIndex:indexPath.row];
		
		cell.backgroundColor = UIColorFromRGB(0x292727);
		//cell.backgroundColor = [UIColor clearColor];
		
		cell.textLabel.text = [currentLeague objectForKey:@"LeagueName"];
		cell.textLabel.shadowColor = UIColorFromRGB(0x666666);
		cell.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
		
		// the number of participants is added as a 
		int numberOfParticipants = [[currentLeague objectForKey:@"Users"] count];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", numberOfParticipants];
		cell.detailTextLabel.backgroundColor = UIColorFromRGB(0x00ff00);
		
		UIView *accessoryFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
		
		UIImageView *accessoryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"accDisclosureWhite"]];
		accessoryImg.frame = CGRectMake(31,0,30,30);
		[accessoryFrame addSubview:accessoryImg];
		[accessoryImg release];
		
		UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"leaguePlaceBackground"]];
		backgroundImg.frame = CGRectMake(1,5,33,20);
		[accessoryFrame addSubview:backgroundImg];
		[backgroundImg release];
		
		UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 35, 30)];
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

    
	
    
    // Configure the cell...
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == 1 ? @"My Leagues" : @"All Leagues"; 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	
	if (sectionTitle == nil) {
		return nil;
	}
	
	UIView *output = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)] autorelease];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300, 30)];
	//label.backgroundColor = UIColorFromRGB(0x3a3c3d);
	label.backgroundColor = [UIColor clearColor];
	label.text = sectionTitle;
	//label.text = @"Test";
	label.textColor = UIColorFromRGB(0xFFFFFF);
	label.shadowColor = UIColorFromRGB(0x8c8c8c);
	label.font = [UIFont systemFontOfSize:16];
	[output addSubview:label];
	[label release];
	return output;}


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
    // Navigation logic may go here. Create and push another view controller.
	
	if ( indexPath.section == 0) {
		// 
		SUAllLeaguesTableViewController *controller = [[SUAllLeaguesTableViewController alloc] initWithStyle:UITableViewStylePlain];

		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		
	} else {	
		NSDictionary *league = [self.userLeagues objectAtIndex:indexPath.row];
		// this conversion of object -> string -> int seems the most reliable method :s
		[self loadDetailForLeague:[league objectForKey:@"Id"]];
	}
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
	self.userLeagues = nil;
}


@end

