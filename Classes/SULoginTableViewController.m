//
//  SULoginTableViewController.m
//  PredictorPro
//
//  Created by Justin Small on 08/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SULoginTableViewController.h"


@implementation SULoginTableViewController

@synthesize success;

#pragma mark -
#pragma mark Initialization

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		self.navigationItem.title = @"Login";
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 185)];
		headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamedFallbackToPng:@"loginTop"]];
		self.tableView.tableHeaderView = headerView;
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		[headerView release];
		//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamedFallbackToPng:@"loginBottom"]];
		//self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
		
		// Listen for events
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEmailReturnPressed:) name:EVT_LOGIN_EMAIL_RETURN_PRESS object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPasswordReturnPressed:) name:EVT_LOGIN_PWORD_RETURN_PRESS object:nil];
		
	}
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void) registerAction {
	SURegisterTableViewController *registerTableViewController = [[SURegisterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[[self navigationController] pushViewController:registerTableViewController animated:YES];
	[registerTableViewController release];
}

- (void) loginAction:(NSString *)email password:(NSString *)password {
	
	// show loading 
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading";
	
    // Show the HUD while the provided method executes in a new thread
	NSArray *arr = [[NSArray alloc] initWithObjects:email, password, nil];
    [HUD showWhileExecuting:@selector(loginUser:) onTarget:self withObject:arr animated:YES];
	[arr release];
}

- (void)loginUser:(NSArray *)loginDetails { 
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *email = [loginDetails objectAtIndex:0];
	NSString *password = [loginDetails objectAtIndex:1];
	
	self.success = [[SUAPIInterface sharedSUAPIInterface] loginUserWithEmail:email password:password];
	
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
	if (self.success == YES) {
		PredictorProAppDelegate *appDelegate = (PredictorProAppDelegate *)[[UIApplication sharedApplication] delegate];	
		[appDelegate loadApp];
	} else {
		UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message:[[SUAPIInterface sharedSUAPIInterface] errorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return section == 0 ? 2 : 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%i-%i", indexPath.section, indexPath.row];
	
	if (indexPath.section==0) {
		// Login section
		SUFormTableCellTextFieldView *cell = (SUFormTableCellTextFieldView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
        if (cell == nil) {
			
			CustomCellBackgroundViewPosition pos = CustomCellBackgroundViewPositionBottom;
			if (indexPath.section == 0) {
				if (indexPath.row==0) {
					pos = CustomCellBackgroundViewPositionTop;
				} else {
					pos = CustomCellBackgroundViewPositionBottom;
				}
			} else {
				pos = CustomCellBackgroundViewPositionSingle;
			}
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSString *email = [defaults stringForKey:@"email_preference"];	
			NSString *pass = [defaults stringForKey:@"password_preference"];
			
			switch (indexPath.row) {
				case 0:				
					cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModeEmail returnKey:UIReturnKeyNext] autorelease];
					cell.textLabel.text = @"Email";
					cell.textField.text = email;
					cell.notificationName = EVT_LOGIN_EMAIL_RETURN_PRESS;	
					cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
					break;
				default:
					
					cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModePassword returnKey:UIReturnKeyDone] autorelease];
					cell.textLabel.text = @"Password";
					cell.textField.text = pass;
					cell.notificationName = EVT_LOGIN_PWORD_RETURN_PRESS;
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
        
	} else {
		
		// Register section
		SUFormTableCellNavView *cell = (SUFormTableCellNavView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			CustomCellBackgroundViewPosition pos = CustomCellBackgroundViewPositionBottom;
			if (indexPath.section == 0) {
				if (indexPath.row==0) {
					pos = CustomCellBackgroundViewPositionTop;
				} else {
					pos = CustomCellBackgroundViewPositionBottom;
				}
			} else {
				pos = CustomCellBackgroundViewPositionSingle;
			}
			cell = [[[SUFormTableCellNavView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.text = @"Register";
			CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
			bkgView.fillColor = [UIColor blackColor];
			bkgView.borderColor = UIColorFromRGB(0x3a3c3d);
			bkgView.position = pos;
			cell.backgroundView = bkgView;
			[bkgView release];
		}
		
		return cell;
		
	}
}

#pragma mark -
#pragma mark Events to listen for

- (void)loginEmailReturnPressed:(NSNotification*)notification {
	// NSLog(@"emailReturnPressed called");
	NSIndexPath *passwordIP = [NSIndexPath indexPathForRow:1 inSection:0];
	SUFormTableCellTextFieldView *passwordCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:passwordIP];
	[passwordCell.textField becomeFirstResponder];
}

- (void)loginPasswordReturnPressed:(NSNotification*)notification {
	NSIndexPath *EmailIP = [NSIndexPath indexPathForRow:0 inSection:0];
	SUFormTableCellTextFieldView *emailCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:EmailIP];
	NSIndexPath *passwordIP = [NSIndexPath indexPathForRow:1 inSection:0];
	SUFormTableCellTextFieldView *passwordCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:passwordIP];
	if ([emailCell.textField.text length] > 0 && [passwordCell.textField.text length] > 0) {
		[self loginAction:emailCell.textField.text password:passwordCell.textField.text];
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
	if (indexPath.section == 1) {
		[self registerAction];
	} else {
		SUFormTableCellTextFieldView *thisCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:indexPath];
		[thisCell.textField becomeFirstResponder];
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

