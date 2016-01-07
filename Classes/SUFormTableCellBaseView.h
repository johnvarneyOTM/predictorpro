//
//  SUFormTableCellBaseView.h
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SUFormTableCellBaseViewModeTextField,
	SUFormTableCellBaseViewModeButton
} SUFormTableCellBaseViewMode;

@interface SUFormTableCellBaseView : UITableViewCell {
	SUFormTableCellBaseViewMode *baseType;
	NSString* notificationName;
}

@property (assign) SUFormTableCellBaseViewMode *baseType;
@property (nonatomic, retain) NSString *notificationName;

@end
