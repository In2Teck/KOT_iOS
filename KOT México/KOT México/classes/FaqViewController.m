//
//  FaqViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 11/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "FaqViewController.h"
#import "CollapsableTableView.h"

@interface FaqViewController ()

@end

@implementation FaqViewController

@synthesize myTableView, dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CollapsableTableView* collapsableTableView = (CollapsableTableView*) myTableView;
    
    for (NSDictionary *item in dataSource){
        [collapsableTableView setIsCollapsed:YES forHeaderWithTitle:[item objectForKey:@"Pregunta"]];
    }
    
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [myTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSource count];
}

+ (NSString*) titleForHeaderForSection:(int) section
{
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *item = [dataSource objectAtIndex:section];
    
    return [item objectForKey:@"Pregunta"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *item = [dataSource objectAtIndex:indexPath.section];
    UILabel *respuesta;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        respuesta = [[[UILabel alloc] initWithFrame:CGRectMake(5.0, -10.0, 300.0, 50.0)]autorelease];
        [respuesta setTag:@"Respuesta_Plano"];
        [respuesta setBackgroundColor:[UIColor clearColor]];
        [respuesta setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [respuesta setNumberOfLines:8];
        [respuesta setFont:[UIFont systemFontOfSize:12.0]];
        [respuesta setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:respuesta];
    }else{
        respuesta = (UILabel*)[cell viewWithTag:@"Respuesta_Plano"];
    }
    
	// Configure the cell.
    [respuesta setText:[item objectForKey:@"Respuesta_Plano"]];
    
    return cell;
}

@end
