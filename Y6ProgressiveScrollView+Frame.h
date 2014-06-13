//
//  Y6ProgressiveScrollView+Frame.h
//
//
//  Created by Yix on 12/06/2014.
//
//

#import "Y6ProgressiveScrollView.h"

#define FLAG_FRAME 0

#define FRAME_OPTION_PIN_AFTER	1

@interface Y6ProgressiveScrollView (Frame)
{

}

- (BOOL)activeFrameExtension;

- (BOOL)setFrame:(CGRect)frame forObject:(id)object withOptions:(int)frameOptions atOffsetValue:(CGFloat)offset;


@end
