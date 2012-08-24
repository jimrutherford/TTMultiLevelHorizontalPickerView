//
//  TTPickerLabel.h
//  MultiLevelHorizontalPickerTestApp
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMultiLevelHorizontalPickerViewProtocol.h"

// sub-class of UILabel that knows how to change it's state
@interface PickerLabel : UILabel <TTMultiLevelHorizontalPickerElementState> { }

@property (nonatomic, assign) BOOL selectedElement;
@property (nonatomic, retain) UIColor *selectedStateColor;
@property (nonatomic, retain) UIColor *normalStateColor;

@end