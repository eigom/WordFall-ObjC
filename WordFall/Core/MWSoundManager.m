//
//  MWSoundManager.m
//  WordFall
//
//  Created by eigo on 07/04/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSoundManager.h"

static NSString * const kSoundEnabledKey = @"kSoundEnabledKey";

static NSString * const kStreamSoundFilename = @"stream.mp3";
static NSString * const kRevealLetterSoundFilename = @"reveal-letter.mp3";
static NSString * const kRevealWordSoundFilename = @"reveal-word.mp3";

@implementation MWSoundManager

+ (MWSoundManager *)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        manager = [[MWSoundManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init])) {
        NSString *enabled = [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEnabledKey];
        
        if (enabled) {
            _soundEnabled = [enabled isEqualToString:@"1"];
        } else {
            _soundEnabled = YES; // default
        }
    }
    
    return self;
}

- (SKAction *)streamSound
{
    if (_soundEnabled) {
        return [SKAction playSoundFileNamed:kStreamSoundFilename waitForCompletion:NO];
    } else {
        return nil;
    }
}

- (SKAction *)revealLetterSound
{
    if (_soundEnabled) {
        return [SKAction playSoundFileNamed:kRevealLetterSoundFilename waitForCompletion:NO];
    } else {
        return nil;
    }
}

- (SKAction *)revealWordSound
{
    if (_soundEnabled) {
        return [SKAction playSoundFileNamed:kRevealWordSoundFilename waitForCompletion:NO];
    } else {
        return nil;
    }
}

- (void)setSoundEnabled:(BOOL)soundEnabled
{
    _soundEnabled = soundEnabled;
    
    [[NSUserDefaults standardUserDefaults] setObject:(_soundEnabled?@"1":@"0") forKey:kSoundEnabledKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
