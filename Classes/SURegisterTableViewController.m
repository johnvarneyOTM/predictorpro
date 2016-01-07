//
//  SURegisterTableViewController.m
//  PredictorPro
//
//  Created by Alexander Bobin on 12/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SURegisterTableViewController.h"

@implementation SURegisterTableViewController

@synthesize success;

#pragma mark -
#pragma mark Initialization

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style])) {
		
		self.navigationItem.title = @"Register";
				
		UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Register" 
																	   style:UIBarButtonItemStyleDone
																	  target:self 
																	  action:@selector(saveClick)] autorelease];
		
	
		self.navigationItem.rightBarButtonItem = saveButton;		
		
		// Find out the space needed
		CGSize constraintSize;
		constraintSize.width = 290.0f;
		constraintSize.height = MAXFLOAT;
		NSString *theText = @"Choose your team name carefully; you cannot change it once your account has been created.";
		CGSize theSize = [theText sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, 290.0f, theSize.height+20)];
		UILabel *teamNameLabel = [[UILabel alloc] initWithFrame:headerView.frame];		
		
		// Set it uuuuup
		teamNameLabel.textColor = [UIColor whiteColor];
		teamNameLabel.backgroundColor = [UIColor clearColor];
		teamNameLabel.text = theText;
		teamNameLabel.adjustsFontSizeToFitWidth = NO;
		teamNameLabel.font = [UIFont systemFontOfSize:12.0f];
		teamNameLabel.lineBreakMode = UILineBreakModeWordWrap;
		teamNameLabel.numberOfLines = 2;
		teamNameLabel.textAlignment = UITextAlignmentCenter;
		teamNameLabel.shadowColor = [UIColor blackColor];
		teamNameLabel.shadowOffset = CGSizeMake(0,-1.0); 
		
		[headerView addSubview:teamNameLabel];
		
		self.tableView.tableHeaderView = headerView;
		[headerView release];
		[teamNameLabel release];
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		// Listen for events
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regEmailReturnPressed:) name:EVT_REG_EMAIL_RETURN_PRESS object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regTeamNameReturnPressed:) name:EVT_REG_TNAME_RETURN_PRESS object:nil];
		
    }
	
    return self;
}

- (void) registerAction:(NSString *)teamName email:(NSString *)email password:(NSString *)password {
	// show loading
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Registering";
	
    // Show the HUD while the provided method executes in a new thread
	NSArray *arr = [[[NSArray alloc] initWithObjects:teamName, email, password, nil] autorelease];
    [HUD showWhileExecuting:@selector(registerUser:) onTarget:self withObject:arr animated:YES];
	
}

- (void)registerUser:(NSArray *)registerDetails {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *email = [registerDetails objectAtIndex:1];
	NSString *password = [registerDetails objectAtIndex:2];
	
	
	self.success = [[SUAPIInterface sharedSUAPIInterface] registerUser:[registerDetails objectAtIndex:0] email:[registerDetails objectAtIndex:1] password:[registerDetails objectAtIndex:2]];
	
	if (self.success) {		
		// save the login details
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:email forKey:@"email_preference"];
		[defaults setObject:password forKey:@"password_preference"];
		[defaults synchronize];
	}
	[pool release];
	pool = nil;
}

- (void)hudWasHidden {
	if (self.success) {
		PredictorProAppDelegate *appDelegate = (PredictorProAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate loadApp];
	} else {
		NSLog(@"MESSAGE %@", [[SUAPIInterface sharedSUAPIInterface] errorMessage]);
		UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message:[SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
}

#pragma mark -
#pragma mark Events to listen for

- (void)regTeamNameReturnPressed:(NSNotification*)notification {
	[self makeEmailFirstResponder];
}

- (void)regEmailReturnPressed:(NSNotification*)notification {
	
	// Pass on first responder
	NSIndexPath *passwordIP = [NSIndexPath indexPathForRow:2 inSection:0];
	SUFormTableCellTextFieldView *passwordCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:passwordIP];
	[passwordCell.textField becomeFirstResponder];
	
}

- (void)saveClick {
	
	NSIndexPath *teamNameIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextFieldView *teamNameCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:teamNameIP];
	if ([teamNameCell.textField isFirstResponder]) {
		[teamNameCell.textField resignFirstResponder];
	}
	NSIndexPath *emailIP = [NSIndexPath indexPathForRow:1 inSection:0];
	SUFormTableCellTextFieldView *emailCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:emailIP];
	if ([emailCell.textField isFirstResponder]) {
		[emailCell.textField resignFirstResponder];
	}
	NSIndexPath *passwordIP = [NSIndexPath indexPathForRow:2 inSection:0];
	SUFormTableCellTextFieldView *passwordCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:passwordIP];
	if ([passwordCell.textField isFirstResponder]) {
		[passwordCell.textField resignFirstResponder];
	}
	if ([teamNameCell.textField.text length] > 0 && [emailCell.textField.text length] > 0 && [passwordCell.textField.text length] > 0) {
		[self registerAction:teamNameCell.textField.text email:emailCell.textField.text password:passwordCell.textField.text];		
	}
}

- (void) makeEmailFirstResponder {
	NSIndexPath *emailIP = [NSIndexPath indexPathForRow:1 inSection:0];
	SUFormTableCellTextFieldView *emailCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:emailIP];
	[emailCell.textField becomeFirstResponder];
}

- (void) makeTeamNameFirstResponder {
	NSIndexPath *teamNameIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextFieldView *teamNameCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:teamNameIP];
	[teamNameCell.textField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	if ([alertView.title isEqualToString:@"Email invalid"]) {
//		[self makeTeamNameFirstResponder];
//	}
}

/*
 #pragma mark -
 #pragma mark View lifecycle
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
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
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%i-%i", indexPath.section, indexPath.row];
    
    SUFormTableCellTextFieldView *cell = (SUFormTableCellTextFieldView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		
		// Get position for custom cell drawing
		CustomCellBackgroundViewPosition pos;
		pos = CustomCellBackgroundViewPositionBottom;
		if (indexPath.section == 0) {
			if (indexPath.row==0) {
				pos = CustomCellBackgroundViewPositionTop;
			} else if (indexPath.row==1)  {
				pos = CustomCellBackgroundViewPositionMiddle;
			} else {	
				pos = CustomCellBackgroundViewPositionBottom;
			}
		}
		
		switch (indexPath.row) {
			case 0:
				
				// Team name
				cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModeDefault returnKey:UIReturnKeyNext] autorelease];
				cell.textLabel.text = @"Team name";
				cell.notificationName = EVT_REG_TNAME_RETURN_PRESS;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				
				break;
				
			case 1:
				
				// Email
				cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModeEmail returnKey:UIReturnKeyNext] autorelease];
				cell.textLabel.text = @"Email";
				cell.notificationName = EVT_REG_EMAIL_RETURN_PRESS;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				
				break;
				
			default:
				
				// Password
				cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModePassword returnKey:UIReturnKeyDefault] autorelease];
				cell.textLabel.text = @"Password";
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				
				break;
		}
		
		CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
		bkgView.fillColor = [UIColor blackColor];
		bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
		bkgView.position = pos;
		cell.backgroundView = bkgView;
        [bkgView release];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SUFormTableCellTextFieldView *thisCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:indexPath];
	[thisCell.textField becomeFirstResponder];
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

