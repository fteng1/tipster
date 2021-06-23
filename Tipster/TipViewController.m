//
//  TipViewController.m
//  Tipster
//
//  Created by Felianne Teng on 6/22/21.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billAmountField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipPercentageControl;
@property (weak, nonatomic) IBOutlet UIView *labelsContainerView;
@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)convertToPercent:(double)dec {
    return [NSString stringWithFormat:@"%.1f%%", dec];
}

- (void)setDarkMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool darkModeOn = [defaults boolForKey:@"dark_mode"];
    if (darkModeOn) {
        UIColor *darkDark = [UIColor colorWithRed:0 green:22/255.0 blue:102/255.0 alpha:1];
        UIColor *darkMedium = [UIColor colorWithRed:0 green:35/255.0 blue:163/255.0 alpha:1];
        UIColor *darkLight = [UIColor colorWithRed:33/255.0 green:59/255.0 blue:156/255.0 alpha:1];
        self.view.backgroundColor = darkMedium;
        self.billAmountField.textColor = [UIColor whiteColor];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.totalLabel.textColor = [UIColor whiteColor];
        self.tipPercentageControl.backgroundColor = darkLight;
        self.tipPercentageControl.selectedSegmentTintColor = darkMedium;
        self.labelsContainerView.backgroundColor = darkDark;
        [self.tipPercentageControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
        [self.tipPercentageControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
        NSAttributedString *ph = [[NSAttributedString alloc] initWithString:@"$" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:150/255.0 green:174/255.0 blue:255/255.0 alpha:1] }];
        self.billAmountField.attributedPlaceholder = ph;
    }
    else {
        UIColor *lightDark = [UIColor colorWithRed:117/255.0 green:233/255.0 blue:245/255.0 alpha:1];
        UIColor *lightMedium = [UIColor colorWithRed:211/255.0 green:242/255.0 blue:245/255.0 alpha:1];
        self.view.backgroundColor = lightMedium;
        self.billAmountField.textColor = [UIColor blackColor];
        self.tipLabel.textColor = [UIColor blackColor];
        self.totalLabel.textColor = [UIColor blackColor];
        self.tipPercentageControl.backgroundColor = lightMedium;
        self.tipPercentageControl.selectedSegmentTintColor = lightMedium;
        self.labelsContainerView.backgroundColor = lightDark;
        [self.tipPercentageControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
        [self.tipPercentageControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
        NSAttributedString *ph = [[NSAttributedString alloc] initWithString:@"$" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1] }];
        self.billAmountField.attributedPlaceholder = ph;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (int i = 0; i < 3; i++) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        [self.tipPercentageControl setTitle:[self convertToPercent:defaultVal] forSegmentAtIndex:i];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"default_tip_%ld", self.tipPercentageControl.selectedSegmentIndex];
    double defaultVal = [defaults doubleForKey:key];
    double tipPercentage = defaultVal / 100;
    
    double bill = [[self.billAmountField.text substringWithRange:NSMakeRange(1, [self.billAmountField.text length] - 1)] doubleValue];
    double tip = bill * tipPercentage;
    double total = bill + tip;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
    [self setDarkMode];
    NSLog(@"View will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.billAmountField becomeFirstResponder];
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

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)updateLabels:(id)sender {
    if (self.billAmountField.text.length == 0 || [self.billAmountField.text isEqualToString:@"$"]) {
        self.billAmountField.text = @"";
        [self hideLabels];
    }
    else {
        if (self.labelsContainerView.alpha == 0) {
            [self showLabels];
            self.billAmountField.text = [@"$" stringByAppendingString:self.billAmountField.text];
        }
    }
    double tipPercentages[] = {0.15, 0.2, 0.25};
    for (int i = 0; i < 3; i++) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        tipPercentages[i] = defaultVal / 100;
    }
    double tipPercentage = tipPercentages[self.tipPercentageControl.selectedSegmentIndex];
    
    double bill = [[self.billAmountField.text substringWithRange:NSMakeRange(1, [self.billAmountField.text length] - 1)] doubleValue];
    double tip = bill * tipPercentage;
    double total = bill + tip;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
}

- (void)hideLabels {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect billFrame = self.billAmountField.frame;
        billFrame.origin.y += 200;
        
        self.billAmountField.frame = billFrame;
        
        CGRect labelsFrame = self.labelsContainerView.frame;
        labelsFrame.origin.y += 200;
        
        self.labelsContainerView.frame = labelsFrame;
        
        self.labelsContainerView.alpha = 0;
    }];
}

- (void)showLabels {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect billFrame = self.billAmountField.frame;
        billFrame.origin.y -= 200;
        
        self.billAmountField.frame = billFrame;
        
        CGRect labelsFrame = self.labelsContainerView.frame;
        labelsFrame.origin.y -= 200;
        
        self.labelsContainerView.frame = labelsFrame;
        
        self.labelsContainerView.alpha = 1;
    }];
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
