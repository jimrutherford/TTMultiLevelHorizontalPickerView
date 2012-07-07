//
//  TestViewController.h
//  fStats
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMultiLevelHorizontalPickerViewProtocol.h"
#import "TTMultiLevelHorizontalPickerView.h"

@class V8HorizontalPickerView;

@interface TestViewController : UIViewController <TTMultiLevelHorizontalPickerViewDelegate, TTMultiLevelHorizontalPickerViewDataSource> { }

@property (nonatomic, retain) TTMultiLevelHorizontalPickerView *pickerView;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *reloadButton;
@property (nonatomic, retain) UILabel *infoLabel;

@end
