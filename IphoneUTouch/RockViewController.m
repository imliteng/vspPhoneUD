//
//  RockViewController.m
//  IphoneUTouch
//
//  Created by user on 13-4-17.
//
//

#import "RockViewController.h"

@interface RockViewController ()

@end

@implementation RockViewController

@synthesize MyRockDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        accelerometer= [UIAccelerometer sharedAccelerometer];
        accelerometer.delegate = self;
        accelerometer.updateInterval = 1.0/30.0f;
        isLoadViewFlag=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"沙锤";
    UIImageView * BGImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yao" ofType:@"jpg"inDirectory:@"newImages/"]]];
    [BGImage setFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:BGImage];
    [BGImage release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"321321321321321");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    isLoadViewFlag=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    isLoadViewFlag=NO;
}


-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //    NSString *str = [NSString stringWithFormat:@"x:%g\ty:%g\tz:%g",acceleration.x,acceleration.y,acceleration.z];
    //    NSLog(@"%@",str);
    
    // 检测摇动, 1.5为轻摇，2.0为重摇
    //    if (fabsf(acceleration.x)>1.8||
    //        fabsf(acceleration.y)>1.8||
    //        fabsf(acceleration.z>1.8)) {
    //        NSLog(@"你摇动我了~");
    //    }
    static NSInteger shakeCount = 0;
    static NSDate *shakeStart;
    NSDate *now = [[NSDate alloc]init];
    NSDate *checkDate = [[NSDate alloc]initWithTimeInterval:1.5f sinceDate:shakeStart];
    if ([now compare:checkDate] == NSOrderedDescending || shakeStart == nil) {
        shakeCount = 0;
        [shakeStart release];
        shakeStart = [[NSDate alloc]init];
    }
    [now release];
    [checkDate release];
    
    if (fabsf(acceleration.x)>1.7||
        fabsf(acceleration.y)>1.7||
        fabsf(acceleration.z)>1.7) {
        shakeCount ++;
        if (shakeCount >4&&isLoadViewFlag) {
            [self rockDoding];
            shakeCount = 0;
            [shakeStart release];
            shakeStart = [[NSDate alloc]init];
        }
    }
}

-(void)rockDoding
{
     NSLog(@"你摇动我了~");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.MyRockDelegate onHammerMessage];
}

@end
