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
	int TextBoxHeight;
	int TextBoxWidth;
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
 
- (CGPathRef) createTextPath:(CTFramesetterRef)framesetter:(CGRect)textBox {
	int textLength = [Message length];
	CFRange range;
	CGFloat maxWidth  = textBox.size.width;
	CGFloat maxHeight = textBox.size.height;
	CGSize constraint = CGSizeMake(maxWidth, maxHeight);
	
	CGFloat finalWidth;
	CGFloat finalHeight;
	//  checking frame sizes
	for (int i = 1; i <= textLength; i++) {
		CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, i), nil, constraint, &range);
		NSLog(@"Letter: %c h: %f w: %f", [Message characterAtIndex:i-1], coreTextSize.height, coreTextSize.width);
		finalWidth = coreTextSize.width;
		finalHeight = coreTextSize.height;
	}
	
	int deltaX = (maxWidth - finalWidth) / 2;
	int deltaY = (maxHeight - finalHeight) / 2;
	CGRect finalTextBox = CGRectInset(textBox, deltaX, deltaY);
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, finalTextBox);
	return path;
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] set];
	CGContextRef context = (CGContextRef)UIGraphicsGetCurrentContext();
	
	// Fill in the initial parameters of the card to be checked for fitting by the rule system.
	struct DrawingParameters par;
	par.TextBoxHeight = self.CardDefinition.MinCardHeight-10;
	par.TextBoxWidth = self.CardDefinition.CardWidth-10;
	par.FontSize = self.CardDefinition.MaxFontSize;
	par.Framesetter = [self createFrameSetter:self.CardDefinition.MaxFontSize];
	
	// We then pass the drawing parameters to the rules system, getting the final result back.
	//[self AdaptParametersAccordingToRules:par];

	int cardHeight = par.TextBoxHeight;
	if (self.CardDefinition.MinCardHeight-10 > cardHeight) {
		cardHeight = self.CardDefinition.MinCardHeight-10;
	}
	
	// Work out the dimentions of all the elements involved.
	int totalHeight= rect.size.height; 
	int totalWidth = rect.size.width;
	CGRect pageSize = CGRectMake(0, 0, totalWidth, totalHeight);
	
	int cardDeltaX = (totalWidth - par.TextBoxWidth - 20) / 2;
	int cardDeltaY = (totalHeight - cardHeight - 20) / 2;
	CGRect cardSize = CGRectInset(pageSize, cardDeltaX, cardDeltaY);
	
	int textDeltaX = (totalWidth - par.TextBoxWidth) / 2;
	int textDeltaY = (totalHeight - par.TextBoxHeight) / 2;
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
