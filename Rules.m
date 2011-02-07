//
//  Rules.m
//  CoreText
//
//  Created by Matthys Strydom on 2011/02/07.
//  Copyright 2011 Polymorph Systems. All rights reserved.
//

#import "Rules.h"


@implementation DefaultSettingRule

-(struct DrawingParameters) adjustParameters:(struct DrawingParameters)par{
	// The default rule does nothing to the initial setting.
	NSLog(@"Default rule: not changing any parameters");
	return par;
}

-(bool) canMakeFurtherAdjustment:(struct DrawingParameters)par {
	// This can only be tried once, so no further adjustment is made.
	return NO;
}
@end

@implementation ReduceFontSizeRule

-(ReduceFontSizeRule*) init:(int)minSize:(int)interval{
	self = [super init];
	if (self) {
		MinFontSize = minSize;
		FontReductionInterval = interval;
	}
	return self;
}

-(struct DrawingParameters) adjustParameters:(struct DrawingParameters)par{
	int currentFont = par.FontSize;
	if (currentFont < MinFontSize) {
		NSLog(@"Got font size that is smaller than min font size. Initial definition is invalid");
		return par;
	}
	int newFont = currentFont - FontReductionInterval;
	if (newFont < MinFontSize) {
		newFont = MinFontSize;
	}
	par.FontSize = newFont;
	NSLog(@"Font reduction: Reducing from %i to %i", currentFont, newFont);
	return par;
}

-(bool) canMakeFurtherAdjustment:(struct DrawingParameters)par {
	return par.FontSize > MinFontSize;
}

@end

