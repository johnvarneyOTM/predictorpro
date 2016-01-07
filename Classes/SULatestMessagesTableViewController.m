//
//  SULatestMessagesTableViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULatestMessagesTableViewController.h"

@interface SULatestMessagesTableViewController (PrivateMethods) 


@end


@implementation SULatestMessagesTableViewController

@synthesize messages;


- (void)dealloc {
	self.messages = nil;
	
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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem * helpButton = [[[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonSystemItemAction target:self action:@selector(setHelp)] autorelease];	
	self.navigationItem.rightBarButtonItem = helpButton;
	
	
	self.tableView.backgroundColor = UIColorFromRGB(0x3a3c3d);
	self.tableView.separatorColor = UIColorFromRGB(0x3a3c3d);
}

-(void) setHelp {	
	NSString *message = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"helpEmailMessage"];
		
	UIAlertView *helpAlert = [[UIAlertView alloc] initWithTitle:@"Notice" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email", nil];
	[helpAlert show];
	[helpAlert release];
}


-(void)loadDataById {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	success = NO;
	
	//NSString *userId = [[SUAPIInterface sharedSUAPIInterface] userId];
	NSDictionary *response = [[SUAPIInterface sharedSUAPIInterface] getAllMessages];
	if (response != nil) {
		success = YES;
		
		// populate our objects
		self.messages = [response objectForKey:@"Messages"];
		
		[self.tableView setNeedsLayout];
		[self.tableView reloadData];
		
	} else {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Woops" message: [SUAPIInterface sharedSUAPIInterface].errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];	
	}	
	
	[self synchingDone:NULL];
	[pool release];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!stopRefresh) {
	
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		
		// show loading
		HUD = [[[MBProgressHUD alloc] initWithWindow:window] autorelease];
		
		// Add HUD to screen
		[window addSubview:HUD];
		
		// Register for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		HUD.labelText = @"Loading";	
		
		// Show the HUD while the provided method executes in a new thread
		[HUD showWhileExecuting:@selector(loadDataById) onTarget:self withObject:nil animated:YES];
		
	} else {
		stopRefresh = NO;
	}

	
}

# pragma mark -
# pragma mark UIAlertView delegate methods
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1) {
		// ok
		NSString *emailTo = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"helpEmailRecipient"];
		NSMutableArray *emails = [NSArray arrayWithObjects:emailTo, nil];
		
		NSString *emailSubject = [[[NSString alloc] initWithString:@"Help!"] autorelease];
		NSString *emailBody = [[[NSString alloc] initWithString:@"Hello there,"] autorelease];
		
		MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
		mailController.mailComposeDelegate = self;
		[mailController setToRecipients:emails];
		[mailController setSubject:emailSubject];
		[mailController setMessageBody:emailBody isHTML:NO]; 
		[self presentModalViewController:mailController animated:YES];		
				
	} else {
		// do nothing
		NSLog(@"cancel");
		
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	// Notifies users about errors associated with the interface
	switch (result)	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default: {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
		break;
	}
	stopRefresh = YES;
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark HUD delegate methods
- (void)hudWasHidden {
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messages count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSDictionary *message = [self.messages objectAtIndex:[indexPath row]];
	
	if ([[message objectForKey:@"Type"] isEqual:@"banter"]) {
		
		NSDictionary *banterDetails = message;
		
		NSString *CellIdentifier = [NSString stringWithFormat:@"BanterCell%@", [[banterDetails objectForKey:@"BanterMessageContent"] objectForKey:@"BanterId"]];
		SULeagueDetailBanterTableViewCell *cell = (SULeagueDetailBanterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[SULeagueDetailBanterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[cell redrawLabel:[message objectForKey:@"MessageContent"]];
		
		NSDictionary *banterUser = [[banterDetails objectForKey:@"BanterMessageContent"] objectForKey: @"User"];
		cell.teamNameLabel.text = [NSString stringWithFormat:@"%@", [banterUser objectForKey:@"TeamName"]];
		cell.dateLabel.text = [NSString stringWithFormat:@"%@", [banterDetails objectForKey:@"DateString"]];
		
		
		NSURL *url = [NSURL URLWithString:[banterUser objectForKey:@"AvatarUrl"]];
		if (url != nil) {
			UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 40, 40)] autorelease];
			[iv loadFromURL:url];
			[cell addSubview:iv];
		}
		return cell;
		
	} else if ([[message objectForKey:@"Type"] isEqual:@"score"]) {
		
		//NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
		
		NSDictionary *match = [message objectForKey:@"ScoreMessageContent"];
		
		NSString *CellIdentifier = [[[NSString alloc] initWithFormat:@"MatchCell%@", [match objectForKey:@"Id"]] autorelease];	
				
		SUPredictionsTableViewCell *cell = (SUPredictionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {		
			
			cell = [[[SUPredictionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell setData:match];
		
		return cell;
		
	} else {
		
		static NSString *CellIdentifier = @"Cell";
		
		SUPPMessageTableViewCell *cell = (SUPPMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[SUPPMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.messageLabel.text = [message objectForKey:@"MessageContent"];
		[cell setNeedsLayout];		
		return cell;
		
	}
}

// custom view for footer. will be adjusted to default or specified footer height
// Notice: this will work only for one section within the table view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	if (section == 0 && [self tableView:tableView numberOfRowsInSection:0] == 0) {
		
		// Find out the space needed
		CGSize constraintSize;
		constraintSize.width = 290.0f;
		constraintSize.height = MAXFLOAT;
		NSString *theText = @"First time playing PredictorPro? To get started, click through and have a look at the options on offer below.";
		CGSize theSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		UIView *footerView;
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
		
		
		//return the view for the footer
		return footerView;
	} else {
		return nil;
	}
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *message = [self.messages objectAtIndex:[indexPath row]];
	
	if ([[message objectForKey:@"Type"] isEqual:@"banter"]) {
		// we are banter objects
		NSString *banterMessage = [message objectForKey:@"MessageContent"];
		// get the height
		return [SULeagueDetailBanterTableViewCell getHeightOfCell:banterMessage];
		

	} else if([[message objectForKey:@"Type"] isEqual:@"ppmessage"]){
		return 85;
	} else {
		return 70;
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
#pragma mark Pull to refresh overrides

- (void)synchingDone:(NSNotification *)notification {
	[super dataSourceDidFinishLoadingNewData];
	refreshHeaderView.lastUpdatedDate = [NSDate date];
}

- (void)reloadTableViewDataSource {	
	[self performSelectorInBackground:@selector(loadDataById) withObject:nil ];
	
}


#pragma mark -
#pragma mark Table view delegates

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//	PredictorProAppDelegate *appDelegate = (PredictorProAppDelegate *)[[UIApplication sharedApplication] delegate];
//
//	NSDictionary *message = [self.messages objectAtIndex:[indexPath row]];
//	
//	if ([[message objectForKey:@"Type"] isEqual:@"banter"]) {
//		// we are banter objects
//		[appDelegate changeSection:(NSInteger)3];
//		
//	} else if([[message objectForKey:@"Type"] isEqual:@"score"]){
//		[appDelegate changeSection:(NSInteger)2];
//	}
//	
//	
//
//	
//	
//}


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

