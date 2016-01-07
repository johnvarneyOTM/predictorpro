//
//  SUPredictionsTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 28/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPredictionsTableViewController.h"
#import "SUPredictionsTableViewCell.h"
#import "SUPredictionsTableViewHeader.h"
#import "SUPredictionsTableViewSectionHeader.h"
#import "SUPredictionsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@implementation SUPredictionsTableViewController

@synthesize tableHeader, sectionHeaders, rowsForSection;
@synthesize totalBankers, remainingBankers, newerRoundId, olderRoundId;
// A few local constants
#define sectionHeaderHeight 25


- (void)dealloc {
	self.sectionHeaders = nil;
	self.rowsForSection = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark Table viewdata reloading


-(BOOL)loadDataForRound:(NSInteger)roundId {
		
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *data = nil;
	
	if (roundId != 0) {
		data = [[SUAPIInterface sharedSUAPIInterface] getMatchesForRound:roundId];	
	} else if ([[SUAPIInterface sharedSUAPIInterface] currentRoundId] != 0) {
		data = [[SUAPIInterface sharedSUAPIInterface] getMatchesForRound:[[SUAPIInterface sharedSUAPIInterface] currentRoundId]];	
	} else { 
		data = [[SUAPIInterface sharedSUAPIInterface] getLatestMatches];	
	}
	
	if (data != nil) {
				
		sectionHeaders = [[NSMutableArray alloc] init];
		rowsForSection = [[NSMutableArray alloc] init];
				
		[[SUAPIInterface sharedSUAPIInterface] setCurrentRoundId:(NSInteger)[[[data objectForKey:@"Round"] objectForKey:@"Id"] intValue]];
		self.totalBankers = (NSInteger)[[[data objectForKey:@"Round"] objectForKey:@"BankerCount"] intValue];
		self.remainingBankers = self.totalBankers;
		self.newerRoundId = (NSInteger)[[[data objectForKey:@"Round"] objectForKey:@"NextRoundId"] intValue];
		self.olderRoundId = (NSInteger)[[[data objectForKey:@"Round"] objectForKey:@"PreviousRoundId"] intValue];
				
		if (self.newerRoundId == 0) {
			self.navigationItem.rightBarButtonItem = nil;
		} else {			
			UIBarButtonItem * newerButton =
			[[[UIBarButtonItem alloc]
			  initWithTitle:@"Newer" style:UIBarButtonSystemItemAction target:self action:@selector( setNewerRound )] autorelease];	
			self.navigationItem.rightBarButtonItem = newerButton;
		}
		
		if (self.olderRoundId == 0) {
			self.navigationItem.leftBarButtonItem = nil;
		} else {			
			UIBarButtonItem * olderButton =
			[[[UIBarButtonItem alloc]
			  initWithTitle:@"Older" style:UIBarButtonSystemItemAction target:self action:@selector( setOlderRound )] autorelease];	
			self.navigationItem.leftBarButtonItem = olderButton;
		}
		
		NSString *prevDay = @"";
		
		for (NSDictionary *m in [[data objectForKey:@"Round"] objectForKey:@"Matches"]) {
			
			NSString *raw = [m objectForKey:@"DateLocalString"];
			
			// Parse the date into dd/mm/yyyy
			NSString *day = [raw substringToIndex:[raw length] - 6];
			if ([day isEqualToString:prevDay]) {
				int indexOfDay = [self.sectionHeaders indexOfObject:day];
				[[self.rowsForSection objectAtIndex:indexOfDay] addObject:m];
			} else {
				// create a new array of matches
				[self.sectionHeaders addObject:day];
				NSMutableArray *matchesforSection = [[NSMutableArray alloc] init];
				[matchesforSection addObject:m];
				[self.rowsForSection addObject:matchesforSection];
				[matchesforSection release];
			}
			prevDay = day;
			
			// calculate bankersRemaining
			NSDictionary *pred = [m objectForKey:@"Prediction"];
			if (![pred isEqual:[NSNull null]] && totalBankers > 0) {
				remainingBankers = remainingBankers - (NSInteger)[[pred objectForKey:@"Banker"] intValue];
			}						
		}
		
		// Update the header stats here		
		[tableHeader setData:(NSDictionary *)[[data objectForKey:@"Round"] objectForKey:@"UserStats"]];
		
		self.tableHeader.bankerSummary.text = [NSString stringWithFormat:@"%i/%i", remainingBankers, totalBankers];
				
		[self synchingDone:NULL];
		
		[self.tableView setNeedsLayout];
		[self.tableView reloadData];
		
		
	} else {
		// show alert
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Woops" message:[[SUAPIInterface sharedSUAPIInterface] errorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}

	[pool release];
	return YES;
		
}

-(BOOL)loadOlderData {
	if (self.olderRoundId == 0) {
		return NO;
	}
	return [self loadDataForRound:(NSInteger)self.olderRoundId];
}

-(BOOL)loadNewerData {
	if (self.newerRoundId == 0) {
		return NO;
	}
	return [self loadDataForRound:(NSInteger)self.newerRoundId];
}

-(void)refreshRound {
	[self loadDataForRound:(NSInteger)[[SUAPIInterface sharedSUAPIInterface] currentRoundId]];

}

-(void)setOlderRound {
	// show loading
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(loadOlderData) onTarget:self withObject:nil animated:YES];
	
}

-(void)setNewerRound {
	
	// show loading
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(loadNewerData) onTarget:self withObject:nil animated:YES];
	
}

