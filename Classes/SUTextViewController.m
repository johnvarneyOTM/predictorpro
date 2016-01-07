    //
//  SUTextViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUTextViewController.h"


@implementation SUTextViewController
@synthesize detailLabel;

- (void)dealloc {
    [super dealloc];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamedFallbackToPng:@"textDetailBackground"]];
		// Initialization code
		//
		self.detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30.0f, 30.0f, 260.0f, 260.0f)] autorelease];
		self.detailLabel.backgroundColor = UIColorFromRGB(0xf7f6e0);
		self.detailLabel.textAlignment = UITextAlignmentCenter;
		self.detailLabel.textColor = UIColorFromRGB(0x1e1e1e);
		self.detailLabel.shadowColor = [UIColor whiteColor];
		self.detailLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		self.detailLabel.font = [UIFont boldSystemFontOfSize:13];
		self.detailLabel.numberOfLines = 0;
		[self.view addSubview:self.detailLabel];
    }
    return self;
}

- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius {
	CGMutablePathRef retPath = CGPathCreateMutable();
	
	CGRect innerRect = CGRectInset(rect, radius, radius);
	
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
	
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
	
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
	
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);	
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
	
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
	
	CGPathCloseSubpath(retPath);
	
	return retPath;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGPathRef roundedRectPath = [self newPathForRoundedRect:CGRectMake(20, 20, 280, 270) radius:5];
	
	[[UIColor whiteColor] set];	
	
	CGContextAddPath(ctx, roundedRectPath);
	CGContextFillPath(ctx);
	
	CGPathRelease(roundedRectPath);
	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
