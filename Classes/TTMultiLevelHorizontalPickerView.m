//
//  TTMultiLevelHorizontalPickerView.m
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TTMultiLevelHorizontalPickerView.h"


#pragma mark - Internal Method Interface
@interface TTMultiLevelHorizontalPickerView () {
	UIScrollView *_scrollView;

	NSInteger elementPadding;
    
    NSInteger elementWidth;
    
	// state keepers
	BOOL dataHasBeenLoaded;
	BOOL scrollSizeHasBeenSet;
	BOOL scrollingBasedOnUserInteraction;

	// keep track of which elements are visible for tiling
	int firstVisibleElement;
	int lastVisibleElement;
}

- (void)collectData;

- (void)getNumberOfElementsFromDataSource;
- (void)setTotalWidthOfScrollContent;
- (void)updateScrollContentInset;

- (void)addScrollView;
- (void)drawPositionIndicator;
- (PickerLabel *)labelForForElementAtIndex:(NSInteger)index withTitle:(NSString *)title;
- (CGRect)frameForElementAtIndex:(NSInteger)index;

- (CGPoint)currentCenter;
- (void)scrollToElementNearestToCenter;

- (NSInteger)nearestMajorElementToCenter;
- (NSInteger)nearestMajorElementToPoint:(CGPoint)point;

- (NSInteger)nearestMinorElementToCenterWithMajorIndex:(NSInteger)majorIndex;
- (NSInteger)nearestMinorElementToPoint:(CGPoint)point withMajorIndex:(NSInteger)majorIndex;

- (NSInteger)elementContainingPoint:(CGPoint)point;

- (NSInteger)offsetForElementAtIndex:(NSInteger)index;
- (NSInteger)centerOfElementAtIndex:(NSInteger)index;

- (void)scrollViewTapped:(UITapGestureRecognizer *)recognizer;

- (NSInteger)tagForElementAtIndex:(NSInteger)index;
- (NSInteger)indexForElement:(UIView *)element;
@end


#pragma mark - Implementation
@implementation TTMultiLevelHorizontalPickerView : UIView

#pragma mark - Init/Dealloc
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {

		[self addScrollView];

		self.textColor   = [UIColor blackColor];
		self.elementFont = [UIFont systemFontOfSize:12.0f];

		_currentMajorSelectedIndex = -1; // nothing is selected yet
        
        elementWidth = 100;
        
		_numberOfElements     = 0;
		elementPadding       = 0;
		dataHasBeenLoaded    = NO;
		scrollSizeHasBeenSet = NO;
		scrollingBasedOnUserInteraction = NO;

		// default to the center
		_selectionPoint = CGPointMake(frame.size.width / 2, 0.0f);
		_indicatorPosition = PickerIndicatorBottom;

		firstVisibleElement = -1;
		lastVisibleElement  = -1;

		self.autoresizesSubviews = YES;
	}
	return self;
}

