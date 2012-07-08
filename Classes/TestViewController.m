//
//  TestViewController.m
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TestViewController.h"
#import "TTItem.h"

@implementation TestViewController

@synthesize pickerView;
@synthesize nextButton, reloadButton;
@synthesize infoLabel;

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
        javaItem.items = [NSArray arrayWithObjects:@"JavaOne", @"JavaTwo", @"JavaThree", nil];
        
        TTItem * htmlItem = [TTItem alloc];
        htmlItem.itemName = @"HTML";
        htmlItem.items = [NSArray arrayWithObjects:@"HTMLOne", @"HTMLTwo", nil];
        
        TTItem * objcItem = [TTItem alloc];
        objcItem.itemName = @"Objective-C";
        
        TTItem * javascriptItem = [TTItem alloc];
        javascriptItem.itemName = @"Javascript";
        
        TTItem * rubyItem = [TTItem alloc];
        rubyItem.itemName = @"Ruby";
        rubyItem.items = [NSArray arrayWithObjects:@"RubyOne", @"RubyTwo", @"RubyThree", @"RubyFour", @"RubyFive", nil];

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

	self.view.backgroundColor = [UIColor blackColor];
	CGFloat margin = 40.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat pickerHeight = 100.0f;
	CGFloat x = margin;
	CGFloat y = 150.0f;
	CGFloat spacing = 25.0f;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);

//	CGFloat width = 200.0f;
//	CGFloat x = (self.view.frame.size.width - width) / 2.0f;
//	CGRect tmpFrame = CGRectMake(x, 150.0f, width, 40.0f);

	pickerView = [[TTMultiLevelHorizontalPickerView alloc] initWithFrame:tmpFrame];
	pickerView.backgroundColor   = [UIColor darkGrayColor];
	pickerView.selectedTextColor = [UIColor whiteColor];
	pickerView.textColor   = [UIColor grayColor];
	pickerView.delegate    = self;
	pickerView.dataSource  = self;
	pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	pickerView.selectionPoint = CGPointMake(width/2, 0);

	// add carat or other view to indicate selected element
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
	pickerView.selectionIndicatorView = indicator;
//	pickerView.indicatorPosition = PickerIndicatorTop; // specify indicator's location

	[self.view addSubview:pickerView];

	self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	nextButton.frame = tmpFrame;
	[nextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[nextButton	setTitle:@"Center Element 0" forState:UIControlStateNormal];
	nextButton.titleLabel.textColor = [UIColor blackColor];
	[self.view addSubview:nextButton];

	self.reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	reloadButton.frame = tmpFrame;
	[reloadButton addTarget:self action:@selector(reloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[reloadButton setTitle:@"Reload Data" forState:UIControlStateNormal];
	[self.view addSubview:reloadButton];

	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	infoLabel = [[UILabel alloc] initWithFrame:tmpFrame];
	infoLabel.backgroundColor = [UIColor blackColor];
	infoLabel.textColor = [UIColor whiteColor];
	infoLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:infoLabel];
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
	[pickerView scrollToElement:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
//	(interfaceOrientation == UIInterfaceOrientationPortrait ||
//	 interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//	 interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//	CGFloat margin = 40.0f;
//	CGFloat width = (self.view.frame.size.width - (margin * 2.0f));
//	CGFloat height = 40.0f;
//	CGRect tmpFrame;
//	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//		tmpFrame = CGRectMake(margin, 50.0f, width + 100.0f, height);
//	} else {
//		tmpFrame = CGRectMake(margin, 150.0f, width, height);
//	}
//	pickerView.frame = tmpFrame;
//}

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
	pickerView.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = nextButton.frame;
	tmpFrame.origin.y = y;
	nextButton.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = reloadButton.frame;
	tmpFrame.origin.y = y;
	reloadButton.frame = tmpFrame;
	
	y = y + tmpFrame.size.height + spacing;
	tmpFrame = infoLabel.frame;
	tmpFrame.origin.y = y;
	infoLabel.frame = tmpFrame;

}

#pragma mark - Button Tap Handlers
- (void)nextButtonTapped:(id)sender {
	[pickerView scrollToElement:indexCount animated:NO];
	indexCount += 1;
	if ([dataArray count] <= indexCount) {
		indexCount = 0;
	}
	[nextButton	setTitle:[NSString stringWithFormat:@"Center Element %d", indexCount]
				forState:UIControlStateNormal];
}

- (void)reloadButtonTapped:(id)sender {
	// change our title array so we can see a change
	if ([dataArray count] > 1) {
		[dataArray removeLastObject];
	}

	[pickerView reloadData];
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

- (NSArray *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker childrenForElementAtIndex:(NSInteger)index {
	TTItem * item = [dataArray objectAtIndex:index];
    return item.items;
}

- (void)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
	self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
}

@end
