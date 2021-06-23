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
@end

@implementation SettingsViewController

- (NSString *)convertToPercent:(double)dec {
    return [NSString stringWithFormat:@"%.1f%%", dec];
}

- (void)loadDefaultValue {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < 3; i++) {
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        [self.tipIndexControl setTitle:[self convertToPercent:defaultVal] forSegmentAtIndex:i];
    }
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
    NSLog(@"View will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"View did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

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
}

- (IBAction)onSelectIndex:(id)sender {
    [self loadDefaultValue];
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