#pragma mark - LayoutSubViews
- (void)layoutSubviews {
	[super layoutSubviews];
	BOOL adjustWhenFinished = NO;

	if (!dataHasBeenLoaded) {
		[self collectData];
	}
	if (!scrollSizeHasBeenSet) {
		adjustWhenFinished = YES;
		[self updateScrollContentInset];
		[self setTotalWidthOfScrollContent];
	}

	SEL titleForElementSelector = @selector(multiLevelHorizontalPickerView:titleForElementAtIndex:);
    //SEL childrenForElementSelector = @selector(multiLevelHorizontalPickerView:childrenForElementAtIndex:);
	SEL setSelectedSelector     = @selector(setSelectedElement:);

	CGRect visibleBounds   = [self bounds];
	CGRect scaledViewFrame = CGRectZero;

	// remove any subviews that are no longer visible
	for (UIView *view in [_scrollView subviews]) {
		scaledViewFrame = [_scrollView convertRect:[view frame] toView:self];

		// if the view doesn't intersect, it's not visible, so we can recycle it
		if (!CGRectIntersectsRect(scaledViewFrame, visibleBounds)) {
			[view removeFromSuperview];
		} else { // if it is still visible, update it's selected state
			if ([view respondsToSelector:setSelectedSelector]) {
				// view's tag is it's index
				BOOL isSelected = (_currentMajorSelectedIndex == [self indexForElement:view]);
				if (isSelected) {
					// if this view is set to be selected, make sure it is over the selection point
					int currentIndex = [self nearestMajorElementToCenter];
					isSelected = (currentIndex == _currentMajorSelectedIndex);
				}
				// casting to PickerLabel so we can call this without all the NSInvocation jazz
				[(PickerLabel *)view setSelectedElement:isSelected];
			}
		}
	}
    
	// find needed elements by looking at left and right edges of frame
	CGPoint offset = _scrollView.contentOffset;
	int firstNeededElement = [self nearestMajorElementToPoint:CGPointMake(offset.x, 0.0f)];
	int lastNeededElement  = [self nearestMajorElementToPoint:CGPointMake(offset.x + visibleBounds.size.width, 0.0f)];

	// add any views that have become visible
	UIView *view = nil;
	for (int i = firstNeededElement; i <= lastNeededElement; i++) {
		view = nil; // paranoia
		view = [_scrollView viewWithTag:[self tagForElementAtIndex:i]];
		if (!view) {
			if (i < _numberOfElements) { // make sure we are not requesting data out of range
				if (self.delegate && [self.delegate respondsToSelector:titleForElementSelector]) {
					NSString *title = [self.delegate multiLevelHorizontalPickerView:self titleForElementAtIndex:i];
					view = [self labelForForElementAtIndex:i withTitle:title];
                    // use the index as the tag so we can find it later
					view.tag = [self tagForElementAtIndex:i];
					[_scrollView addSubview:view];
				} 
			}
		}
    
    
        // draw sub elements
        NSArray * subElements = [self.delegate multiLevelHorizontalPickerView:self childrenForElementAtIndex:i];   
        NSInteger numberOfSubElements = [subElements count];
    
        int interval; 
        if (numberOfSubElements < 2) {
            interval = elementWidth / 2;
            numberOfSubElements = 1;

        }        
        else {
            interval = elementWidth / (numberOfSubElements + 1);
        }
    
        int location = interval;
    for (int j = 0; j < numberOfSubElements; j++)
    {
        UIView *subLineView = [[UIView alloc] initWithFrame:CGRectMake(i * elementWidth + location, 0, 1, 30)];
        subLineView.backgroundColor = [UIColor greenColor];
        [_scrollView addSubview:subLineView];
        location += interval;
    }
    
    
        // draw element divider lines
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * elementWidth, 0, 1, visibleBounds.size.height)];
        lineView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:lineView];
	} 
    
	// save off what's visible now
	firstVisibleElement = firstNeededElement;
	lastVisibleElement  = lastNeededElement;

	// determine if scroll view needs to shift in response to resizing?
	if (_currentMajorSelectedIndex > -1 && [self centerOfElementAtIndex:_currentMajorSelectedIndex] != [self currentCenter].x) {
		if (adjustWhenFinished) {
			[self scrollToMinorElement:0 withMajorElement:_currentMajorSelectedIndex animated:NO];
		} else if (_numberOfElements <= _currentMajorSelectedIndex) {
			// if currentSelectedIndex no longer exists, select what is currently centered
			_currentMajorSelectedIndex = [self nearestMajorElementToCenter];
			[self scrollToMinorElement:0 withMajorElement:_currentMajorSelectedIndex animated:NO];
		}
	}
}

#pragma mark - View Creation Methods (Internal Methods)
- (void)addScrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.delegate = self;
		_scrollView.scrollEnabled = YES;
		_scrollView.scrollsToTop  = NO;
		_scrollView.showsVerticalScrollIndicator   = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.bouncesZoom  = NO;
		_scrollView.alwaysBounceHorizontal = YES;
		_scrollView.alwaysBounceVertical   = NO;
		_scrollView.minimumZoomScale = 1.0; // setting min/max the same disables zooming
		_scrollView.maximumZoomScale = 1.0;
		_scrollView.contentInset = UIEdgeInsetsZero;
		_scrollView.decelerationRate = 0.1; //UIScrollViewDecelerationRateNormal;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_scrollView.autoresizesSubviews = YES;
        
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
		[_scrollView addGestureRecognizer:tapRecognizer];
        
		[self addSubview:_scrollView];
	}
}

- (void)drawPositionIndicator {
	CGRect indicatorFrame = _selectionIndicatorView.frame;
	CGFloat x = self.selectionPoint.x - (indicatorFrame.size.width / 2);
	CGFloat y;
    
	switch (self.indicatorPosition) {
		case PickerIndicatorTop: {
			y = 0.0f;
			break;
		}
		case PickerIndicatorBottom: {
			y = self.frame.size.height - indicatorFrame.size.height;
			break;
		}
		default:
			break;
	}
    
	// properly place indicator image in view relative to selection point
	CGRect tmpFrame = CGRectMake(x, y, indicatorFrame.size.width, indicatorFrame.size.height);
	_selectionIndicatorView.frame = tmpFrame;
	[self addSubview:_selectionIndicatorView];
}

