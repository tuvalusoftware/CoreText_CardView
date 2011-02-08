//
//  CardDefinition.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/25.
//  Copyright 2011 Polymorph Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CardDefinition : NSObject {
@private 
	int PageHeight;
	int PageWidth;
	CGColorRef CardColor;
	CGColorRef BackgroundColor;
	int MaxCardHeight;
	int MinCardHeight;
	int DefaultCardHeight;
	int DistanceToMid;
	int RightMargin;
	int LeftMargin;
    int TopMargin;
    int BottomMargin;
	int CardWidth;
	NSString* TextOverflow;
	CTFontDescriptorRef Font;
	CGColorRef FontColor;
	int MaxFontSize;
	int MinFontSize;
	CTTextAlignment TextAllignment; 
}

@property int PageHeight;
@property int PageWidth;
@property CGColorRef CardColor;
@property CGColorRef BackgroundColor;
@property int MaxCardHeight;
@property int MinCardHeight;
@property int DefaultCardHeight;
@property int DistanceToMid;
@property int RightMargin;
@property int LeftMargin;
@property int TopMargin;
@property int BottomMargin;
@property int CardWidth;
@property (retain) NSString* TextOverflow;
@property CTFontDescriptorRef Font;
@property CGColorRef FontColor;
@property int MaxFontSize;
@property int MinFontSize;
@property CTTextAlignment TextAllignment;

/* Things to add still
 @property image CardBackgroundImage;
  @property image BackgroundImage;
 
 */

@end
