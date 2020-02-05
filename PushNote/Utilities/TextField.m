//
//  TextField.m

#import "TextField.h"

@implementation TextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];

        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
        
        // Initialization code
    }
    return self;
}

-(void) baseInit
{

      NSString *fontNameFromXib = self.font.fontName;
    float fontSizeFromXib = self.font.pointSize;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        fontSizeFromXib = fontSizeFromXib*1.5;
        self.font = [UIFont fontWithName:fontNameFromXib size:fontSizeFromXib];
    }
  //  if([fontNameFromXib isEqualToString:[UIFont systemFontOfSize:fontSizeFromXib].fontName])
       // self.font = NORMAL_FONT_OF_SIZE(fontSizeFromXib);
  //  else if([fontNameFromXib isEqualToString:[UIFont boldSystemFontOfSize:fontSizeFromXib].fontName])
       // self.font = BOLD_FONT_OF_SIZE(fontSizeFromXib);


}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    [self.layer addSublayer:bottomBorder];
}


// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 ,0 );
}

@end
