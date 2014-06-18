//
//  Y6ProgressiveScrollView+Alpha.h
//
//
//  Created by Ysix on 13/06/2014.
//
//

#import "Y6ProgressiveScrollView.h"

#define FLAG_ALPHA 1


@interface Y6ProgressiveScrollView (Alpha)

- (BOOL)activeAlphaExtension;
- (BOOL)setAlpha:(CGFloat)alpha forObject:(id)object atOffsetValue:(CGFloat)offset;

@end