#pragma mark -
#pragma mark Pull to refresh overrides

- (void)synchingDone:(NSNotification *)notification {
	[super dataSourceDidFinishLoadingNewData];
	refreshHeaderView.lastUpdatedDate = [NSDate date];
}

- (void)reloadTableViewDataSource {	
	[self performSelectorInBackground:@selector(refreshRound) withObject:nil ];
	
}


#pragma mark -
#pragma mark MBProgressHUD delegate methods
- (void)hudWasHidden {

}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];	
		
	self.view.backgroundColor = UIColorFromRGB(0xe2e7ed);
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.separatorColor = [UIColor blackColor];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	UIBarButtonItem * newerButton =
	[[[UIBarButtonItem alloc]
	  initWithTitle:@"Newer" style:UIBarButtonSystemItemAction target:self action:@selector( setNewerRound )] autorelease];	
	self.navigationItem.rightBarButtonItem = newerButton;
	
	UIBarButtonItem * olderButton =
	[[[UIBarButtonItem alloc]
	  initWithTitle:@"Older" style:UIBarButtonSystemItemAction target:self action:@selector( setOlderRound )] autorelease];	
	self.navigationItem.leftBarButtonItem = olderButton;
	
	self.tableHeader = [[[SUPredictionsTableViewHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 80.0f)] autorelease];
	[self.tableView setTableHeaderView:self.tableHeader];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// show loading
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading";
		
    // Show the HUD while the provided method executes in a new thread
	// [[SUAPIInterface sharedSUAPIInterface] setCurrentRoundId:(NSInteger)0];
	
	self.sectionHeaders=nil;
	[self.tableView reloadData];
	
    [HUD showWhileExecuting:@selector(loadDataForRound:) onTarget:self withObject:nil animated:YES];
	// end
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];			
	
	
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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sectionHeaders count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[rowsForSection objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
									 
- (CGFloat)tableView:(UITableView *)predictionsTableView heightForHeaderInSection:(NSInteger)section {
	 if ([self tableView:predictionsTableView titleForHeaderInSection:section] != nil) {
		 return sectionHeaderHeight;
	 } else {
		 // If no section header title, no section header needed
		 return 0;
	 }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionHeaders objectAtIndex:section]; 
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	
	NSDictionary *match = [[self.rowsForSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSDictionary *prediction = [match objectForKey:@"Prediction"];
	NSString *banker = @"no";
	NSString *predicted = @"no";
	if (![prediction isEqual:[NSNull null]]) {
		banker = [[prediction objectForKey:@"Banker"] intValue] == 1 ? @"yes" : @"no";
		predicted = @"yes";
	}	
	
    NSString *CellIdentifier = [[[NSString alloc] initWithFormat:@"cell-%@-%d-%@-%@", sectionTitle, indexPath.row, banker, predicted] autorelease];	
		
    SUPredictionsTableViewCell *cell = (SUPredictionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {				
        cell = [[[SUPredictionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	// TODO: instead of setting the colour in the cell we should do the logic here and pass it through in the init. This will allow for a static cellIdentifier.
	[cell setData:match];
		
	return cell;
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
			
	SUPredictionsTableViewCell *cell = (SUPredictionsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

	if (cell.cellMode != SUPredictionsTableViewCellModeClosed) {
	
		SUPredictionsDetailViewController *predictionsDetailViewController = [[SUPredictionsDetailViewController alloc] initWithNibName:nil bundle:nil data:cell.match maxBankers:self.totalBankers remainingBankers:self.remainingBankers];
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:predictionsDetailViewController animated:YES];
		[predictionsDetailViewController release];
		predictionsDetailViewController = nil;
		
	}
	 
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