// create a UILabel for this element.
- (PickerLabel *)labelForForElementAtIndex:(NSInteger)index withTitle:(NSString *)title {
	CGRect labelFrame     = [self frameForElementAtIndex:index];
	PickerLabel *elementLabel = [[PickerLabel alloc] initWithFrame:labelFrame];
    
	elementLabel.textAlignment   = UITextAlignmentCenter;
	elementLabel.backgroundColor = self.backgroundColor;
	elementLabel.text            = title;
	elementLabel.font            = self.elementFont;
    
	elementLabel.normalStateColor   = self.textColor;
	elementLabel.selectedStateColor = self.selectedTextColor;
    
	// show selected status if this element is the selected one and is currently over selectionPoint
	int currentIndex = [self nearestMajorElementToCenter];
	elementLabel.selectedElement = (_currentMajorSelectedIndex == index) && (currentIndex == _currentMajorSelectedIndex);
    
	return elementLabel;
}

- (void)scrollToMinorElement:(NSInteger)index withMajorElement:(NSInteger) majorIndex animated:(BOOL)animate {
	_currentMajorSelectedIndex = majorIndex;
	int x = [self centerOfElementAtIndex:majorIndex] - _selectionPoint.x;
	[_scrollView setContentOffset:CGPointMake(x, 0) animated:animate];
    
	// notify delegate of the selected index
	SEL delegateCall = @selector(multiLevelHorizontalPickerView:didSelectElementAtIndex:);
	if (self.delegate && [self.delegate respondsToSelector:delegateCall]) {
		[self.delegate multiLevelHorizontalPickerView:self didSelectElementAtIndex:majorIndex];
	}
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3)
	[self setNeedsLayout];
#endif
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollingBasedOnUserInteraction) {
		// NOTE: sizing and/or changing orientation of control might cause scrolling
		//		 not initiated by user. do not update current selection in these
		//		 cases so that the view state is properly preserved.

		// set the current item under the center to "highlighted" or current
		_currentMajorSelectedIndex = [self nearestMajorElementToCenter];
	}

#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3)
	[self setNeedsLayout];
#endif
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	scrollingBasedOnUserInteraction = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	// only do this if we aren't decelerating
	if (!decelerate) {
		[self scrollToElementNearestToCenter];
	}
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView { }

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollToElementNearestToCenter];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	scrollingBasedOnUserInteraction = NO;
}



#pragma mark - View Calculation and Manipulation Methods (Internal Methods)
// what is the total width of the content area?
- (void)setTotalWidthOfScrollContent {
	NSInteger totalWidth = 0;

	totalWidth = (elementWidth + elementPadding) * _numberOfElements;
    
	// TODO: is this necessary?
	totalWidth -= elementPadding; // we add "one too many" in for loop

	if (_scrollView) {
		// create our scroll view as wide as all the elements to be included
		_scrollView.contentSize = CGSizeMake(totalWidth, self.bounds.size.height);
		scrollSizeHasBeenSet = YES;
	}
}

// reset the content inset of the scroll view based on centering first and last elements.
- (void)updateScrollContentInset {
	// update content inset if we have element widths
	if (_numberOfElements != 0) {
		CGFloat scrollerWidth = _scrollView.frame.size.width;

		CGFloat halfFirstWidth = 0.0f;
		CGFloat halfLastWidth  = 0.0f;
		if ( _numberOfElements > 0 ) {
			halfFirstWidth = elementWidth / 2.0; 
			halfLastWidth  = elementWidth      / 2.0;
		}

		// calculating the inset so that the bouncing on the ends happens more smooothly
		// - first inset is the distance from the left edge to the left edge of the
		//     first element when that element is centered under the selection point.
		//     - represented below as the # area
		// - last inset is the distance from the right edge to the right edge of
		//     the last element when that element is centered under the selection point.
		//     - represented below as the * area
		//
		//        Selection
		//  +---------|---------------+
		//  |####| Element |**********| << UIScrollView
		//  +-------------------------+
		CGFloat firstInset = _selectionPoint.x - halfFirstWidth;
		CGFloat lastInset  = (scrollerWidth - _selectionPoint.x) - halfLastWidth;

		_scrollView.contentInset = UIEdgeInsetsMake(0, firstInset, 0, lastInset);
	}
}

