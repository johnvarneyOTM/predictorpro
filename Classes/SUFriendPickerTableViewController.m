//
//  SUFriendPickerTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 19/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUFriendPickerTableViewController.h"
@interface SUFriendPickerTableViewController (PrivateMethods)
@end

@implementation SUFriendPickerTableViewController
@synthesize contacts, searchBar, searchResults, leagueId;
#define sectionHeaderHeight 30

#pragma mark -
#pragma mark Initialization



- (void)dealloc {
	NSLog(@"Dealloc");
//	[self.contacts release];
//	self.contacts = nil;
//	[self.searchResults release];
//	self.searchResults = nil;
//	[self.searchBar release];
//	self.searchBar = nil;
//	[self.leagueId release];
//	self.leagueId = nil;
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		
		self.tableView.separatorColor = UIColorFromRGB(0x4f4e4e);
		
		
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	ABAddressBookRef addressBook = ABAddressBookCreate();
	CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
	CFStringRef eml = nil;
	NSMutableArray *peopleWithEmails = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < nPeople; i++) { 
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
		
		NSString *contactFirstLast = @"";
		CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
		CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
		NSString *contactFirst = firstName == NULL ? @"" : (NSString *)firstName;
		NSString *contactLast = lastName == NULL ? @"" : (NSString *)lastName;
		
		if ([contactFirst isEqual:@""] || [contactLast isEqual:[NSNull null]]) {
			contactFirstLast = contactLast;
		} else if ([contactLast isEqual:@""] || [contactLast isEqual:[NSNull null]]) {
			contactFirstLast = contactFirst;
		} else {			
			contactFirstLast = [NSString stringWithFormat:@"%@ %@", contactFirst, contactLast];
		}
		
		NSMutableDictionary *person = [[NSMutableDictionary alloc] init];		
		
		ABMutableMultiValueRef emailMulti = ABRecordCopyValue(ref, kABPersonEmailProperty);
		NSString *contactEmail = @"";
		if (ABMultiValueGetCount(emailMulti) > 0) {
			eml = ABMultiValueCopyValueAtIndex(emailMulti, 0);
			contactEmail = [(NSString *)eml copy];
            CFRelease(eml);

		}
		
		
		if (![contactEmail isEqual:@""] && ![contactFirstLast isEqual:@""]) {
			[person setValue:contactFirstLast forKey:@"Name"];
			[person setValue:contactEmail forKey:@"Email"];
			[peopleWithEmails addObject:person];
		}
		
		CFRelease(emailMulti);
        [contactEmail release];
        if(lastName)
            CFRelease(lastName);
        if(firstName)
            CFRelease(firstName);
        

		[person release];
		person = nil;
	}
	NSLog(@"search bar");
	
	self.searchBar = [[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,50)] autorelease];
	self.searchBar.barStyle = UIBarStyleBlackTranslucent;
	self.searchBar.showsCancelButton = NO;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchBar;
	isSearching = NO;
	
	self.contacts = peopleWithEmails;
    [peopleWithEmails release];
	
	CFRelease(allPeople);
	CFRelease(addressBook);
	NSLog(@"yoohoo all done");
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
					
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
#pragma mark Search Bar delegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if (isSearching) {
		isSearching = FALSE;
		[self.tableView reloadData];
	}
	[self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSLog(@"Searching for text: %@", searchText);
	
	[self populateSearchResults:searchText];
	
	
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	NSLog(@"start editing");
	// we want to remove the right hand side stuff
	if (!isSearching) {
		isSearching = TRUE;
		
		self.searchBar.showsScopeBar = YES;
		[self.searchBar sizeToFit];		
		[self.searchBar setShowsCancelButton:YES animated:YES];
		
		// load up the start of the search results
		[self populateSearchResults:@""];
		[self.searchBar becomeFirstResponder];
		return YES;
	} else {
		return NO;
	}
	
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	self.searchBar.showsScopeBar = NO;
	[self.searchBar sizeToFit];
	
	[self.searchBar setShowsCancelButton:NO animated:YES];
	
	return YES;
}

- (void)populateSearchResults:(NSString *)searchString {
	searchString = [searchString uppercaseString];
	NSMutableArray *output = [[NSMutableArray alloc] init];
	
	
	
	NSDictionary *tempContact;
	NSString *name;
	for (int x = 0; x < [self.contacts count]; x++) {
		tempContact = [self.contacts objectAtIndex:x];
		name = [[tempContact objectForKey:@"Name"] uppercaseString];
		if ([name hasPrefix:searchString]) {
			[output addObject:tempContact];
		}
	}
		
	self.searchResults = output;
    [output release];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return isSearching ? [self.searchResults count] : [self.contacts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.shadowColor = [UIColor blackColor];
		cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    }
	
    NSMutableArray *currContacts = isSearching ? self.searchResults : self.contacts;
	
	cell.textLabel.text = [[currContacts objectAtIndex:indexPath.row] objectForKey:@"Name"];
    // Configure the cell...
    
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

	
	selectedRow = indexPath.row;
	
	NSDictionary *person = nil;
	
	if (isSearching) {
		person = [self.searchResults objectAtIndex:selectedRow];
	} else {
		person = [self.contacts objectAtIndex:selectedRow];
	}
	
	NSString *content = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"inviteConfirmationMessage"];
	NSString *alertMessage = [[NSString alloc] initWithFormat:content, [person objectForKey:@"Name"]];
		
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
    [alertMessage release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES]; 
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1) {
		// ok
		NSDictionary *person = nil;
		
		if (isSearching) {
			person = [self.searchResults objectAtIndex:selectedRow];
		} else {
			person = [self.contacts objectAtIndex:selectedRow];
		}
		
		[self searchBarCancelButtonClicked:self.searchBar];
		self.searchBar.text = @"";
		
		NSString *email = [person objectForKey:@"Email"];
		// show loading
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		
		// Add HUD to screen
		[self.view addSubview:HUD];
		
		// Register for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		HUD.labelText = @"Sending";
		
		// Show the HUD while the provided method executes in a new thread
		[HUD showWhileExecuting:@selector(sendInviteToEmail:) onTarget:self withObject:(NSString *)email animated:YES];
		
		
	} else {
		// do nothing
		NSLog(@"cancel");
		
	}
}


#pragma mark -
#pragma mark sendInvite
- (void) sendInviteToEmail:(NSString *)email {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Sending invite to: %@", email);
	saveSuccessful = [[SUAPIInterface sharedSUAPIInterface] sendInviteForLeague:self.leagueId email:email];
	
	[pool release];
	pool = nil;
}

#pragma mark -
#pragma mark MBProgressHUD delegate methods
- (void)hudWasHidden {
	
	NSString *message = @"";
	NSString *title = @"";
	if (saveSuccessful) {
		title = @"Get In!";
		message = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"inviteSuccessfulMessage"];
	} else {
		// show alert
		title = @"Woops";
		message = [[SUAPIInterface sharedSUAPIInterface] errorMessage];
	}
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	
	[self.tableView reloadData];
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
	self.contacts = nil;
	self.searchResults = nil;
	self.searchBar = nil;
	self.leagueId = nil;
}



@end

