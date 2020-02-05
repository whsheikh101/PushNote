//
//  SLButton.m
//  Ali Pourhadi
//
//  Created by Ali Pourhadi on 2015-09-28.
//  Copyright © 2015 Ali Pourhadi. All rights reserved.
//

#import "SLButton.h"

@interface SLButton ()
@property (strong,nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSString *currentText;
@property CGRect currentBounds;
@property CGFloat currentCornerRadius;
@end

@implementation SLButton

- (void)awakeFromNib {
    self.animationDuration = 0.3;
    self.disableWhileLoading = YES;
    [self.layer setBorderWidth:2.0];
   
    //[self.layer setBorderColor:[UIColor colorWithRed:17.0/255.0 green:29.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];
    [self.layer setCornerRadius:4.0];
    self.clipsToBounds = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
}

- (void)showLoading {
    _isLoading = YES;
   // [self addActivityIndicator];
    [self setCurrentData];
    //[self clearText];
    [self disableButton];
    [self deShapeAnimation];
    [self changeImage:YES];
    [self setNeedsDisplay];
}

- (void)addActivityIndicator {
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self setFrameForActivity];
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    [self.activity setCenter:self.center];
    [self.superview addSubview:self.activity];
}

- (void)changeImage:(BOOL) isLoading {
    
    if(isLoading){
       
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self setTitle:@"..." forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize+10]];
    }
    
    else{
        
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
       
        
            
            [self setTitleColor:[UIColor colorWithRed:17.0/255.0 green:29.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize-10]];
        //[self setTitle:@"Subscribed" forState:UIControlStateNormal];
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0.0 , 0.0, 0.0)];
       // [self setBackgroundImage:[UIImage imageNamed: @"loading"] forState:UIControlStateNormal];
    }
}


- (void)setCurrentData {
    NSLog(@"%@",self.currentTitle);
    [self setCurrentText:@"Subscribed!"];
    [self setCurrentBounds:self.bounds];
    [self setCurrentCornerRadius:self.layer.cornerRadius];
    
}

- (void)clearText {
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)disableButton {
    if (self.disableWhileLoading)
        [self setEnabled:NO];
}

- (void)deShapeAnimation {
    NSLog(@"Deshape animation");
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //sizing.duration= (self.animationDuration * 2) / 5.0;
    if (self.bounds.size.width > self.bounds.size.height)
        sizing.toValue= [NSValue valueWithCGRect:CGRectMake(self.layer.bounds.origin.x, self.layer.bounds.origin.y, self.layer.bounds.size.height, self.layer.bounds.size.height)];
    else
        sizing.toValue= [NSValue valueWithCGRect:CGRectMake(self.layer.bounds.origin.x, self.layer.bounds.origin.y, self.layer.bounds.size.width, self.layer.bounds.size.width)];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"de-scale"];
    [self setContentEdgeInsets:UIEdgeInsetsMake(-(self.layer.bounds.size.height/2.5), (self.layer.bounds.size.height/4.5) , 0.0, 0.0)];
    
    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.beginTime = CACurrentMediaTime() + (self.animationDuration * 2) / 5.0;
    shape.duration = (self.animationDuration * 3) / 5.0;
    shape.toValue= @(self.layer.bounds.size.height / 2.0);
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"de-shape"];
    
    UIColor *fromColor = [UIColor clearColor];
    UIColor * toColor = [UIColor clearColor];
    if(self.selected == true){
         toColor = [UIColor colorWithRed:239.0/255.0 green:90.0/255.0 blue:43.0/255.0 alpha:1.0];
        
        
    }else{
        
           toColor  = [UIColor colorWithRed:17.0/255.0 green:29.0/255.0 blue:185.0/255.0 alpha:1.0];
    }
    
  
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration =  1;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    colorAnimation.repeatDuration = 100.0;
    colorAnimation.repeatCount = 100.0;
    [self.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
    

    
//    CABasicAnimation *colorAnimation2 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    colorAnimation2.duration =  1;
//    colorAnimation2.fromValue = (id)toColor.CGColor;
//    colorAnimation2.toValue = (id)fromColor.CGColor;
//    colorAnimation.repeatDuration = 5.0;
//    [self.layer addAnimation:colorAnimation2 forKey:@"backgroundColor"];

}

- (void)reShapeAnimation {
    NSLog(@"Reshape Animation");
    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.duration = (self.animationDuration * 3) / 5.0;
    shape.toValue= @(self.currentCornerRadius);
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"re-shape"];
    
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizing.beginTime = CACurrentMediaTime() + (self.animationDuration * 3) / 5.0;
    sizing.duration= (self.animationDuration * 2) / 5.0;
    sizing.toValue= [NSValue valueWithCGRect:self.currentBounds];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"re-scale"];
    
    UIColor * fromColor = [UIColor clearColor];
    UIColor * toColor = self.layer.borderColor;
    CABasicAnimation * colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration =  1;
    colorAnimation.fromValue = (id)toColor;
    colorAnimation.toValue = (id)fromColor.CGColor;
    [self.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
    
    
}


- (void)hideLoading {
    
    _isLoading = NO;
    [self.activity removeFromSuperview];
    [self changeImage:NO];
    [self reShapeAnimation];
    [self reEnable];
    
    [self performSelector:@selector(resetText) withObject:nil afterDelay:self.animationDuration];
}

- (void)reEnable {
    [self setEnabled:YES];
}

- (void)resetText {
    [self setTitle:self.currentText forState:UIControlStateNormal];
}

- (void)setFrameForActivity {
    [self.activity setCenter:self.center];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setFrameForActivity];
}
@end