// what is the left-most edge of the element at the given index?
- (NSInteger)offsetForElementAtIndex:(NSInteger)index {
	NSInteger offset = 0;
	if (index >= _numberOfElements) {
		return 0;
	}

	for (int i = 0; i < index && i < _numberOfElements; i++) {
		offset += elementWidth;
		offset += elementPadding;
	}
	return offset;
}

// return the tag for an element at a given index
- (NSInteger)tagForElementAtIndex:(NSInteger)index {
	return (index + 1) * 10;
}

// return the index given an element's tag
- (NSInteger)indexForElement:(UIView *)element {
	return (element.tag / 10) - 1;
}

// what is the center of the element at the given index?
- (NSInteger)centerOfElementAtIndex:(NSInteger)index {
	if (index >= _numberOfElements) {
		return 0;
	}

	NSInteger elementOffset = [self offsetForElementAtIndex:index];

	return elementOffset + elementWidth / 2;
}

// what is the frame for the element at the given index?
- (CGRect)frameForElementAtIndex:(NSInteger)index {
	CGFloat width = 0.0f;
	if (_numberOfElements > index) {
		width = elementWidth;
	}
	return CGRectMake([self offsetForElementAtIndex:index], 0.0f, width, self.frame.size.height);
}

// what is the "center", relative to the content offset and adjusted to selection point?
- (CGPoint)currentCenter {
	CGFloat x = _scrollView.contentOffset.x + _selectionPoint.x;
	return CGPointMake(x, 0.0f);
}

// what is the element nearest to the center of the view?
- (NSInteger)nearestMajorElementToCenter {
	return [self nearestMajorElementToPoint:[self currentCenter]];
}

// what is the element nearest to the given point?
- (NSInteger)nearestMajorElementToPoint:(CGPoint)point {
	for (int i = 0; i < _numberOfElements; i++) {
		CGRect frame = [self frameForElementAtIndex:i];
		if (CGRectContainsPoint(frame, point)) {
			return i;
		} else if (point.x < frame.origin.x) {
			// if the center is before this element, go back to last one,
			//     unless we're at the beginning
			if (i > 0) {
				return i - 1;
			} else {
				return 0;
			}
			break;
		} else if (point.x > frame.origin.y) {
			// if the center is past the last element, scroll to it
			if (i == _numberOfElements - 1) {
				return i;
			}
		}
	}
	return 0;
}

// similar to nearestElementToPoint: however, this method does not look past beginning/end
- (NSInteger)elementContainingPoint:(CGPoint)point {
	for (int i = 0; i < _numberOfElements; i++) {
		CGRect frame = [self frameForElementAtIndex:i];
		if (CGRectContainsPoint(frame, point)) {
			return i;
		}
	}
	return -1;
}


// what is the element nearest to the center of the view?
- (NSInteger)nearestMinorElementToCenterWithMajorIndex:(NSInteger)majorIndex {
	return [self nearestMinorElementToPoint:[self currentCenter] withMajorIndex:majorIndex];
}

// what is the element nearest to the given point?
- (NSInteger)nearestMinorElementToPoint:(CGPoint)point withMajorIndex:(NSInteger)majorIndex  {
	
    
    NSArray * subElements = [self.delegate multiLevelHorizontalPickerView:self childrenForElementAtIndex:majorIndex];
    NSInteger numberOfSubElements = [subElements count];
    NSLog(@"number of sub elements ==> %d", numberOfSubElements);
    
    if (numberOfSubElements < 2) return numberOfSubElements;
    
    CGRect frame = [self frameForElementAtIndex:majorIndex];
    NSLog(@"Frame X Origin - %f", frame.origin.x);
    NSLog(@"Point X - %f", point.x);
    
    double pointOffset = point.x - frame.origin.x;
    
    NSLog(@"Point Offset - %f", pointOffset);
    
    double interval = elementWidth / (numberOfSubElements + 1);
    
    for (int i = 0; i < numberOfSubElements; i++) {
        
        double pointForSubElement = (i+1)*interval;
        
        double distance = pointOffset = pointForSubElement;
        
        NSLog(@"========== SubPoint for element %i - %f with distance of %f", i, pointForSubElement, distance);
        
	}
	return 0;
}



