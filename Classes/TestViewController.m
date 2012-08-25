//
//  TestViewController.m
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TestViewController.h"
#import "TTItem.h"

@implementation TestViewController

#pragma mark - iVars

NSMutableArray * dataArray;
int indexCount;

#pragma mark - Init/Dealloc
- (id)init {
	self = [super init];
	if (self) {

		indexCount = 0;
        
        
        TTItem * javaItem = [TTItem alloc];
        javaItem.itemName = @"Java";
        javaItem.items = @[@"JavaOne", @"JavaTwo", @"JavaThree"];
        
        TTItem * htmlItem = [TTItem alloc];
        htmlItem.itemName = @"HTML";
        htmlItem.items = @[@"HTMLOne", @"HTMLTwo"];
        
        TTItem * objcItem = [TTItem alloc];
        objcItem.itemName = @"Objective-C";
        
        TTItem * javascriptItem = [TTItem alloc];
        javascriptItem.itemName = @"Javascript";
        
        TTItem * rubyItem = [TTItem alloc];
        rubyItem.itemName = @"Ruby";
        rubyItem.items = @[@"RubyOne", @"RubyTwo", @"RubyThree", @"RubyFour", @"RubyFive"];

        TTItem * pythonItem = [TTItem alloc];
        pythonItem.itemName = @"Python";
        
        TTItem * cItem = [TTItem alloc];
        cItem.itemName = @"C++";
        
        TTItem * shellItem = [TTItem alloc];
        shellItem.itemName = @"Shell";
        
        TTItem * phpItem = [TTItem alloc];
        phpItem.itemName = @"PHP";
        
        dataArray = [NSMutableArray arrayWithObjects: javaItem, htmlItem, objcItem, javascriptItem, rubyItem, pythonItem, cItem, shellItem, phpItem, nil];

        NSLog(@"Hello %d", [dataArray count]);
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View Management Methods
- (void)viewDidLoad {
	[super viewDidLoad];

	CGFloat margin = 40.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat pickerHeight = 100.0f;
	CGFloat x = margin;
	CGFloat y = 50.0f;
	CGFloat spacing = 25.0f;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:background];
   
	_pickerView = [[TTMultiLevelHorizontalPickerView alloc] initWithFrame:tmpFrame];
	_pickerView.backgroundColor   = [UIColor clearColor];
	_pickerView.selectedTextColor = [UIColor whiteColor];
	_pickerView.textColor   = [UIColor blackColor];
	_pickerView.delegate    = self;
	_pickerView.dataSource  = self;
	_pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	_pickerView.selectionPoint = CGPointMake(width/2, 0);

	// add carat or other view to indicate selected element
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
	_pickerView.selectionIndicatorView = indicator;
//	pickerView.indicatorPosition = PickerIndicatorTop; // specify indicator's location

	[self.view addSubview:_pickerView];

	self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	_nextButton.frame = tmpFrame;
	[_nextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[_nextButton	setTitle:@"Center Element 0" forState:UIControlStateNormal];
	_nextButton.titleLabel.textColor = [UIColor blackColor];
	[self.view addSubview:_nextButton];

	self.reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	_reloadButton.frame = tmpFrame;
	[_reloadButton addTarget:self action:@selector(reloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[_reloadButton setTitle:@"Reload Data" forState:UIControlStateNormal];
	[self.view addSubview:_reloadButton];

	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	_infoLabel = [[UILabel alloc] initWithFrame:tmpFrame];
	_infoLabel.backgroundColor = [UIColor blackColor];
	_infoLabel.textColor = [UIColor whiteColor];
	_infoLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:_infoLabel];
    
    
    UIImageView *mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask"]];
    CGRect maskFrame = CGRectMake(0,45,320,110);
    mask.frame = maskFrame;
    [self.view addSubview:mask];
    
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	self.pickerView = nil;
	self.nextButton = nil;
	self.infoLabel  = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_pickerView scrollToMinorElement:0 withMajorElement:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	CGFloat margin = 40.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat x = margin;
	CGFloat y = 0.0f;
	CGFloat height = 40.0f;
	CGFloat spacing = 25.0f;
	CGRect tmpFrame;
	if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		y = 150.0f;
		spacing = 25.0f;
		tmpFrame = CGRectMake(x, y, width, height);
	} else {
		y = 50.0f;
		spacing = 10.0f;
		tmpFrame = CGRectMake(x, y, width, height);
	}
	_pickerView.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = _nextButton.frame;
	tmpFrame.origin.y = y;
	_nextButton.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = _reloadButton.frame;
	tmpFrame.origin.y = y;
	_reloadButton.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = _infoLabel.frame;
	tmpFrame.origin.y = y;
	_infoLabel.frame = tmpFrame;

}

#pragma mark - Button Tap Handlers
- (void)nextButtonTapped:(id)sender {
	[_pickerView scrollToMinorElement:0 withMajorElement:indexCount animated:NO];
	indexCount += 1;
	if ([dataArray count] <= indexCount) {
		indexCount = 0;
	}
	[_nextButton	setTitle:[NSString stringWithFormat:@"Center Element %d", indexCount]
				forState:UIControlStateNormal];
}

- (void)reloadButtonTapped:(id)sender {
	// change our title array so we can see a change
	if ([dataArray count] > 1) {
		[dataArray removeLastObject];
	}

	[_pickerView reloadData];
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker {
    return [dataArray count];
}

#pragma mark - MultiLevelHorizontalPickerView Delegate Methods
- (NSString *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	TTItem * item = [dataArray objectAtIndex:index];
    return item.itemName;
}

#pragma mark - MultiLevelHorizontalPickerView Delegate Methods
- (NSString *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker titleForMinorElementAtIndex:(NSInteger)minorIndex withMajorIndex:(NSInteger)majorIndex {
	TTItem * item = [dataArray objectAtIndex:majorIndex];
    return [item.items objectAtIndex:minorIndex];
}


- (NSArray *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker childrenForElementAtIndex:(NSInteger)index {
	TTItem * item = [dataArray objectAtIndex:index];
    return item.items;
}

- (void)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
	self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
}

@end
