//
//  SUAddBanterTableViewController.m
//  PredictorPro
//
//  Created by Sumac on 16/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUAddBanterTableViewController.h"


@implementation SUAddBanterTableViewController

@synthesize league;


- (void)dealloc {
	self.league = nil;
	
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
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Put up the button
	UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Post" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(saveClicked)] autorelease];
	self.navigationItem.rightBarButtonItem = saveButton;
	self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);

}



- (void) saveClicked {
	
	NSIndexPath *banterIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextViewView *banterCell = (SUFormTableCellTextViewView *)[self.tableView cellForRowAtIndexPath:banterIP];
	if ([banterCell.thisTextView isFirstResponder]) {
		[banterCell.thisTextView resignFirstResponder];
	}
	
	NSInteger banterLength = [banterCell.thisTextView.text length];
	
	if ([banterCell.thisTextView.text length] > 0 && banterLength <= 75) {
		[self saveAction:banterCell.thisTextView.text];
	} else {
		// show error
		NSString *errorContent = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"banterLengthMessage"];
		NSString *errorString = [[NSString alloc] initWithFormat:errorContent, banterLength];
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Woops" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorString release];
		[errorAlert show];
		[errorAlert release];
		
	}

	
}
- (void) saveAction:(NSString *)banter {
	
	// show loading
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Posting";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(saveLeagueBanter:) onTarget:self withObject:banter animated:YES];
	
}

- (void)saveLeagueBanter:(NSString *)banter { // this will probably be the function that calls the WS	
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	success = NO;
	NSString *leagueId = [NSString stringWithFormat:@"%@", [self.league objectForKey:@"Id"]];
	success = [[SUAPIInterface sharedSUAPIInterface] addBanter:leagueId banter:banter];
	
	[pool release];
	pool = nil;
	
}

- (void)hudWasHidden {
	if (success) {
		[self.navigationController popViewControllerAnimated: YES];

	} else {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Woops" message: [SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}


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
	
	SUFormTableCellTextViewView *cell = (SUFormTableCellTextViewView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		
		cell = [[[SUFormTableCellTextViewView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.thisLabel.text = @"Add Banter";
		
		CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
		bkgView.fillColor = [UIColor blackColor];
		bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
		bkgView.position = CustomCellBackgroundViewPositionSingle;
		cell.backgroundView = bkgView;
        [bkgView release];
	}
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 200;
}


// custom view for footer. will be adjusted to default or specified footer height
// Notice: this will work only for one section within the table view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	if (section == 0) {
			
		// Find out the space needed
		CGSize constraintSize;
		constraintSize.width = 290.0f;
		constraintSize.height = MAXFLOAT;
		NSString *theText = @"Wind up your fellow league members but please keep it clean and reasonably polite!  Max length is 75 characters.";
		CGSize theSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
		UIView *footerView  = [[[UIView alloc] initWithFrame:CGRectMake(15, 0, 290.0f, theSize.height+20)] autorelease];
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
			
		
		//return the view for the footer
		return footerView;
	} else {
		return nil;
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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

