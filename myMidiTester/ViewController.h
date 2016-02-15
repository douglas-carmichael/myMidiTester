//
//  ViewController.h
//  myMidiTester
//
//  Created by Douglas Carmichael on 2/14/16.
//  Copyright © 2016 Douglas Carmichael. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MIKMIDI/MIKMIDI.h>


@interface ViewController : NSViewController
{
    IBOutlet NSTextView *myTextView;
}

@property (nonatomic, strong) MIKMIDIDeviceManager *dm;
@property (nonatomic, strong) NSMapTable *connectionTokensForSources;
@property (nonatomic, strong) id ourToken;

-(IBAction)playDrumHit:(id)sender;
-(IBAction)startMonitoring:(id)sender;
-(IBAction)stopMonitoring:(id)sender;
-(IBAction)clearTextView:(id)sender;

@end


