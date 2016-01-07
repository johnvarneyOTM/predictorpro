//
//  SUPredictionsScrollViewViewController.h
//  SUPredictionsScrollView
//
//  Created by Sumac on 23/07/2010.
//  Copyright SUMAC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPredictionsDetailViewController.h"

@interface SUPredictionsScrollViewViewController : UIViewController <UIScrollViewDelegate> {
	
	UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	
	NSMutableArray *matches;
	
	NSInteger totalBankers;
	NSInteger remainingBankers;
	
	UIBarButtonItem *saveButton;
}
@property (nonatomic, retain) UIBarButtonItem *saveButton;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (nonatomic, retain) NSMutableArray *matches;


- (id) initWithMatches:(NSMutableArray *)matches selectedIndex:(int)index totalBankers:(NSInteger)tb remainingBankers:(NSInteger)rb;
- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
- (void)toggleBankers:(NSInteger)change;
@end

