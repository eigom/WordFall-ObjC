//
//  GameViewController.m
//  WordFall
//
//  Created by eigo on 26/01/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MWDefinition.h"
#import "MWDefinitions.h"
#import "MWWord.h"
#import "MWLengthControl.h"
#import "MWPurchaseManager.h"
#import "MWWordManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

#pragma ads

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Ad loaded");
    [self presentAdBannerAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Ad failed");
    [self dismissAdBannerAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    [self gameScene].paused = YES;
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self gameScene].paused = NO;
}

- (void)presentAdBannerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?1.0:0.0 animations:^{
        bannerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAdBannerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?1.0:0.0 animations:^{
        bannerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeAdBannerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?1.0:0.0 animations:^{
        bannerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        bannerView = nil;
    }];
}

- (CGRect)bannerFrame
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return CGRectMake(0.0, 0.0, self.view.frame.size.width, 32.0);
    } else {
        return CGRectMake(0.0, 0.0, self.view.frame.size.width, 66.0);
    }
}

#pragma Definition

- (void)presentWordDefinition:(MWWord *)word withDuration:(CFTimeInterval)duration
{
    definitionTextView.attributedText = word.definitions.attributedText;
    
    [UIView animateWithDuration:duration animations:^{
        backgroundStrip.alpha = 1.0;
        definitionTextView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWordDefinitionWithDuration:(CFTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        backgroundStrip.alpha = 0.0;
        definitionTextView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma Progress

- (void)presentProgressWithText:(NSString *)text
{
    if (progressView == nil) {
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
        progressView.userInteractionEnabled = NO;
        progressView.backgroundColor = [UIColor blackColor];
        progressView.alpha = 0.0;
        [self.view addSubview:progressView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.text = text;
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(CGRectGetMidX(progressView.frame), CGRectGetMidY(progressView.frame));
        [progressView addSubview:textLabel];
        
        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dotLabel.backgroundColor = [UIColor clearColor];
        dotLabel.textColor = [UIColor whiteColor];
        dotLabel.font = [UIFont systemFontOfSize:15];
        dotLabel.text = @"●";
        [dotLabel sizeToFit];
        dotLabel.center = CGPointMake(textLabel.frame.origin.x-16.0, CGRectGetMidY(progressView.frame));
        [progressView addSubview:dotLabel];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             dotLabel.center = CGPointMake(textLabel.frame.origin.x-4.0, CGRectGetMidY(progressView.frame));
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:0.4 animations:^{
            progressView.alpha = 0.8;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)dismissProgress
{
    [UIView animateWithDuration:0.4 animations:^{
        progressView.alpha = 0.0;
    } completion:^(BOOL finished) {
        progressView = nil;
    }];
}

#pragma view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)appWillEnterForeground
{
    [[self gameScene] resumePlay];
}

- (void)appDidBecomeActive
{
    [[self gameScene] resumePlay];
}

- (void)appWillResignActive
{
    [[self gameScene] pausePlay];
}

- (void)appDidEnterBackground
{
    [[self gameScene] pausePlay];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView *skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        //GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        GameScene *scene = [[GameScene alloc] initWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [scene setWillBeginPlay:^() {
            //
            // ad banner
            //
            if ([MWPurchaseManager sharedManager].isPurchased == NO) {
                if (bannerView == nil) {
                    bannerView = [[ADBannerView alloc] initWithFrame:[self bannerFrame]];
                    bannerView.center = CGPointMake(CGRectGetMidX([self skView].bounds), bannerView.center.y);
                    bannerView.delegate = self;
                    [self.view addSubview:bannerView];
                    [self dismissAdBannerAnimated:NO];
                }
            }
        }];
        
        [scene setShouldPresentWordDefinition:^(MWWord *word, CFTimeInterval duration) {
            [self presentWordDefinition:word withDuration:duration];
        }];
        
        [scene setShouldDismissWordDefinition:^(CFTimeInterval duration) {
            [self dismissWordDefinitionWithDuration:duration];
        }];
        
        [scene setShouldPresentProgress:^(NSString *text) {
            [self presentProgressWithText:text];
        }];
        
        [scene setShouldDismissProgress:^() {
            [self dismissProgress];
        }];
        
        [scene setShouldRemoveAds:^() {
            [self removeAdBannerAnimated:YES];
        }];
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
    //
    // definition text view
    //
    if (definitionTextView == nil) {
        //
        // dark background strip
        //
        backgroundStrip = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self gameScene].definitionAreaYOrigin, [self skView].bounds.size.width, [self skView].bounds.size.height-[self gameScene].definitionAreaYOrigin)];
        backgroundStrip.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        [[self skView] addSubview:backgroundStrip];
        
        //
        // definition view
        //
        CGFloat width = [self skView].bounds.size.width * 0.75;
        CGFloat xOrigin = ([self skView].bounds.size.width - width) / 2.0 + 20.0;
        definitionTextView = [[UITextView alloc] initWithFrame:CGRectIntegral(CGRectMake(xOrigin, [self gameScene].definitionAreaYOrigin, width, [self gameScene].definitionAreaHeight-10.0))];
        definitionTextView.editable = NO;
        definitionTextView.selectable = NO;
        definitionTextView.attributedText = [MWDefinition wordGuruText];
        definitionTextView.showsHorizontalScrollIndicator = NO;
        definitionTextView.showsVerticalScrollIndicator = NO;
        definitionTextView.backgroundColor = [UIColor clearColor];
        definitionTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
        definitionTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        definitionTextView.layer.shadowOpacity = 1.0f;
        definitionTextView.layer.shadowRadius = 0.5f;
        [[self skView] addSubview:definitionTextView];
    }
    
    //
    // word length control
    //
    if (lengthControl == nil) {
        lengthControl = [[MWLengthControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, [self skView].bounds.size.height) title:@"WORD LENGTH" minValue:3 maxValue:[self gameScene].maxLetterCount value:[MWWordManager sharedManager].wordLength];
        [lengthControl setLengthSelected:^(NSInteger length) {
            [[MWWordManager sharedManager] setWordLength:length];
        }];
        [[self skView] addSubview:lengthControl];
    }
}

- (SKView *)skView
{
    return (SKView *)self.view;
}

- (GameScene *)gameScene
{
    return (GameScene *)[self skView].scene;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
