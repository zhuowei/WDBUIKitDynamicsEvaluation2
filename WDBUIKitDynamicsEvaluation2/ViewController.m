//
//  ViewController.m
//  WDBUIKitDynamicsEvaluation2
//
//  Created by Zhuowei Zhang on 2022-09-11.
//

#import "ViewController.h"

static NSArray<NSString*>* lorems = @[@"Our mission",@"is to",@"organize the",@"world’s information",@"and make",@"it universally",@"accessible and",@"useful Respect",@"the user",@"respect the",@"opportunity respect",@"each other"];

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView* calendarEntryView;
@property (strong, nonatomic) IBOutlet UIView* floorView;
@property (strong, nonatomic) UIDynamicAnimator* dynamicAnimator;
@property (strong, nonatomic) NSArray<UIView*>* bookingsViews;
@property (strong, nonatomic) IBOutlet UIView* ball1View;
@property (strong, nonatomic) IBOutlet UIView* ball2View;
@property (strong, nonatomic) IBOutlet UIView* ball3View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray<UIView*>* bookingsViews = [NSMutableArray new];
    for (int day = 0; day < 5; day++) {
        int dayTopX = self.calendarEntryView.frame.origin.x + self.calendarEntryView.frame.size.width*day;
        static int startHours[] = {3, 1, 0, 2, 4};
        int startHour = startHours[day];
        int endHour = 18;
        for (int hour = startHour; hour < endHour; hour++) {
            UILabel* newView = [[UILabel alloc]initWithFrame:CGRectMake(dayTopX, self.calendarEntryView.frame.origin.y + (self.calendarEntryView.frame.size.height/2)*hour, (int)(self.calendarEntryView.frame.size.width * 0.8), self.calendarEntryView.frame.size.height / 2)];
            newView.text = [@" " stringByAppendingString:[lorems objectAtIndex:(day*18 + hour) % lorems.count]];
            newView.textColor = UIColor.whiteColor;
            newView.font = [UIFont systemFontOfSize:10];
            newView.backgroundColor = self.calendarEntryView.backgroundColor;
            newView.layer.cornerRadius = 4;
            newView.layer.borderColor = UIColor.whiteColor.CGColor;
            newView.layer.borderWidth = 1;
            [self.view addSubview:newView];
            [bookingsViews addObject:newView];
        }
    }
    self.calendarEntryView.hidden = true;
    self.bookingsViews = bookingsViews;
}

- (IBAction)startAction:(UIView*)view {
    view.hidden = true;
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    NSMutableArray<UIView*>* allViews = [NSMutableArray new];
    [allViews addObjectsFromArray:self.bookingsViews];
    [allViews addObject:self.ball1View];
    [allViews addObject:self.ball2View];
    [allViews addObject:self.ball3View];
    [self.dynamicAnimator addBehavior:[[UIGravityBehavior alloc]initWithItems:allViews]];
    UICollisionBehavior* collision = [[UICollisionBehavior alloc]initWithItems:allViews];
    [collision addBoundaryWithIdentifier:@"floor" forPath:[UIBezierPath bezierPathWithRect:self.floorView.frame]];
    [self.dynamicAnimator addBehavior:collision];
    UIPushBehavior* push = [[
        UIPushBehavior alloc]initWithItems:@[self.ball1View, self.ball2View, self.ball3View] mode:UIPushBehaviorModeInstantaneous];
    push.magnitude = 20;
    push.angle = M_PI;
    [self.dynamicAnimator addBehavior:push];
}

@end
