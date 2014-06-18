//
//  Y6ProgressiveScrollView.m
//
//
//  Created by Ysix on 28/05/2014.
//
//

#import "Y6ProgressiveScrollView.h"

@interface Y6ProgressiveScrollView () <UIScrollViewDelegate>

@end



@implementation Y6ProgressiveScrollView

@synthesize progressionDelegate, referenceOffsetIsY, pageControl;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code

		objectsDict = [[NSMapTable alloc] init];
		extensionBlocks = [[NSMutableDictionary alloc] init];

		[self setPagingEnabled:YES];
		[self setDelegate:self];

		pageControl = [[UIPageControl alloc] init];
		pageControl.currentPage = 0;
		[pageControl setHidden:YES];

		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
	[super setContentSize:contentSize];

	[pageControl setNumberOfPages:contentSize.width / self.frame.size.width];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	pageControl.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 30, frame.size.width, 10);
}

#pragma mark - extension management methods

- (BOOL)addExtensionBlocksForSoloOffset:(void (^)(id object, id userInfos))soloBlock andBetweenOffset:(void (^)(id object, id previousUserInfos, float progressionPercent, id nextUserInfos))betweenBlock forFlag:(unsigned int)flag
{
	if ([extensionBlocks objectForKey:[NSNumber numberWithInt:flag]] ||
		soloBlock == nil || betweenBlock == nil)
		return NO;

	void (^soloCopy)(id, id) = [soloBlock copy];
	void (^betweenCopy)(id, id, float, id) = [betweenBlock copy];

	[extensionBlocks setObject:@{@"soloBlock" : soloCopy, @"betweenBlock" : betweenCopy} forKey:[NSNumber numberWithInt:flag]];
	return YES;
}

#pragma mark - animated objects management methods

- (BOOL)setUserInfos:(id)userInfos forObject:(id)object withFlag:(unsigned int)flag atOffsetValue:(CGFloat)offset
{
	NSDictionary *infosDict = @{@"offset" : [NSNumber numberWithFloat:offset], @"userInfos" : userInfos};

	if ([objectsDict objectForKey:object] && [[objectsDict objectForKey:object] objectForKey:[NSString stringWithFormat:@"%u", flag]])
	{
		for (NSDictionary *dict in [[objectsDict objectForKey:object] objectForKey:[NSString stringWithFormat:@"%u", flag]])
		{
			if ([[dict objectForKey:@"offset"] isEqualToNumber:[infosDict objectForKey:@"offset"]])
				return NO;
		}
		[[[objectsDict objectForKey:object] objectForKey:[NSString stringWithFormat:@"%u", flag]] addObject:infosDict];
	}
	else if ([objectsDict objectForKey:object])
	{
		[[objectsDict objectForKey:object] setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%u", flag]];
		[[[objectsDict objectForKey:object] objectForKey:[NSString stringWithFormat:@"%u", flag]] addObject:infosDict];
	}
	else
	{
		[objectsDict setObject:[[NSMutableDictionary alloc] init] forKey:object];
		[[objectsDict objectForKey:object] setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%u", flag]];
		[[[objectsDict objectForKey:object] objectForKey:[NSString stringWithFormat:@"%u", flag]] addObject:infosDict];
	}
	return  YES;
}

#pragma mark - private methods

- (void)updateObject:(id)object withUserInfos:(id)userInfos forFlag:(unsigned int)flag
{
	if ([extensionBlocks objectForKey:[NSNumber numberWithInt:flag]])
	{
		void (^soloBlock)(id, id) = [[extensionBlocks objectForKey:[NSNumber numberWithInt:flag]] objectForKey:@"soloBlock"];

		soloBlock(object, userInfos);
	}
}

- (void)updateObject:(id)object fromPreviousUserInfos:(id)previousUserInfos atProgressionPercent:(float)progressionPercent toNextUserInfos:(id)nextUserInfos forFlag:(unsigned int)flag
{
	if ([extensionBlocks objectForKey:[NSNumber numberWithInt:flag]])
	{
		void (^betweenBlock)(id, id, float, id) = [[extensionBlocks objectForKey:[NSNumber numberWithInt:flag]] objectForKey:@"betweenBlock"];

		betweenBlock(object, previousUserInfos, progressionPercent, nextUserInfos);
	}
}



#pragma mark - scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int page = scrollView.contentOffset.x/scrollView.frame.size.width;
	pageControl.currentPage=page;
}

// pour optimiser si besoin, trier par offset a l'insertion et interrompre la recherche lorsqu'on a trouver le bon, plutot que de chercher dans toute la liste.

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat currentOffset = (referenceOffsetIsY ? scrollView.contentOffset.y : scrollView.contentOffset.x);

	for (id object in [[objectsDict keyEnumerator] allObjects])
	{
		for (NSString *flag in [[objectsDict objectForKey:object] allKeys])
		{
			CGFloat previousOffset = 0;
			id previousUserInfos = nil;

			CGFloat nextOffset = 0;
			id nextUserInfos = nil;

			for (NSDictionary *dict in [[objectsDict objectForKey:object] objectForKey:flag])
			{
				if ([[dict objectForKey:@"offset"] floatValue] == currentOffset)
				{
					if ([extensionBlocks objectForKey:[NSNumber numberWithInt:[flag intValue]]])
					{
						[self updateObject:object withUserInfos:[dict objectForKey:@"userInfos"] forFlag:[flag intValue]];
					}
					else if (progressionDelegate)
					{
						[progressionDelegate updateObject:object withUserInfos:[dict objectForKey:@"userInfos"] forFlag:[flag intValue]];
					}

					previousUserInfos = nil;
					nextUserInfos = nil;

					break;
				}
				else if ([[dict objectForKey:@"offset"] floatValue] > currentOffset)
				{
					if (!nextUserInfos)
					{
						nextOffset = [[dict objectForKey:@"offset"] floatValue];
						nextUserInfos = [dict objectForKey:@"userInfos"];
					}
					else if ([[dict objectForKey:@"offset"] floatValue] < nextOffset)
					{
						nextOffset = [[dict objectForKey:@"offset"] floatValue];
						nextUserInfos = [dict objectForKey:@"userInfos"];
					}
				}
				else if ([[dict objectForKey:@"offset"] floatValue] < currentOffset)
				{
					if (!previousUserInfos)
					{
						previousOffset = [[dict objectForKey:@"offset"] floatValue];
						previousUserInfos = [dict objectForKey:@"userInfos"];
					}
					else if ([[dict objectForKey:@"offset"] floatValue] > previousOffset)
					{
						previousOffset = [[dict objectForKey:@"offset"] floatValue];
						previousUserInfos = [dict objectForKey:@"userInfos"];
					}
				}
			}

			if (previousUserInfos && nextUserInfos)
			{
				float progression = (currentOffset - previousOffset) * 100. / (nextOffset - previousOffset);

				if ([extensionBlocks objectForKey:[NSNumber numberWithInt:[flag intValue]]])
				{
					[self updateObject:object fromPreviousUserInfos:previousUserInfos atProgressionPercent:progression toNextUserInfos:nextUserInfos forFlag:[flag intValue]];
				}
				else if (progressionDelegate)
				{
					[progressionDelegate updateObject:object fromPreviousUserInfos:previousUserInfos atProgressionPercent:progression toNextUserInfos:nextUserInfos forFlag:[flag intValue]];
				}
			}
		}
	}
}

@end
