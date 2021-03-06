//
//  TestViewController.m
//
//  Created by Jim Rutherford on 7/7/12.
//  Copyright 2012 Braxio Interactive. All rights reserved.
//

#import "TestViewController.h"


@implementation TestViewController

NSMutableArray * dataArray;

#pragma mark - Init/Dealloc
- (id)init {
	self = [super init];
	if (self) {       
        dataArray = [[NSMutableArray alloc] init];
        
        [self loadMockData];
        //[self loadDataFromService];
	}
	return self;
}

- (void) loadMockData {
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[@"Spring", @"Hibernate", @"Tomcat"]forKey:@"Java"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[@"CSS", @"DOM"]forKey:@"HTML"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[@"iOS", @"OSX", @"Cocoa", @"XCode"]forKey:@"Objective-C"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[]forKey:@"Javascript"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[@"Gems", @"Rails", @"Active Record", @"Capistrano", @"RSpec"]forKey:@"Ruby"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[]forKey:@"Python"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[]forKey:@"C++"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[]forKey:@"Shell"]];
    [dataArray addObject:[NSDictionary dictionaryWithObject:@[]forKey:@"PHP"]];
}

- (void) loadDataFromService {
    NSString *dataURL = @"http://localhost:8888/data/demo.json";

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View Management Methods
- (void)viewDidLoad {
	[super viewDidLoad];

	CGFloat margin = 0.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat pickerHeight = 110.0f;
	CGFloat x = margin;
	CGFloat y = 45.0f;
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
	_pickerView.selectionIndicatorImageName = @"mask";
    _pickerView.indicatorPosition = PickerIndicatorTop; // specify indicator's location
    _pickerView.indicatorIsMask = YES;
    
	_pickerView.minorTickImageName = @"tick";
	_pickerView.majorDividerImageName = @"divider";

	[self.view addSubview:_pickerView];

	y = y + tmpFrame.size.height + spacing;
	tmpFrame = CGRectMake(x, y, width, 50.0f);
	_infoLabel = [[UILabel alloc] initWithFrame:tmpFrame];
	_infoLabel.backgroundColor = [UIColor blackColor];
	_infoLabel.textColor = [UIColor whiteColor];
	_infoLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:_infoLabel];
    
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	self.pickerView = nil;
	self.infoLabel  = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_pickerView scrollToMinorElement:0 withMajorElement:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
	tmpFrame = _infoLabel.frame;
	tmpFrame.origin.y = y;
	_infoLabel.frame = tmpFrame;

}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker {
    return [dataArray count];
}

- (NSString *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    
    NSDictionary * item = [dataArray objectAtIndex:index];
    NSArray *keys = [item allKeys];
    return [keys objectAtIndex:0];
}

- (NSString *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker titleForMinorElementAtIndex:(NSInteger)minorIndex withMajorIndex:(NSInteger)majorIndex {
    if ([dataArray count]>0) {
        NSDictionary * item = [dataArray objectAtIndex:majorIndex];
        NSArray *keys = [item allKeys];
        NSArray * list = [item valueForKey:[keys objectAtIndex:0]];       
        
        if (list.count > 0) {
            return [list objectAtIndex:minorIndex];
        } else {
            return@"";
        }
    } else {
        return @"";
    }
}

- (NSArray *)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker childrenForElementAtIndex:(NSInteger)index {
    if ([dataArray count] > 0) {
        NSDictionary * item = [dataArray objectAtIndex:index];
        NSArray *keys = [item allKeys];
        return [item valueForKey:[keys objectAtIndex:0]];
    } else {
        return @[];
    }
}

#pragma mark - MultiLevelHorizontalPickerView Delegate Methods
- (void)multiLevelHorizontalPickerView:(TTMultiLevelHorizontalPickerView *)picker didSelectElementAtMajorIndex:(NSInteger)majorIndex withMinorIndex:(NSInteger)minorIndex {
	self.infoLabel.text = [NSString stringWithFormat:@"Selected major %d & minor %d index", majorIndex, minorIndex];
}

@end
