//
//  Y6ProgressiveScrollView+Y6HighlightSpotView.h
//
//
//  Created by Ysix on 12/06/2014.
//
//

#import "Y6ProgressiveScrollView.h"
#import "Y6HighlightSpotView.h"

#define FLAG_HIGHLIGHT_SPOT_VIEW 4

@interface Y6ProgressiveScrollView (Y6HighlightSpotView)
{

}

- (BOOL)activeHighlightSpotViewExtension;
- (BOOL)sethighlightPoint:(CGPoint)highlightedPoint withCirleRadius:(CGFloat)radius coveringRect:(CGRect)frame forHighlightSpot:(Y6HighlightSpotView *)spotView atOffsetValue:(CGFloat)offset;

@end
