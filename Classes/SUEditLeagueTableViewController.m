//
//  SUEditLeagueTableViewController.m
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUEditLeagueTableViewController.h"


@implementation SUEditLeagueTableViewController

@synthesize thisMode, league, success;

- (void)dealloc {
    self.league = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style viewMode:(SUEditLeagueTableViewMode)thisViewMode {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		[self setThisMode:(SUEditLeagueTableViewMode *)thisViewMode];
				
		switch ((int)self.thisMode) {
			case SUEditLeagueTableViewModeCreate:
				self.navigationItem.title = @"Create league";
				break;
			default:
				self.navigationItem.title = @"Edit league";
				break;
		}
		
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	// Put up the button
	UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(saveClicked)] autorelease];
	self.navigationItem.rightBarButtonItem = saveButton;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if ((int)self.thisMode == SUEditLeagueTableViewModeEdit) {
		
		NSIndexPath *nameIP = [NSIndexPath indexPathForRow:0 inSection:0];
		SUFormTableCellTextFieldView *nameCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:nameIP];
		
		NSIndexPath *inviteOnlyIP = [NSIndexPath indexPathForRow:0 inSection:1];
		SUFormTableCellSwitchView *inviteOnlyCell = (SUFormTableCellSwitchView *)[self.tableView cellForRowAtIndexPath:inviteOnlyIP];
		
		NSIndexPath *descriptionIP = [NSIndexPath indexPathForRow:0 inSection:2];
		SUFormTableCellTextViewView *descriptionCell = (SUFormTableCellTextViewView *)[self.tableView cellForRowAtIndexPath:descriptionIP];
		
		nameCell.textField.text = [self.league objectForKey:@"LeagueName"];
		descriptionCell.thisTextView.text = [self.league objectForKey:@"LeagueDescription"];
		NSLog(@"League invite: %@", [self.league objectForKey:@"Type"]);
		inviteOnlyCell.thisSwitch.on = [[self.league objectForKey:@"Type"] isEqualToString:@"closed"];
		
	}
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

- (void) saveClicked {

	NSIndexPath *nameIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextFieldView *nameCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:nameIP];
	if ([nameCell.textField isFirstResponder]) {
		[nameCell.textField resignFirstResponder];
	}
	
	NSIndexPath *descriptionIP = [NSIndexPath indexPathForRow:0 inSection:2];
	SUFormTableCellTextViewView *descriptionCell = (SUFormTableCellTextViewView *)[self.tableView cellForRowAtIndexPath:descriptionIP];
	if ([descriptionCell.thisTextView isFirstResponder]) {
		[descriptionCell.thisTextView resignFirstResponder];
	}
	 // new thread is to ensure that firstresponderstatus is resigned 
    [NSThread detachNewThreadSelector:@selector(sendSaveAction) toTarget:self withObject:nil];
}

- (void) sendSaveAction {
	
	sleep(1);
	
	NSIndexPath *nameIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextFieldView *nameCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:nameIP];
	
	NSIndexPath *inviteOnlyIP = [NSIndexPath indexPathForRow:0 inSection:1];
	SUFormTableCellSwitchView *inviteOnlyCell = (SUFormTableCellSwitchView *)[self.tableView cellForRowAtIndexPath:inviteOnlyIP];
	
	NSIndexPath *descriptionIP = [NSIndexPath indexPathForRow:0 inSection:2];
	SUFormTableCellTextViewView *descriptionCell = (SUFormTableCellTextViewView *)[self.tableView cellForRowAtIndexPath:descriptionIP];
	
	if ([nameCell.textField.text length] > 0 && [descriptionCell.thisTextView.text length] > 0 && [descriptionCell.thisTextView.text length] < 1024) {
		[self saveAction:nameCell.textField.text inviteOnly:inviteOnlyCell.thisSwitch.on description:descriptionCell.thisTextView.text];
	} else {
		
		NSString *errorMessage = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"editLeagueValidationMessage"];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
}

- (void) saveAction:(NSString *)name inviteOnly:(BOOL)inviteOnly description:(NSString *)description {
	
	// show loading
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Saving";
	
	
    // Show the HUD while the provided method executes in a new thread
	NSArray *arr = [[[NSArray alloc] initWithObjects:name, inviteOnly == YES ? @"closed" : @"open", description, nil] autorelease];
    [HUD showWhileExecuting:@selector(saveLeague:) onTarget:self withObject:arr animated:YES];
	
}

