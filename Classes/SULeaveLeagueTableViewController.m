//
//  SULeaveLeagueTableViewController.m
//  PredictorPro
//
//  Created by Alexander Bobin on 16/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULeaveLeagueTableViewController.h"


@implementation SULeaveLeagueTableViewController

@synthesize leagueId, success;


- (void)dealloc {
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)leaveLeagueAction {
	
	// show loading
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Leaving";
	
    [HUD showWhileExecuting:@selector(leaveLeague:) onTarget:self withObject:nil animated:YES];
	
}

- (void)leaveLeague:(NSObject *)arr {
	
	
	self.success = [[SUAPIInterface sharedSUAPIInterface] leaveLeague:self.leagueId];
	
}

- (void)hudWasHidden {
	if (self.success) {
		[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
	} else {
		UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message: [SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
}

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	SUFormTableCellButtonView *cell = (SUFormTableCellButtonView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		
        cell = [[[SUFormTableCellButtonView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.text = @"Leave league";
		
		CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
		bkgView.fillColor = [UIColor blackColor];
		bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
		bkgView.position = CustomCellBackgroundViewPositionSingle;
		cell.backgroundView = bkgView;
        [bkgView release];
		
    }
    
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
    [self leaveLeagueAction];
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

