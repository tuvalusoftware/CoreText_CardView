//
//  CTCardView.m
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 Polymporph Systems. All rights reserved.
//

#import "CTCardView.h"
#import <CoreText/CoreText.h>
#import "CardDefinition.h"

@implementation CTCardView

@synthesize Message;
@synthesize CardDefinition;

struct DrawingParameters{
	float TextBoxHeight;
	float TextBoxWidth;
	int FontSize;
	CTFramesetterRef Framesetter;
};

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        // Initialization code
		self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

// Creates a framesetter, using the given font size.
-(CTFramesetterRef)createFrameSetter:(int)fontSize{
	CTFontRef realFont = CTFontCreateWithFontDescriptor(self.CardDefinition.Font, fontSize, NULL);
	CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(NULL, [Message length]);
	CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) Message);
	CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, realFont);
	CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTForegroundColorAttributeName, self.CardDefinition.FontColor);
	return CTFramesetterCreateWithAttributedString(attrStr);
}

// Goes through the list of rules, until it the text finally fits into the given parameters.
// IMPLICIT LOGIC WARNING: The initial width and height that the method is called with
// is taken to be the maximum bounds.
- (struct DrawingParameters)AdaptParametersAccordingToRules:(struct DrawingParameters)par{
	float maxHeight = par.TextBoxHeight;
	float maxWidth = par.TextBoxWidth;
	CGSize constraints = CGSizeMake(maxWidth, maxHeight);
	int messageLength = [Message length];
	
	// Rule one: Try the framesetter as is, and see if it fits.
	CFRange range;
	CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(par.Framesetter, CFRangeMake(0, messageLength), nil, constraints, &range);
	if (range.length >= messageLength) {
		par.TextBoxHeight = coreTextSize.height;
		par.TextBoxWidth = coreTextSize.width;
	}
	else {
		[NSException raise:@"Got to end of rule set. Temp setback" format:@"blah"];
	}

	return par;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] set];
	CGContextRef context = (CGContextRef)UIGraphicsGetCurrentContext();
	
	// Fill in the initial parameters of the card to be checked for fitting by the rule system.
	struct DrawingParameters par;
	par.TextBoxHeight = self.CardDefinition.MaxCardHeight-10;
	par.TextBoxWidth = self.CardDefinition.CardWidth-10;
	par.FontSize = self.CardDefinition.MaxFontSize;
	par.Framesetter = [self createFrameSetter:self.CardDefinition.MaxFontSize];
	
	// We then pass the drawing parameters to the rules system, getting the final result back.
	par = [self AdaptParametersAccordingToRules:par];

	float cardHeight = par.TextBoxHeight;
	if (self.CardDefinition.MinCardHeight-10 > cardHeight) {
		cardHeight = self.CardDefinition.MinCardHeight-10;
	}
	
	// Work out the dimentions of all the elements involved.
	float totalHeight= rect.size.height; 
	float totalWidth = rect.size.width;
	CGRect pageSize = CGRectMake(0, 0, totalWidth, totalHeight);
	
	float cardDeltaX = (totalWidth - par.TextBoxWidth - 20) / 2;
	float cardDeltaY = (totalHeight - cardHeight - 20) / 2;
	CGRect cardSize = CGRectInset(pageSize, cardDeltaX, cardDeltaY);
	
	float textDeltaX = (totalWidth - par.TextBoxWidth) / 2;
	float textDeltaY = (totalHeight - par.TextBoxHeight) / 2;
	CGRect textRect = CGRectInset(pageSize, textDeltaX, textDeltaY);
	
	//Draw a rectangle
	CGContextSetFillColorWithColor(context, self.CardDefinition.CardColor);
	//Define a rectangle
	CGContextAddRect(context, cardSize);
	//Draw it
	CGContextFillPath(context);

	// Comment this back in to see where the text rectangle ends up.
	/*
	CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
	CGContextAddRect(context, textRect);
	CGContextFillPath(context);
	*/ 
	 
	// Translate the coordinates to work for text drawing. Google this :)
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
	
	// Draw the text.
    [UIBezierPath bezierPathWithRect:[self bounds]];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, textRect);
	CTFrameRef frame = CTFramesetterCreateFrame(par.Framesetter, CFRangeMake(0, 0), path, NULL);
	CTFrameDraw(frame, context);

	//CFRelease(frame);
    //CFRelease(finalPath);
}

- (void)dealloc {
	[CardDefinition release];
	[Message release];
	
    [super dealloc];
}


@end
