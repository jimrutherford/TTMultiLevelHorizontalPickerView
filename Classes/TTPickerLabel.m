//
//  TTPickerLabel.m
//  MultiLevelHorizontalPickerTestApp
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TTPickerLabel.h"

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