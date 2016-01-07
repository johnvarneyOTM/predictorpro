//
//  SUPredictionsDetailViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 05/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUPredictionsDetailViewController.h"

@implementation SUPredictionsDetailViewController
@synthesize detailView;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self.detailView];
	self.detailView = nil;	
	
    [super dealloc];	
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)match maxBankers:(NSInteger)mb remainingBankers:(NSInteger)rb {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.detailView = [[[SUPredictionsDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 480.0)] autorelease];
        [self.detailView setData:match maxBankers:mb remainingBankers:rb];
		[self.view addSubview:self.detailView];
		
		
		UIBarButtonItem * saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonSystemItemAction target:self.detailView action:@selector( beginSave )] autorelease];	
		self.navigationItem.rightBarButtonItem = saveButton;
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.detailView = nil;
}




@end
