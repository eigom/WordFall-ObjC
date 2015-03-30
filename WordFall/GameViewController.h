//
//  GameViewController.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface GameViewController : UIViewController <ADBannerViewDelegate> {
@private
    ADBannerView *bannerView;
}

@property (nonatomic, strong) IBOutlet UITextView *definitionTextView;

@end
