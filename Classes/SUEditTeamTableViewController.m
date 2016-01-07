//
//  SUEditTeamTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 14/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUEditTeamTableViewController.h"


@implementation SUEditTeamTableViewController

@synthesize success;

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style])) {
		
		UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" 
																	   style:UIBarButtonItemStyleBordered 
																	  target:self 
																	  action:@selector(saveDetails)] autorelease];
		
		self.navigationItem.rightBarButtonItem = saveButton;
		
		self.navigationItem.title = @"Edit details";
		
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		// Listen for events
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editEmailReturnPressed:) name:EVT_EDIT_EMAIL_RETURN_PRESS object:nil];
		
    }
	
    return self;
}

- (void) saveDetails {
	
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
	if ([emailCell.textField.text length] > 0 && [passwordCell.textField.text length] > 0) {
		[self editAction:emailCell.textField.text password:passwordCell.textField.text];		
	}
}

- (void) editAction:(NSString *)email password:(NSString *)password {
	
	// show loading
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
	
    // Add HUD to screen
    [window addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Saving";
	
    // Show the HUD while the provided method executes in a new thread
	NSArray *arr = [[[NSArray alloc] initWithObjects:email, password, nil] autorelease];
    [HUD showWhileExecuting:@selector(editUser:) onTarget:self withObject:arr animated:YES];
	
}

- (void)editUser:(NSArray *)editDetails { // this will probably be the function that calls the WS
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *email = [editDetails objectAtIndex:0];
	NSString *password = [editDetails objectAtIndex:1];
	
	self.success = [[SUAPIInterface sharedSUAPIInterface] editUser:[editDetails objectAtIndex:0] password:[editDetails objectAtIndex:1]];

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
		[self.navigationController popViewControllerAnimated: YES];
	} else {
		UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle: @"Woops" message:[SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
}

#pragma mark -
#pragma mark Events to listen for

- (void)editEmailReturnPressed:(NSNotification*)notification {
	
	// Pass on first responder
	NSIndexPath *passwordIP = [NSIndexPath indexPathForRow:2 inSection:0];
	SUFormTableCellTextFieldView *passwordCell = (SUFormTableCellTextFieldView *)[self.tableView cellForRowAtIndexPath:passwordIP];
	[passwordCell.textField becomeFirstResponder];
	
}

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
    
    if (indexPath.row > 0) {
		
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
					
				case 1:
					
					// Email
					cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModeEmail returnKey:UIReturnKeyNext] autorelease];
					cell.textLabel.text = @"Email";
					cell.notificationName = EVT_EDIT_EMAIL_RETURN_PRESS;
					cell.textField.text = [[SUAPIInterface sharedSUAPIInterface] email];
					
					break;
					
				default:
					
					// Password
					cell = [[[SUFormTableCellTextFieldView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellType:SUFormTableCellTextFieldViewModePassword returnKey:UIReturnKeyDefault] autorelease];
					cell.textLabel.text = @"Password";
					cell.textField.text = [[SUAPIInterface sharedSUAPIInterface] password];
					
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
	
		SUFormTableCellLabelView *cell = (SUFormTableCellLabelView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
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
							
			// Team name
			cell = [[[SUFormTableCellLabelView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.text = @"Team name";
			cell.thisLabel.text = [[SUAPIInterface sharedSUAPIInterface] teamName];
			
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row > 0) {
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

