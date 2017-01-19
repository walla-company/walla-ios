//
//  WAGroupPickerView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAGroupPickerView.h"

#import "WAValues.h"
#import "WAServer.h"

@implementation WAGroupPickerView

static CGFloat VIEW_HEIGHT = 360.0; // 300 for primary
static CGFloat PRIMARY_VIEW_HEIGHT = 300.0; //VIEW_HEIGHT - secondary view height
static CGFloat VIEW_WIDTH = 320.0;

# pragma mark - Initialization

- (void)initialize:(NSString *)title {
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT-60.0)];
    self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-50.0, VIEW_WIDTH, 40.0)];
    
    self.primaryView.backgroundColor = [UIColor whiteColor];
    self.primaryView.layer.cornerRadius = 15.0;
    
    self.secondaryView.backgroundColor = [UIColor whiteColor];
    self.secondaryView.layer.cornerRadius = 15.0;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, VIEW_WIDTH, 25)];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIView *separaterView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, VIEW_WIDTH, 0.5)];
    separaterView.backgroundColor = [UIColor lightGrayColor];
    
    self.groupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, VIEW_WIDTH, PRIMARY_VIEW_HEIGHT-60) style:UITableViewStylePlain];
    
    self.groupsTableView.showsVerticalScrollIndicator = false;
    
    self.groupsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.groupsTableView registerNib:[UINib nibWithNibName:@"WAGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    
    self.groupsTableView.rowHeight = UITableViewAutomaticDimension;
    self.groupsTableView.estimatedRowHeight = 44.0;
    
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.frame = CGRectMake(0.0, 10.0, VIEW_WIDTH, 20.0);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.primaryView];
    [self addSubview:self.secondaryView];
    
    [self.primaryView addSubview:self.titleLabel];
    [self.primaryView addSubview:separaterView];
    [self.primaryView addSubview:self.groupsTableView];
    [self.primaryView addSubview:self.doneButton];
    
    [self.secondaryView addSubview:self.doneButton];
    
}

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title selectedGroups:(NSArray *)selectedGroups userGroupIDs:(NSArray*) userGroupIDs canSelectMultipleGroups:(BOOL)canSelectMultipleGroups {
    
    self = [super initWithFrame:CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT)];
    
    self.selectedGroups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *group in selectedGroups) {
        [self.selectedGroups addObject:group[@"group_id"]];
    }
    
    self.userGroupIDs = userGroupIDs;
    self.canSelectMultipleGroups = canSelectMultipleGroups;
    
    if (self) {
        [self initialize:title];
    }
    
    return self;
    
}

- (void)animateUp:(CGRect)frame {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height-VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:nil];
}

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:100.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:^(BOOL finished){
                         completionBlock();
                     }];
}

# pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.userGroupIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    
    NSString *groupID = [self.userGroupIDs objectAtIndex:indexPath.row];
    
    NSDictionary *group = [self.groupsDictionary objectForKey:groupID];
    
    cell.groupTagView.layer.cornerRadius = 8.0;
    cell.groupTagView.clipsToBounds = false;
    
    if (group) {
        
        cell.groupTagView.backgroundColor = [WAValues colorFromHexString:group[@"color"]];
        cell.groupTagViewLabel.text = group[@"short_name"];
        
        cell.groupNameLabel.text = group[@"name"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.selectedGroups containsObject:groupID]) {
            cell.backgroundColor = [WAValues selectedCellColor];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else {
        
        cell.groupTagView.backgroundColor = [UIColor whiteColor];
        cell.groupTagViewLabel.text = @"";
        cell.groupNameLabel.text = @"";
        cell.backgroundColor = [UIColor whiteColor];
        
        [self.groupsDictionary setObject:@{@"name": @"", @"short_name": @"", @"color": @"#ffffff", @"group_id": groupID} forKey:groupID];
        [WAServer getGroupBasicInfoWithID:groupID completion:^(NSDictionary *group) {
            [self.groupsDictionary setObject:group forKey:groupID];
            [self.groupsTableView reloadData];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *groupID = [self.userGroupIDs objectAtIndex:indexPath.row];
    
    if (self.canSelectMultipleGroups) {
        if (![self.selectedGroups containsObject:groupID]){
            [self.selectedGroups addObject:groupID];
        }
        else {
            [self.selectedGroups removeObject:groupID];
        }
    }
    else {
        if ([self.selectedGroups containsObject:groupID]){
            [self.selectedGroups removeAllObjects];
        }
        else {
            [self.selectedGroups removeAllObjects];
            [self.selectedGroups addObject:groupID];
        }
    }
    
    [self.groupsTableView reloadData];
    
    NSMutableArray *selectedGroupsInfo = [[NSMutableArray alloc] init];
    
    for (NSString *groupID in self.selectedGroups) {
        NSDictionary *group = [self.groupsDictionary objectForKey:groupID];
        [selectedGroupsInfo addObject:group];
    }
    
    [self.delegate groupsChanged:selectedGroupsInfo];
}

# pragma mark - Delgate

- (void)doneButtonPressed {
    
    [self.delegate doneButtonPressed];
}

@end
