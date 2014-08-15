//
//  theGrayButton.m
//  iMRT Taipei
//
//  Created by LarryStanley on 13/4/29.
//
//

#import "theGrayButton.h"

@implementation theGrayButton

- (id)initWithFrame:(CGRect)frame AndButtonText:(NSString *)ButtonString
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:ButtonString forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:ButtonString forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self setTitle:ButtonString forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[UIImage imageNamed:@"Button@2x.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ButtonSelected@2x.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"ButtonSelected@2x.png"] forState:UIControlStateSelected];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