- (void)saveLeague:(NSArray *)leagueDetails { // this will probably be the function that calls the WS	
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *lName = [leagueDetails objectAtIndex:0];
	NSString *lDescription = [leagueDetails objectAtIndex:2];
	NSString *lInviteOnly = [leagueDetails objectAtIndex:1];
	
	if (self.league == nil) {
		self.success = [[SUAPIInterface sharedSUAPIInterface] createLeague:lName inviteOnly:lInviteOnly description:lDescription] == YES;
	} else {
		self.success = [[SUAPIInterface sharedSUAPIInterface] editLeague:[self.league objectForKey:@"Id"] name:lName inviteOnly:lInviteOnly description:lDescription] == YES;
	}
	
	[pool release];
	pool = nil;
	
}

- (void)hudWasHidden {
	if (self.success) {
		[self.navigationController popViewControllerAnimated: YES];
	} else {
		UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message: [SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
		return 150;
	} else {
		return 50;
	}
}

// specify the height of your footer section
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
		return 70;
	} else {
		return 0;
	}
}

// custom view for footer. will be adjusted to default or specified footer height
// Notice: this will work only for one section within the table view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	if (section == 1) {
		if(footerView == nil) {
			
			// Find out the space needed
			CGSize constraintSize;
			constraintSize.width = 290.0f;
			constraintSize.height = MAXFLOAT;
			NSString *theText = @"Invite only leagues are not displayed in any lists, you'll have to send your friends invites before they can join. This can be changed at any time.";
			CGSize theSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
			
			footerView = [[[UIView alloc] initWithFrame:CGRectMake(15, 0, 290.0f, theSize.height+20)] autorelease];
			UILabel *inviteOnlyLabel = [[[UILabel alloc] initWithFrame:footerView.frame] autorelease];		
			
			// Set it uuuuup
			inviteOnlyLabel.textColor = [UIColor whiteColor];
			inviteOnlyLabel.backgroundColor = [UIColor clearColor];
			inviteOnlyLabel.text = theText;
			inviteOnlyLabel.adjustsFontSizeToFitWidth = NO;
			inviteOnlyLabel.font = [UIFont systemFontOfSize:12.0f];
			inviteOnlyLabel.lineBreakMode = UILineBreakModeWordWrap;
			inviteOnlyLabel.numberOfLines = 3;
			inviteOnlyLabel.textAlignment = UITextAlignmentCenter;
			inviteOnlyLabel.shadowColor = [UIColor blackColor];
			inviteOnlyLabel.shadowOffset = CGSizeMake(0,-1.0); 
			
			[footerView addSubview:inviteOnlyLabel];
			
		}
		
		//return the view for the footer
		return footerView;
	} else {
		return nil;
	}
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%i-%i", indexPath.section, indexPath.row];
    
    if (indexPath.section == 0) {
		
		SUFormTableCellTextFieldView *cell = (SUFormTableCellTextFieldView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			
			cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModeDefault  returnKey:UIReturnKeyDefault] autorelease];
			cell.textLabel.text = @"Name";
			
			CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
			bkgView.fillColor = [UIColor blackColor];
			bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
			bkgView.position = CustomCellBackgroundViewPositionSingle;
			cell.backgroundView = bkgView;
            [bkgView release];
		}
		
		return cell;
		
	} else if (indexPath.section == 1) {
		
		SUFormTableCellSwitchView *cell = (SUFormTableCellSwitchView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			
			// Team name
			cell = [[[SUFormTableCellSwitchView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.text = @"Invite only?";
			
			CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
			bkgView.fillColor = [UIColor blackColor];
			bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
			bkgView.position = CustomCellBackgroundViewPositionSingle;
			cell.backgroundView = bkgView;
            [bkgView release];
		}
		
		return cell;
		
	} else if (indexPath.section == 2) {
		
		SUFormTableCellTextViewView *cell = (SUFormTableCellTextViewView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			
			cell = [[[SUFormTableCellTextViewView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.thisLabel.text = @"Description";
			
			CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
			bkgView.fillColor = [UIColor blackColor];
			bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
			bkgView.position = CustomCellBackgroundViewPositionSingle;
			cell.backgroundView = bkgView;
            [bkgView release];
		}
		
		return cell;
		
	}

	return nil;
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
	
	// do nothing
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

