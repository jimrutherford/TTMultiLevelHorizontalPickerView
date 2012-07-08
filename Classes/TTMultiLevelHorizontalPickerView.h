//
//  TTMultiLevelHorizontalPickerView.h
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMultiLevelHorizontalPickerViewProtocol.h"

// position of indicator view, if shown
typedef enum {
    PickerIndicatorBottom = 0,
	PickerIndicatorTop	
} PickerIndicatorPosition;



@interface TTMultiLevelHorizontalPickerView : UIView <UIScrollViewDelegate> { }

// delegate and datasources to feed scroll view. this view only maintains a weak reference to these
@property (nonatomic, assign) id <TTMultiLevelHorizontalPickerViewDataSource> dataSource;
@property (nonatomic, assign) id <TTMultiLevelHorizontalPickerViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger numberOfElements;
@property (nonatomic, readonly) NSInteger currentSelectedIndex;

// what font to use for the element labels?
@property (nonatomic, retain) UIFont *elementFont;

// color of labels used in picker
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *selectedTextColor; // color of current selected element

// the point, defaults to center of view, where the selected element sits
@property (nonatomic, assign) CGPoint selectionPoint;
@property (nonatomic, retain) UIView *selectionIndicatorView;

@property (nonatomic, assign) PickerIndicatorPosition indicatorPosition;

- (void)reloadData;
- (void)scrollToElement:(NSInteger)index animated:(BOOL)animate;

@end


// sub-class of UILabel that knows how to change it's state
@interface PickerLabel : UILabel <TTMultiLevelHorizontalPickerElementState> { }

@property (nonatomic, assign) BOOL selectedElement;
@property (nonatomic, retain) UIColor *selectedStateColor;
@property (nonatomic, retain) UIColor *normalStateColor;

@end