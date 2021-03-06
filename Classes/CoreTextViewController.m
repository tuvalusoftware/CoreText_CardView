//
//  CoreTextViewController.m
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreTextViewController.h"
#import <CoreText/CoreText.h>

@implementation CoreTextViewController

@synthesize cardView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Create and apply the properties needed for the view.
	CardDefinition * def = [[CardDefinition alloc] init];
	def.CardWidth = 300;
	def.MinCardHeight = 200;
	def.MaxCardHeight = 300;
	def.CardColor = [UIColor yellowColor].CGColor;
	def.Font = CTFontDescriptorCreateWithNameAndSize(CFSTR("Times New Roman"), 30);
	def.FontColor = [UIColor blueColor].CGColor;
	def.TextOverflow = @"...";
	def.MaxFontSize = 20;
	def.MinFontSize = 15;
	def.LeftMargin = 10;
	def.RightMargin = 20;
	def.TopMargin = 15;
	def.BottomMargin = 25;
	def.TextAllignment = kCTJustifiedTextAlignment;
	//NSString* message = @"This is my message that i need to keep on adding to so that it is a multi line string. Which is now not short enough to test the first rule, which is to lower the font size until min font size is reached. Which was still not the case, so I am trying some more random text.";
	NSString* message = @"Short message.";
	
	cardView.CardDefinition = def;
	cardView.Message = message;
	
	[def release];
	
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscape);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[cardView release];
    [super dealloc];
}

@end
