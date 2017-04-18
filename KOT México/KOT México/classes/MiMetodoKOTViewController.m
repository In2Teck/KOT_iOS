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
    self.title = @"Mi Método Zélé";
    isIntensivo = YES;
    [titleSemanas setText:[NSString stringWithFormat:@"Llevas %@ semanas en el método Zélé.", semanasUsuario]];
    
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
        return @"Colación 1";
    if(section == 2)
        return @"Comida";
    if(section == 3)
        return @"Colación 2";
    if(section == 4)
        return @"Cena";
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if(indexPath.section <2)
        return 70.0;
    if(indexPath.section ==2)
        return 45.0;
    return 100.0;*/
    return 35.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([intensivo count] >0 && [progresivo count] >0)
        return 5    ;
    
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
        return [[arrayData objectForKey:@"colacion_1"] count];
    if(section == 2)
        return [[arrayData objectForKey:@"comida"] count];
    if(section == 3)
        return [[arrayData objectForKey:@"colacion_2"] count];
    if(section == 4)
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
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
        
//        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        
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
            text = @"producto Zélé";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.buttonLabel setTintColor:[UIColor blackColor]];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
     
    } else if (indexPath.section == 1){
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
        
//        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"frutas"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"producto Zélé";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"proteinas_vegetales"]){
            text = @"proteína vegetal";
            [cell.buttonLabel addTarget:self action:@selector(proteinaVegetalAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"cereal"]){
            text = @"cereal";
            [cell.buttonLabel addTarget:self action:@selector(cerealAction::) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.buttonLabel setTintColor:[UIColor blackColor]];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
        
    } else if (indexPath.section == 2){
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];

//        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        
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
            text = @"vegetal crudo";
            [cell.buttonLabel addTarget:self action:@selector(v_crudosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_cocidas"]){
            text = @"vegetal cocido";
            [cell.buttonLabel addTarget:self action:@selector(v_cocidosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"cucharadas_aceite"]){
            text = @"2 cucharadas de aceite";
            [cell.buttonLabel addTarget:self action:@selector(aceiteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.buttonLabel setTintColor:[UIColor blackColor]];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
        
    } else if (indexPath.section == 3){
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
        
//        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", postfix]];
        
        data = [defaultsArray objectAtIndex:indexPath.row];
        
        NSArray *internal_keys = [data allKeys];
        NSArray *components = [[data objectForKey:internal_keys[0]] componentsSeparatedByString:@"_"];
        BOOL *on = [[components objectAtIndex:0] boolValue];
        int progressive_index =  [[NSString stringWithFormat:@"%i%@", indexPath.section, [components objectAtIndex:1]] integerValue];
        
        NSString *text = internal_keys[0];
        
        if ([text isEqualToString:@"frutas"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"producto Zélé";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"proteinas_vegetales"]){
            text = @"proteína vegetal";
            [cell.buttonLabel addTarget:self action:@selector(proteinaVegetalAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"cereal"]){
            text = @"cereal";
            [cell.buttonLabel addTarget:self action:@selector(cerealAction::) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.buttonLabel setTintColor:[UIColor blackColor]];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
        
    } else if (indexPath.section == 4){
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        
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
            text = @"vegetal crudo";
            [cell.buttonLabel addTarget:self action:@selector(v_crudosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"vegetales_cocidas"]){
            text = @"vegetal cocido";
            [cell.buttonLabel addTarget:self action:@selector(v_cocidosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"frutas"]){
            text = @"fruta";
            [cell.buttonLabel addTarget:self action:@selector(frutasAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"lacteos"]){
            text = @"lácteo";
            [cell.buttonLabel addTarget:self action:@selector(lacteosAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"productosKot"]){
            text = @"producto Zélé";
            [cell.buttonLabel addTarget:self action:@selector(productosKotAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([text isEqualToString:@"cucharadas_aceite"]){
            text = @"2 cucharadas de aceite";
            [cell.buttonLabel addTarget:self action:@selector(aceiteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.buttonLabel setTitle:text forState:UIControlStateNormal];
        [cell.buttonLabel setTintColor:[UIColor blackColor]];
        [cell.checkSwitch setOn:on];
        [cell.checkSwitch setTag:progressive_index];
    }

//    cell.checkSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
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
    /* TODO REPOBLAR INTENSIVO Y PROGRESIVO*/
    
    NSArray *keys =  [[NSArray alloc] initWithObjects:@"desayuno", @"colacion_1", @"comida", @"colacion_2", @"cena", nil];
    
    NSData *encodedDataDesayunoIntensivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", @"intensivo"]];
    NSMutableArray *desayunoIntensivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataDesayunoIntensivo];
    
    NSData *encodedDataColacion1Intensivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", @"intensivo"]];
    NSMutableArray *colacion1IntensivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataColacion1Intensivo];
    
    NSData *encodedDataComidaIntensivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"comida", @"intensivo"]];
    NSMutableArray *comidaIntensivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataComidaIntensivo];
    
    NSData *encodedDataColacion2Intensivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", @"intensivo"]];
    NSMutableArray *colacion2IntensivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataColacion2Intensivo];
    
    NSData *encodedDataCenaIntensivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"intensivo"]];
    NSMutableArray *cenaIntensivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataComidaIntensivo];
    
    NSArray *intensivoArray = [[NSArray alloc] initWithObjects:desayunoIntensivoArray, colacion1IntensivoArray, comidaIntensivoArray, colacion2IntensivoArray, cenaIntensivoArray, nil];
 
    NSData *encodedDataDesayunoProgresivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", @"progresivo"]];
    NSMutableArray *desayunoProgresivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataDesayunoProgresivo];
    
    NSData *encodedDataColacion1Progresivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", @"progresivo"]];
    NSMutableArray *colacion1ProgresivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataColacion1Progresivo];
    
    NSData *encodedDataComidaProgresivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"comida", @"progresivo"]];
    NSMutableArray *comidaProgresivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataComidaProgresivo];
    
    NSData *encodedDataColacion2Progresivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", @"progresivo"]];
    NSMutableArray *colacion2ProgresivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataColacion2Progresivo];
    
    NSData *encodedDataCenaProgresivo = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"progresivo"]];
    NSMutableArray *cenaProgresivoArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedDataComidaProgresivo];
    
    NSArray *progresivoArray = [[NSArray alloc] initWithObjects:desayunoProgresivoArray, colacion1ProgresivoArray, comidaProgresivoArray, colacion2ProgresivoArray, cenaProgresivoArray, nil];
    
