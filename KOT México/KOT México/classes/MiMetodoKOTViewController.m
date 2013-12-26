//
//  MiMetodoKOTViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 07/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "MiMetodoKOTViewController.h"
#import "../../JSON/JSON.h"
#import "LoadingView.h"
#import "AlimentoDetailViewController.h"
#import "CommonDAO.h"
#import "ProductosViewController.h"
#import "Flurry.h"

@implementation MiMetodoKOTViewController
@synthesize myTableView;
@synthesize intensivo;
@synthesize progresivo;
@synthesize desayuno,comida,colacion,cena;
@synthesize cerealD, proteinasD, vegetalesD, frutasD, lacteosD, productosKotD, cerealC, proteinasC, v_crudoC, v_cocidoC, aceiteC, frutaCol, productosKotCol, cerealesCe, proteinaCe, v_crudoCe, v_cocidoCe, frutaCe, lacteosCe,productosKotCe,aceiteCe;
@synthesize semanasUsuario, titleSemanas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Mi Método KOT";
    isIntensivo = YES;
    [titleSemanas setText:[NSString stringWithFormat:@"Llevas %@ semanas en el método KOT.", semanasUsuario]];
    if(isIntensivo)
        [Flurry logEvent:@"My Método KOT Intensivo" timed:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/************************************************************************/
/************************************************************************/
/************************** TABLE DELEGATE ******************************/
/************************************************************************/
/************************************************************************/

#pragma mark - Table view data source
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Desayuno";
    if(section == 1)
        return @"Comida";
    if(section == 2)
        return @"Colación";
    if(section == 3)
        return @"Cena";
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section <2)
        return 70.0;
    if(indexPath.section ==2)
        return 45.0;
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([intensivo count] >0 && [progresivo count] >0)
        return 4;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([intensivo count] >0 && [progresivo count] >0)
        return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *arrayData;
    
    if(isIntensivo)
        arrayData = intensivo;
    else
        arrayData = progresivo;
    
    NSDictionary *data;
    
    
    if(indexPath.section == 0){
        data = [[[arrayData objectForKey:@"desayuno"]JSONRepresentation]JSONValue];
        [cerealD setText:[data objectForKey:@"cereal"]];
        [proteinasD setText:[data objectForKey:@"proteinas_vegetales"]];
//        [vegetalesD setText:[data objectForKey:@"vegetales"]];
        [frutasD setText:[data objectForKey:@"frutas"]];
        [lacteosD setText:[data objectForKey:@"lacteos"]];
        [productosKotD setText:[data objectForKey:@"productosKot"]];
        
        return desayuno;
    }
    if(indexPath.section == 1){
        data = [[[arrayData objectForKey:@"comida"]JSONRepresentation]JSONValue];
        [cerealC setText:[data objectForKey:@"cereal"]];
        [proteinasC setText:[data objectForKey:@"proteinas"]];
        [v_crudoC setText:[data objectForKey:@"vegetales_crudo"]];
        [v_cocidoC setText:[data objectForKey:@"cereal"]];
        [aceiteC setText:[data objectForKey:@"cucharadas_aceite"]];
        
        
        return comida;
    }
    
    if(indexPath.section == 2){
        data = [[[arrayData objectForKey:@"colacion"]JSONRepresentation]JSONValue];
        
        if(isIntensivo)
            [frutaCol setText:[data objectForKey:@"fruta"]];
        else
            [frutaCol setText:[data objectForKey:@"frutas"]];
        
        [productosKotCol setText:[data objectForKey:@"productosKot"]];
        
        return colacion;
    }else{
        data = [[[arrayData objectForKey:@"cena"]JSONRepresentation]JSONValue];
        [cerealesCe setText:[data objectForKey:@"cereal"]];
        [proteinaCe setText:[data objectForKey:@"proteinas"]];
        [v_crudoCe setText:[data objectForKey:@"vegetales_crudo"]];
        [v_cocidoCe setText:[data objectForKey:@"vegetales_cocidas"]];
        [frutaCe setText:[data objectForKey:@"frutas"]];
        [lacteosCe setText:[data objectForKey:@"lacteos"]];
        [productosKotCe setText:[data objectForKey:@"productosKot"]];
        [aceiteCe setText:[data objectForKey:@"cereal"]];
        [productosKotCe setText:[data objectForKey:@"productosKot"]];
        
        
        return cena;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tax   bleView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(IBAction)changeSection:(id)sender{
    LoadingView *myLoadingView = [LoadingView loadingViewInView:self.navigationController.view];
    isIntensivo = (isIntensivo?NO:YES);
    if(isIntensivo)
        [Flurry logEvent:@"My Método KOT Intensivo" timed:YES];
    else
        [Flurry logEvent:@"My Método KOT Progresivo" timed:YES];
    [myTableView reloadData];
    [myLoadingView performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}

-(IBAction)cerealAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:2];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;

}
-(IBAction)proteinaAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:6];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)vegetalesAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:7];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)v_crudosAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:9];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)v_cocidosAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:8];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)frutasAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:4];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)lacteosAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:5];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)aceiteAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:0];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
    sqlite = nil;
}
-(IBAction)productosKotAction:(id)sender{
    ProductosViewController *pvc = [[ProductosViewController alloc] initWithNibName:@"ProductosViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
    [pvc release];
    pvc = nil;
}
@end
