//
//  SettingsViewController.m
//  Tipster
//
//  Created by Felianne Teng on 6/22/21.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipIndexControl;
@property (weak, nonatomic) IBOutlet UITextField *inputAmountField;
@property (weak, nonatomic) IBOutlet UISwitch *darkModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *darkModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultTipLabel;
@end

@implementation SettingsViewController

- (NSString *)convertToPercent:(double)dec {
    return [NSString stringWithFormat:@"%.1f%%", dec];
}

- (void)syncDarkMode:(bool)isOn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOn forKey:@"dark_mode"];
    [defaults synchronize];
}

- (void)setColorMode:(double)animTime {
    if (self.darkModeSwitch.isOn) {
        [UIView animateWithDuration:animTime animations:^{
            UIColor *darkDark = [UIColor colorWithRed:0 green:22/255.0 blue:102/255.0 alpha:1];
            UIColor *darkMedium = [UIColor colorWithRed:0 green:35/255.0 blue:163/255.0 alpha:1];
            UIColor *darkLight = [UIColor colorWithRed:33/255.0 green:59/255.0 blue:156/255.0 alpha:1];
            self.inputAmountField.backgroundColor = darkLight;
            self.view.backgroundColor = darkMedium;
            self.tipIndexControl.backgroundColor = darkLight;
            self.tipIndexControl.selectedSegmentTintColor = darkMedium;
            self.darkModeSwitch.onTintColor = darkLight;
            self.darkModeLabel.textColor = [UIColor whiteColor];
            self.defaultTipLabel.textColor = [UIColor whiteColor];
            self.inputAmountField.textColor = [UIColor whiteColor];
            [self.tipIndexControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
            [self.tipIndexControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];

        }];
    }
    else {
        [UIView animateWithDuration:animTime animations:^{
            UIColor *lightDark = [UIColor colorWithRed:117/255.0 green:233/255.0 blue:245/255.0 alpha:1];
            UIColor *lightMedium = [UIColor colorWithRed:211/255.0 green:242/255.0 blue:245/255.0 alpha:1];
            UIColor *lightLight = [UIColor colorWithRed:226/255.0 green:243/255.0 blue:245/255.0 alpha:1];
            self.inputAmountField.backgroundColor = lightLight;
            self.view.backgroundColor = lightMedium;
            self.tipIndexControl.backgroundColor = lightMedium;
            self.tipIndexControl.selectedSegmentTintColor = lightMedium;
            self.darkModeSwitch.onTintColor = lightDark;
            self.darkModeLabel.textColor = [UIColor blackColor];
            self.defaultTipLabel.textColor = [UIColor blackColor];
            self.inputAmountField.textColor = [UIColor blackColor];
            [self.tipIndexControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
            [self.tipIndexControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
        }];
    }
}

- (void)loadDefaultValue {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < 3; i++) {
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        [self.tipIndexControl setTitle:[self convertToPercent:defaultVal] forSegmentAtIndex:i];
    }
}
- (void)setInputValue {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"default_tip_%ld", self.tipIndexControl.selectedSegmentIndex];
    double defaultVal = [defaults doubleForKey:key];
    NSString *str = [self convertToPercent:defaultVal];
    self.inputAmountField.text = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDefaultValue];
    [self setInputValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool darkModeOn = [defaults boolForKey:@"dark_mode"];
    self.darkModeSwitch.on = darkModeOn;
    NSLog(@"View will appear");
    [self setColorMode:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputAmountField becomeFirstResponder];
    NSLog(@"View did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self syncDarkMode:self.darkModeSwitch.isOn];
    NSLog(@"View will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    NSLog(@"View did disappear");
}

- (IBAction)onValueChanged:(id)sender {
    NSString *key = [NSString stringWithFormat:@"default_tip_%ld", self.tipIndexControl.selectedSegmentIndex];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double val = [self.inputAmountField.text doubleValue];
    [defaults setDouble:val forKey:key];
    [defaults synchronize];
    [self loadDefaultValue];
}

- (IBAction)onSelectIndex:(id)sender {
    [self loadDefaultValue];
    [self setInputValue];
}

- (IBAction)onToggle:(id)sender {
    [self setColorMode:0.5];
    [self syncDarkMode:self.darkModeSwitch.isOn];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
