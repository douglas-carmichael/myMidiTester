//
//  ViewController.m
//  myMidiTester
//
//  Created by Douglas Carmichael on 2/14/16.
//  Copyright © 2016 Douglas Carmichael. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.connectionTokensForSources = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(IBAction)playDrumHit:(id)selector {
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    NSLog(@"%@", [dm virtualSources]);
    NSLog(@"%@", [dm virtualDestinations]);
    
    NSDate *midiTimestamp = [NSDate date];
    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:67 velocity:127 channel:0 timestamp:midiTimestamp];
    MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:67 velocity:127 channel:0 timestamp:[midiTimestamp dateByAddingTimeInterval:0.5]];
    
    MIKMIDIDestinationEndpoint *KontaktDestination = [[dm virtualDestinations] objectAtIndex:2];
    NSLog(@"%@", KontaktDestination);
    [dm sendCommands:@[noteOn, noteOff] toEndpoint:KontaktDestination error:nil];
}

-(IBAction)startMonitoring:(id)sender
{
    NSError *error = nil;
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
    MIKMIDISourceEndpoint *ourSource = [[dm virtualSources] objectAtIndex:0];
    NSLog(@"%@", ourSource);
    self.ourToken = [dm connectInput:ourSource error:&error
        eventHandler:^(MIKMIDISourceEndpoint *ourSource, NSArray *commands) {
        for (MIKMIDICommand *command in commands) {
            [[myTextView textStorage] appendAttributedString:[[NSAttributedString alloc]
                                                              initWithString:[NSString stringWithFormat:@"\n%@: %@", [NSDate date], command]]];
            MIKMIDIDestinationEndpoint *KontaktDestination = [[dm virtualDestinations] objectAtIndex:2];
            [dm sendCommands:@[command] toEndpoint:KontaktDestination error:nil];
        }
    }];
    if(!self.ourToken)
    {
        NSLog(@"Cannot connect: %@", error);
    }
    else
    {
        NSLog(@"Connection successful!");
        [self.connectionTokensForSources setObject:self.ourToken forKey:ourSource];
    }
}

-(IBAction)stopMonitoring:(id)sender
{
    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
//    MIKMIDISourceEndpoint *ourSource = [[dm virtualSources] objectAtIndex:0];
    [dm disconnectConnectionForToken:self.ourToken];
}

-(IBAction)clearTextView:(id)sender
{
    [[myTextView textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
}
@end
