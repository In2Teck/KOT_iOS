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
#import "MiMetodoCellViewController.h"

@implementation MiMetodoKOTViewController
@synthesize myTableView;
@synthesize intensivo;
@synthesize progresivo;
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
    
    //[self.myTableView registerNib:[UINib nibWithNibName:@"MiMetodoCellViewController" bundle:nil] forCellReuseIdentifier:@"MiMetodoCellViewController"];
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
    /*if(indexPath.section <2)
        return 70.0;
    if(indexPath.section ==2)
        return 45.0;
    return 100.0;*/
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([intensivo count] >0 && [progresivo count] >0)
        return 4;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *arrayData;
    
    if(isIntensivo)
        arrayData = intensivo;
    else
        arrayData = progresivo;
    
    if(section == 0)
        return [[arrayData objectForKey:@"desayuno"] count];
    if(section == 1)
        return [[arrayData objectForKey:@"comida"] count];
    if(section == 2)
        return [[arrayData objectForKey:@"colacion"] count];
    if(section == 3)
        return [[arrayData objectForKey:@"cena"] count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    NSString *postfix;
    
    if (isIntensivo){
        postfix = @"intensivo";
    } else {
        postfix = @"progresivo";
    }
    
    NSMutableArray *defaultsArray;
    NSDictionary *data;
    //static NSString *CellIdentifier = @"MiMetodoCellViewController";
    
    //MiMetodoCellViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //[self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil]
    //     forCellReuseIdentifier:@"Cell"];
    
    //if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MiMetodoCellViewController" owner:self options:nil];
        MiMetodoCellViewController *cell = [nib objectAtIndex:0];
    //}
    
    if(indexPath.section == 0){
        
        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"cereal"]){
            text = @"cereal";            
            [cell.buttonLabel addTarget:self action:@selector(cerealAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"proteinas_vegetales"]){
            text = @"proteína vegetal";
            [cell.buttonLabel addTarget:self action:@selector(proteinaVegetalAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"frutas"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"lacteos"]){
            text = @"lácteo";
            [cell.buttonLabel addTarget:self action:@selector(lacteosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"producto KOT";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
      
    } else if (indexPath.section == 1){
        
        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"cereal"]){
            text = @"cereal";
            [cell.buttonLabel addTarget:self action:@selector(cerealAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"proteinas"]){
            text = @"proteína animal";
            [cell.buttonLabel addTarget:self action:@selector(proteinaAnimalAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_crudo"]){
            text = @"vegetales crudos";
            [cell.buttonLabel addTarget:self action:@selector(v_crudosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_cocidas"]){
            text = @"vegetales cocidos";
            [cell.buttonLabel addTarget:self action:@selector(v_cocidosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"cucharadas_aceite"]){
            text = @"cucharadas de aceite";
            [cell.buttonLabel addTarget:self action:@selector(aceiteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
        
    } else if (indexPath.section == 2){
        
        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"fruta"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"productos KOT";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
        
    }else if (indexPath.section == 3){
        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"cereal"]){
            text = @"cereal";
            [cell.buttonLabel addTarget:self action:@selector(cerealAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"proteinas"]){
            text = @"proteína animal";
            [cell.buttonLabel addTarget:self action:@selector(proteinaAnimalAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_crudo"]){
            text = @"vegetales crudos";
            [cell.buttonLabel addTarget:self action:@selector(v_crudosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_cocidas"]){
            text = @"vegetales cocidos";
            [cell.buttonLabel addTarget:self action:@selector(v_cocidosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"frutas"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"lacteos"]){
            text = @"lácteo";
            [cell.buttonLabel addTarget:self action:@selector(lacteosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"producto KOT";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
    }
    
    [cell.checkSwitch addTarget:self action:@selector(changeOnOff:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(IBAction)changeSection:(id)sender{
    LoadingView *myLoadingView = [LoadingView loadingViewInView:self.navigationController.view];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isIntensivo = (isIntensivo?NO:YES);
    if(isIntensivo)
        [Flurry logEvent:@"My Método KOT Intensivo" timed:YES];
    else
        [Flurry logEvent:@"My Método KOT Progresivo" timed:YES];
    /* TODO REPOBLAR INTENSIVO Y PROGRESIVO*/
    
    NSArray *keys =  [[NSArray alloc] initWithObjects:@"desayuno", @"comida", @"colacion", @"cena", nil];
    NSArray *intensivoArray = [[NSArray alloc] initWithObjects:[defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", @"intensivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", @"intensivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion", @"intensivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"intensivo"]], nil];
    
    NSArray *progresivoArray = [[NSArray alloc] initWithObjects:[defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"progresivo"]], nil];
    
    intensivo = [[NSMutableDictionary alloc] initWithObjects:intensivoArray forKeys:keys];
    progresivo = [[NSMutableDictionary alloc] initWithObjects:progresivoArray forKeys:keys];
    
    //[defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"progresivo"]]
    
    [myTableView reloadData];
    [myLoadingView performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}

-(IBAction)changeOnOff:(UISwitch*)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *postfix;
    
    if (isIntensivo){
        postfix = @"intensivo";
    } else {
        postfix = @"progresivo";
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    int index = sender.tag;
    if (sender.tag >= 30){ // cena
        index = index - 30;
        
        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:defaultsArray forKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        
    } else if (sender.tag >= 20) { // colacion
        index = index - 20;
        
        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:defaultsArray forKey:[NSString stringWithFormat:@"%@_%@", @"colacion", postfix]];
        
    } else if (sender.tag >= 10) { // comida
        index = index - 10;
        
        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:defaultsArray forKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
    } else { // desayuno
        
        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:defaultsArray forKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
    }
    
    [defaults synchronize];
}

-(IBAction)cerealAction:(id)sender{
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
-(IBAction)proteinaAction:(id)sender{
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

-(IBAction)proteinaAnimalAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:7];
    
    [self.navigationController pushViewController:ad animated:YES];
    [ad release];
    ad = nil;
    [sqlite release];
}

-(IBAction)proteinaVegetalAction:(id)sender{
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

-(IBAction)v_crudosAction:(id)sender{
    AlimentoDetailViewController *ad = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    [ad setType:5];
    NSMutableArray *alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    ad.alimentoDetail = [alimentosList objectAtIndex:10];
    
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
    
    ad.alimentoDetail = [alimentosList objectAtIndex:9];
    
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

    [ad setAlimentoDetail:[alimentosList objectAtIndex:3]];
    
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
    
    ad.alimentoDetail = [alimentosList objectAtIndex:4];
    
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
- (void)dealloc {
    [super dealloc];
}

@end