//    NSArray *progresivoArray = [[NSArray alloc] initWithObjects:[defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", @"progresivo"]],  [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", @"progresivo"]], [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", @"progresivo"]], nil];
    
    intensivo = [[NSMutableDictionary alloc] initWithObjects:intensivoArray forKeys:keys];
    progresivo = [[NSMutableDictionary alloc] initWithObjects:progresivoArray forKeys:keys];
    
    [myTableView reloadData];
    [myLoadingView performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}

-(IBAction)changeOnOff:(UISwitch*)sender{
    
    NSLog(@"sender.tag %d", sender.tag);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *postfix;
    
    if (isIntensivo){
        postfix = @"intensivo";
    } else {
        postfix = @"progresivo";
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    int index = sender.tag;
    if (sender.tag >= 40){ // cena
        index = index - 40;
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:defaultsArray] forKey:[NSString stringWithFormat:@"%@_%@", @"cena", postfix]];
        
    } else if (sender.tag >= 30) { // colacion_2
        index = index - 30;
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];

//        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:defaultsArray] forKey:[NSString stringWithFormat:@"%@_%@", @"colacion_2", postfix]];
        
    } else if (sender.tag >= 20) { // comida
        index = index - 20;
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:defaultsArray] forKey:[NSString stringWithFormat:@"%@_%@", @"comida", postfix]];
    }else if (sender.tag >= 10) { // colacion_1
        index = index - 10;
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", postfix]];
        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:defaultsArray] forKey:[NSString stringWithFormat:@"%@_%@", @"colacion_1", postfix]];
        
    } else { // desayuno
//        NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        
        NSData *encodedData = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
        NSMutableArray *defaultsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];

        NSArray *internal_keys = [[defaultsArray objectAtIndex:index] allKeys];
        
        NSString *value;
        if(sender.on == 1){
            value = [NSString stringWithFormat:@"YES_%i", index];
        }else{
            value = [NSString stringWithFormat:@"NO_%i", index];
        }
        NSLog(@"Internal Keys: %@", internal_keys[0]);
        
        [dict setObject:value forKey:internal_keys[0]];
        [defaultsArray replaceObjectAtIndex:index withObject:dict];

        NSLog(@"ARRAY %@", [NSArray arrayWithObjects: @{@"proteinas_vegetales": @"YES_1"}, @{@"proteina_vegetale": @"YES_1"}, nil]);
        
        NSLog(@"Defaults Array: %@", defaultsArray);
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:defaultsArray] forKey:[NSString stringWithFormat:@"%@_%@", @"desayuno", postfix]];
    }
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
