//
//  SUPredictionPickerViewController.m
//  PredictorPro
//
//  Created by Oliver Relph on 05/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUPredictionPickerViewController.h"


@implementation SUPredictionPickerViewController

@synthesize teamOnePickerView, teamTwoPickerView, arrayScores;
@synthesize teamOnePrediction, teamTwoPrediction;
@synthesize notificationName;


- (void)dealloc {
    self.arrayScores = nil;
    self.teamOnePickerView  = nil;
    self.teamTwoPickerView  = nil;
    self.notificationName  = nil;
    

	
    [super dealloc];
}

#define DELTA 85.0


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	

    
	CGRect frame = CGRectMake(39.0f, 185.0f + DELTA, 95.0f, 162.0f);
	self.teamOnePickerView = [[UIPickerView alloc] init];
	self.teamOnePickerView.delegate = self;
	self.teamOnePickerView.dataSource = self;
	self.teamOnePickerView.frame = frame;
    self.teamOnePickerView.showsSelectionIndicator = YES;

						  
	[self.view addSubview:teamOnePickerView];
	
	frame = CGRectMake(teamOnePickerView.frame.origin.x - 5, teamOnePickerView.frame.origin.y - 2, 104.0f, 164.0f);
	UIImageView *teamOnePickerOverlay = [[[UIImageView alloc] initWithFrame:frame] autorelease];	
	teamOnePickerOverlay.image = [UIImage imageNamedFallbackToPng:@"pickerOverlay"];
	[self.view addSubview:teamOnePickerOverlay];
	
	frame = CGRectMake(188.0f, 185.0f+ DELTA, 95.0f, 162.0f);
	self.teamTwoPickerView = [[UIPickerView alloc] init];
	self.teamTwoPickerView.delegate = self;
	self.teamTwoPickerView.dataSource = self;
	self.teamTwoPickerView.frame = frame;
	[self.view addSubview:teamTwoPickerView];
	
	frame = CGRectMake(teamTwoPickerView.frame.origin.x - 5, teamTwoPickerView.frame.origin.y - 2, 104.0f, 164.0f);
	UIImageView *teamTwoPickerOverlay = [[[UIImageView alloc] initWithFrame:frame] autorelease];	
	teamTwoPickerOverlay.image = [UIImage imageNamedFallbackToPng:@"pickerOverlay"];
	[self.view addSubview:teamTwoPickerOverlay];
	
	arrayScores = [[NSMutableArray alloc] init];	
	
	unsigned int index;
	for (index = 0; index <= 999; index++) {
		[arrayScores addObject:[[NSString alloc] initWithFormat:@"%i", index]];
	}	
	
	
}

- (void)setTeamOne:(NSString *)teamOne teamTwo:(NSString *)teamTwo {	
		
	self.teamOnePrediction = [teamOne intValue];
	self.teamTwoPrediction = [teamTwo intValue];
	
    [self.teamOnePickerView reloadAllComponents];
    [self.teamOnePickerView selectRow:self.teamOnePrediction inComponent:0 animated:YES];
    [self.teamTwoPickerView reloadAllComponents];
    [self.teamTwoPickerView selectRow:self.teamTwoPrediction inComponent:0 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
    self.arrayScores = nil;
}



#pragma mark -
#pragma mark Picker View Methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pv {
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {	
	return [arrayScores count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [arrayScores objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	if (pickerView == teamOnePickerView) {
		teamOnePrediction = row;
	} else {
		teamTwoPrediction = row;
	}
		
	//[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil];
	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *retval = (id)view;
    // the pickerOverlay
	if (!retval) {
        CGFloat width = 70.0;
        CGFloat height = 40.0;
        
        retval = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)] autorelease];
	}
    
  

	retval.text = [arrayScores objectAtIndex:row];
	retval.font = [UIFont  boldSystemFontOfSize:22];
	retval.textAlignment = UITextAlignmentCenter;
	retval.backgroundColor = [UIColor whiteColor];
    
	
	return retval;
}

@end