// move scroll view to position nearest element under the center
- (void)scrollToElementNearestToCenter {
    int majorIndex = [self nearestMajorElementToCenter];
    int minorIndex = [self nearestMinorElementToCenterWithMajorIndex:majorIndex];
    
    NSLog(@"Major Index ==> %d", majorIndex);
    NSLog(@"Minor Index ==> %d", minorIndex);
    
    //[self scrollToMajorElement:majorIndex animated:YES];
    [self scrollToMinorElement:minorIndex withMajorElement:majorIndex  animated:YES];
}


#pragma mark - Tap Gesture Recognizer Handler Method
// use the gesture recognizer to slide to element under tap
- (void)scrollViewTapped:(UITapGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		CGPoint tapLocation    = [recognizer locationInView:_scrollView];
		NSInteger elementIndex = [self elementContainingPoint:tapLocation];
		if (elementIndex != -1) { // point not in element
			[self scrollToMinorElement:0 withMajorElement:elementIndex animated:YES];
		}
	}
}

#pragma mark - Data Fetching Methods
- (void)reloadData {
	// remove all scrollview subviews and "recycle" them
	for (UIView *view in [_scrollView subviews]) {
		[view removeFromSuperview];
	}
    
	firstVisibleElement = NSIntegerMax;
	lastVisibleElement  = NSIntegerMin;
    
	[self collectData];
}

- (void)collectData {
	scrollSizeHasBeenSet = NO;
	dataHasBeenLoaded    = NO;
    
	[self getNumberOfElementsFromDataSource];
	[self setTotalWidthOfScrollContent];
	[self updateScrollContentInset];
    
	dataHasBeenLoaded = YES;
	[self setNeedsLayout];
}

#pragma mark - DataSource Calling Method (Internal Method)
- (void)getNumberOfElementsFromDataSource {
	SEL dataSourceCall = @selector(numberOfElementsInHorizontalPickerView:);
	if (self.dataSource && [self.dataSource respondsToSelector:dataSourceCall]) {
		_numberOfElements = [self.dataSource numberOfElementsInHorizontalPickerView:self];
	} else {
		_numberOfElements = 0;
	}
}

#pragma mark - Getters and Setters
- (void)setDelegate:(id)newDelegate {
	if (_delegate != newDelegate) {
		_delegate = newDelegate;
		[self collectData];
	}
}

- (void)setDataSource:(id)newDataSource {
	if (_dataSource != newDataSource) {
		_dataSource = newDataSource;
		[self collectData];
	}
}

- (void)setSelectionPoint:(CGPoint)point {
	if (!CGPointEqualToPoint(point, _selectionPoint)) {
		_selectionPoint = point;
		[self updateScrollContentInset];
	}
}

// allow the setting of this views background color to change the scroll view
- (void)setBackgroundColor:(UIColor *)newColor {
	[super setBackgroundColor:newColor];
	_scrollView.backgroundColor = newColor;
	// TODO: set all subviews as well?
}

- (void)setIndicatorPosition:(PickerIndicatorPosition)position {
	if (_indicatorPosition != position) {
		_indicatorPosition = position;
		[self drawPositionIndicator];
	}
}

- (void)setSelectionIndicatorView:(UIView *)indicatorView {
	if (_selectionIndicatorView != indicatorView) {
		if (_selectionIndicatorView) {
			[_selectionIndicatorView removeFromSuperview];
		}
		_selectionIndicatorView = indicatorView;
        
		[self drawPositionIndicator];
	}
}


- (void)setFrame:(CGRect)newFrame {
	if (!CGRectEqualToRect(self.frame, newFrame)) {
		// causes recalulation of offsets, etc based on new size
		scrollSizeHasBeenSet = NO;
	}
	[super setFrame:newFrame];
}


@end



// ------------------------------------------------------------------------
#pragma mark - Picker Label Implementation
@implementation PickerLabel : UILabel

- (void)setSelectedElement:(BOOL)selected {
	if (_selectedElement != selected) {
		if (selected) {
			self.textColor = self.selectedStateColor;
		} else {
			self.textColor = self.normalStateColor;
		}
		_selectedElement = selected;
		[self setNeedsLayout];
	}
}

- (void)setNormalStateColor:(UIColor *)color {
	if (_normalStateColor != color) {
		_normalStateColor = color;
		self.textColor = _normalStateColor;
		[self setNeedsLayout];
	}
}

@end