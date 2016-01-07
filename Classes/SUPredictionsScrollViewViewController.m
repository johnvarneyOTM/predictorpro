//
//  SUPredictionsScrollViewViewController.m
//  SUPredictionsScrollView
//
//  Created by Sumac on 23/07/2010.
//  Copyright SUMAC 2010. All rights reserved.
//

#import "SUPredictionsScrollViewViewController.h"


@interface SUPredictionsScrollViewViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation SUPredictionsScrollViewViewController
@synthesize scrollView, pageControl, viewControllers, matches, saveButton;


- (void)dealloc {
	[self.saveButton release];
	self.saveButton = nil;
	
    [super dealloc];
}


- (id) initWithMatches:(NSMutableArray *)ms selectedIndex:(int)index totalBankers:(NSInteger)tb remainingBankers:(NSInteger)rb  {
    if ((self = [super initWithNibName:@"SUPredictionsScrollViewViewController" bundle:nil])) {
        // Custom initialization
		self.matches = ms;
		totalBankers = tb;
		remainingBankers = rb;
		[self loadScrollViewWithPage:index];	
				
		self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" 
																		style:UIBarButtonItemStyleBordered 
																	   target:self 
																	   action:@selector(sendSaveMatch)] autorelease];
		
		self.navigationItem.rightBarButtonItem = saveButton;   
			
    }
    return self;
}

- (void)toggleBankers:(NSInteger)change {
	
	NSLog(@"change: %i",change);
	
}

- (void)sendToggleBanker:(id)pointer {
	// throw it up & get the controller to change all views
	
	//SUPredictionsDetailViewController *con = ((UIButton *)pointer).parentViewController;
	
	// TODO: finish this
	
	NSInteger change = -1;//match.hasBanker ? 1 : -1;
	
	if (remainingBankers == 0 && change < 0) {
		return;
	}	
	if (remainingBankers == totalBankers && change > 0) {
		return;
	}
	
	//[self.bankerButton setSelected:(change < 0)];
	// TODO: send message
	// BOOM
}

-(void)sendSaveMatch {
	
    SUPredictionsDetailViewController *controller = [viewControllers objectAtIndex:pageControl.currentPage];
	
	[controller beginSave];
	
}

- (void)viewDidLoad {
	// Custom initialization
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.matches count]; i++) {
		[controllers addObject:[NSNull null]];
	}
	self.viewControllers = controllers;
	[controllers release];
	
	// a page is the width of the scroll view
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.matches count], scrollView.frame.size.height);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollsToTop = NO;
	scrollView.delegate = self;
	
	pageControl.numberOfPages = [self.matches count];
	pageControl.currentPage = 0;
	
	// pages are created on demand
	// load the visible page
	// load the page on either side to avoid flashes when the user starts scrolling
	[self loadScrollViewWithPage:1];	
	[self loadScrollViewWithPage:0];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= [self.matches count]) return;
	
    // replace the placeholder if necessary
    SUPredictionsDetailViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[SUPredictionsDetailViewController alloc] initWithPageNumber:page Match:[matches objectAtIndex:page] maxBankers:totalBankers remainingBankers:remainingBankers];
		[viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
