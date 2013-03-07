//
//  JLViewController.h
//  JamieLidellMobile
//
//  Created by Marshall Moutenot on 2/24/13.
//  Copyright (c) 2013 Marshall Moutenot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashController.h"

typedef enum lightState {
  ls_off      = 0,
  ls_on       = 1,
  ls_strobe_1 = 2,
  ls_strobe_2 = 3,
  ls_strobe_3 = 4,
  ls_strobe_4 = 5,
} LightState;

@interface JLViewController : UIViewController

@property (retain, nonatomic) FlashController *fc;
@property (nonatomic, retain) NSTimer *strobeTimer;
@property (nonatomic, assign) LightState *nextLightState;
@property (nonatomic, assign) BOOL lightOn;
@property (nonatomic, assign) BOOL strobeActivated;
@property (nonatomic, assign) BOOL strobeFlashOn;
@property (nonatomic, assign) float strobeRate;

@property (strong, nonatomic) IBOutlet UIButton *jamieButton;
@property (strong, nonatomic) UIImage *buttonImage;
@property (weak, nonatomic) IBOutlet UILabel *flasher_title;

@property (strong, nonatomic) NSTimer *hueTimer;
@property (strong, nonatomic) NSNumber *currentHue;

- (IBAction)buttonDown:(id)sender;
- (IBAction)websiteButtonClick:(id)sender;
- (IBAction)explainButtonClick:(id)sender;

@end
