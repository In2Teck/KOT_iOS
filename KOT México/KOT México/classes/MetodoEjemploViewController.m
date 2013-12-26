//
//  MetodoEjemploViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "MetodoEjemploViewController.h"
#import "DTCustomColoredAccessory.h"
#import "AlimentoDetailViewController.h"
#import "ProductosViewController.h"
#import "Flurry.h"


@implementation MetodoEjemploViewController
@synthesize miMetodo;
@synthesize desayuno,comida,colacion,cena;
@synthesize cerealD, proteinasD, vegetalesD, frutasD, lacteosD, productosKotD, cerealC, proteinasC, v_crudoC, v_cocidoC, aceiteC, frutaCol, productosKotCol, cerealesCe, proteinaCe, v_crudoCe, v_cocidoCe, frutaCe, lacteosCe,productosKotCe,aceiteCe;
@synthesize type;
@synthesize myTableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    self.title = @"Ejemplo método KOT";
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    switch (self.type) {
        case 1:
            [Flurry logEvent:@"Método Mujer Intensiva" timed:YES];
            break;
        case 2:
            [Flurry logEvent:@"Método Mujer Progresiva" timed:YES];
            break;
        case 3:
            [Flurry logEvent:@"Método Hombre Intensivo" timed:YES];
            break;
        case 4:
            [Flurry logEvent:@"Método Hombre Progresivo" timed:YES];
            break;
        default:
            break;
    }
    
    [self changeMethod:self.type];
    
    [super viewDidLoad];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 1)
        return 80;
    
    if(indexPath.section == 4)
        return 77.0;
    
    if(indexPath.section == 3)
        return 44.0;
    
    if(indexPath.section == 2 ||indexPath.section == 1)
        return 70.0;
    
    return 44.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section >0){
        if(section == 1)
            return @"Desayuno";
        if (section== 2) 
            return @"Comida";
        if(section == 3)
            return @"Colación";
        if(section == 4)
            return @"Cena";
    }else
        return @"";
}


- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section==0) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section]){
        if ([expandedSections containsIndex:section]){
            return 2; // return rows when expanded
        }
        return 1; // only top row showing
    }
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section]){

        if (!indexPath.row){
            // first row
            cell.textLabel.text = @"Nota Importante"; // only top row showing
            if ([expandedSections containsIndex:indexPath.section]){
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor blackColor] type:DTCustomColoredAccessoryTypeUp];
            }else{
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor blackColor] type:DTCustomColoredAccessoryTypeDown];
            }
            
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra amarilla.png"]]];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.accessoryView setBackgroundColor:[UIColor clearColor]];
        }else{
            // all other rows
            cell.textLabel.text = [[miMetodo objectAtIndex:0]objectAtIndex:0];
            [cell.textLabel setNumberOfLines:10];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            cell.accessoryView = nil;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
//        cell.accessoryView = nil;
//        cell.textLabel.text =[[miMetodo objectAtIndex:0]objectAtIndex:indexPath.section];
//        [cell.textLabel setNumberOfLines:2];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
    
    if(indexPath.section == 1)
        return desayuno;
    if (indexPath.section== 2) 
        return comida;
    if(indexPath.section == 3)
        return colacion;
    if(indexPath.section == 4)
        return cena;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // only first row toggles exapand/collapse
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i 
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray 
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray 
                                 withRowAnimation:UITableViewRowAnimationTop];
                cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
        }
    }
}
-(void)changeMethod:(NSInteger)type{
    switch (type) {
        case 1:
            /********** DESAYUNO ********/
            [cerealD setText:@"1"];
            [productosKotD setText:@"1"];
            [lacteosD setText:@"1"];
            [frutasD setText:@"1"];
            [proteinasD setText:@"0"];
            
            
            /********** COMIDA ********/
            [proteinasC setText:@"1"];
            [cerealC setText:@"1"];
            [v_crudoC setText:@"1"];
            [v_cocidoC setText:@"1"];
            [aceiteC setText:@"2"];

            
            /********** COLACION ********/
            [frutaCol setText:@"1"];
            [productosKotCol setText:@"1"];
            
            /********** CENA ********/
            [productosKotCe setText:@"2"];
            [v_cocidoCe setText:@"1"];
            [v_crudoCe setText:@"1"];
            [aceiteCe setText:@"2"];
            [proteinaCe setText:@"0"];
            [lacteosCe setText:@"0"];
            [frutaCe setText:@"0"];
            [cerealesCe setText:@"0"];
            break;
        case 2:
            /********** DESAYUNO ********/
            [cerealD setText:@"1"];
            [productosKotD setText:@"1"];
            [lacteosD setText:@"1"];
            [frutasD setText:@"1"];
            [proteinasD setText:@"0"];
            
            /********** COMIDA ********/
            [proteinasC setText:@"1"];
            [cerealC setText:@"2"];
            [v_crudoC setText:@"1"];
            [v_cocidoC setText:@"1"];
            [aceiteC setText:@"2"];
            
            /********** COLACION ********/
            [frutaCol setText:@"1"];
            [productosKotCol setText:@"1"];
            
            /********** CENA ********/
            [productosKotCe setText:@"1"];
            [v_cocidoCe setText:@"1"];
            [v_crudoCe setText:@"1"];
            [aceiteCe setText:@"2"];
            [proteinaCe setText:@"1/2"];
            [lacteosCe setText:@"0"];
            [frutaCe setText:@"0"];
            [cerealesCe setText:@"0"];
            break;
        case 3:
            /********** DESAYUNO ********/
            [cerealD setText:@"1"];
            [productosKotD setText:@"1"];
            [lacteosD setText:@"1"];
            [frutasD setText:@"1"];
            [proteinasD setText:@"1"];
            
            /********** COMIDA ********/
            [proteinasC setText:@"1"];
            [cerealC setText:@"2"];
            [v_crudoC setText:@"1"];
            [v_cocidoC setText:@"1"];
            [aceiteC setText:@"2"];
            
            /********** COLACION ********/
            [frutaCol setText:@"1"];
            [productosKotCol setText:@"1"];
            
            /********** CENA ********/
            [productosKotCe setText:@"2"];
            [v_cocidoCe setText:@"1"];
            [v_crudoCe setText:@"1"];
            [aceiteCe setText:@"2"];
            [lacteosCe setText:@"0"];
            [proteinaCe setText:@"0"];
            [cerealesCe setText:@"0"];
            [frutaCe setText:@"0"];
            break;
        case 4:
            /********** DESAYUNO ********/
            [cerealD setText:@"2"];
            [productosKotD setText:@"1"];
            [lacteosD setText:@"1"];
            [frutasD setText:@"1"];
            [proteinasD setText:@"2"];
            
            /********** COMIDA ********/
            [proteinasC setText:@"1"];
            [cerealC setText:@"3"];
            [v_crudoC setText:@"1"];
            [v_cocidoC setText:@"1"];
            [aceiteC setText:@"2"];
            
            /********** COLACION ********/
            [frutaCol setText:@"1"];
            [productosKotCol setText:@"1"];
            
            /********** CENA ********/
            [productosKotCe setText:@"1"];
            [v_cocidoCe setText:@"1"];
            [v_crudoCe setText:@"1"];
            [aceiteCe setText:@"2"];
            [proteinaCe setText:@"1"];
            [frutaCe setText:@"0"];
            [lacteosCe setText:@"0"];
            [cerealesCe setText:@"0"];
            
            break;
        default:
            break;
    }
}

/************************************************************/
/************************************************************/
/*********************** IBActions **************************/
/************************************************************/
/************************************************************/
-(IBAction)cerealAction:(id)sender{

    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    
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
    [ad setType:self.type];
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
    [ad setType:self.type];
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
    [ad setType:self.type];
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
    [ad setType:self.type];
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
