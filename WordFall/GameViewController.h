//
//  GameViewController.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@class MWLengthControl;
@class MWSoundControl;

@interface GameViewController : UIViewController <ADBannerViewDelegate> {
@private
    ADBannerView *bannerView;
    UITextView *definitionTextView;
    MWLengthControl *lengthControl;
    MWSoundControl *soundControl;
    UIView *backgroundStrip;
    UIView *progressView;
}

@end
