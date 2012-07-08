//
//  TTMultiLevelHorizontalPickerViewProtocol.h
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

@class TTMultiLevelHorizontalPickerView;

// ------------------------------------------------------------------
// TTMultiLevelHorizontalPickerView DataSource Protocol
@protocol TTMultiLevelHorizontalPickerViewDataSource <NSObject>
@required
// data source is responsible for reporting how many elements there are
- (NSInteger)numberOfElementsInHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker;
@end


// ------------------------------------------------------------------
// TTMultiLevelHorizontalPickerView Delegate Protocol
@protocol TTMultiLevelHorizontalPickerViewDelegate <NSObject>

@optional
// delegate callback to notify delegate selected element has changed
- (void)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index;

// one of these two methods must be defined
- (NSString *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index;
- (NSArray *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker childrenForElementAtIndex:(NSInteger)index;
- (UIView *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index;
// any view returned from this must confirm to the TTMultiLevelHorizontalPickerElementState protocol

@end

// ------------------------------------------------------------------
// TTMultiLevelHorizontalPickerElementState Protocol
@protocol TTMultiLevelHorizontalPickerElementState <NSObject>
@required
// element views should know how display themselves based on selected status
- (void)setSelectedElement:(BOOL)selected;
@end