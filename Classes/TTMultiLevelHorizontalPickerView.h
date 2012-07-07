//
//  V8HorizontalPickerView.h
//
//  Created by Shawn Veader on 9/17/10.
//  Copyright 2010 V8 Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerViewProtocol.h"

// position of indicator view, if shown
typedef enum {
	V8HorizontalPickerIndicatorBottom = 0,
	V8HorizontalPickerIndicatorTop	
} V8HorizontalPickerIndicatorPosition;



@interface V8HorizontalPickerView : UIView <UIScrollViewDelegate> { }

// delegate and datasources to feed scroll view. this view only maintains a weak reference to these
@property (nonatomic, assign) id <V8HorizontalPickerViewDataSource> dataSource;
@property (nonatomic, assign) id <V8HorizontalPickerViewDelegate> delegate;

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

@property (nonatomic, assign) V8HorizontalPickerIndicatorPosition indicatorPosition;

- (void)reloadData;
- (void)scrollToElement:(NSInteger)index animated:(BOOL)animate;

@end


// sub-class of UILabel that knows how to change it's state
@interface V8HorizontalPickerLabel : UILabel <V8HorizontalPickerElementState> { }

@property (nonatomic, assign) BOOL selectedElement;
@property (nonatomic, retain) UIColor *selectedStateColor;
@property (nonatomic, retain) UIColor *normalStateColor;

@end