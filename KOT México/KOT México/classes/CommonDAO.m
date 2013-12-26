//
//  CommonDAO.m
//  Aula Mobile
//
//  Created by Gilberto Julián de la Orta Hernández on 08/10/11.
//  Copyright 2011 Naranya. All rights reserved.
//

#import "CommonDAO.h"

@implementation CommonDAO

///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////Synthesize local variables/////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Implementation Method ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        //Init DataBase Source
        [self initDataBaseSource];
        // Execute the "checkAndCreateDatabase" function
        [self checkAndCreateDatabase];
    }
    return self;
}

-(void)initDataBaseSource{
    databaseName = @"db_kot_v6.sql";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];

}

-(void)insert:(NSString *)sql{
    if(sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK) {
        const char *insert_stmt = [sql UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &compiledStatement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(dataBase));
        
        if (SQLITE_DONE != sqlite3_step(compiledStatement)) 
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(dataBase));

    }
    [self clossResource];
}

-(void)delete:(NSString *)sql{
    if(sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK) {
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(dataBase, insert_stmt, -1, &compiledStatement, NULL);
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
//            NSLog(@"Contact added");
        } else {
            NSLog(@"Failed to delete user session");
        }
    }
    [self clossResource];
}

-(void) update:(NSString *)sql{
    if(sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK) {
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(dataBase, insert_stmt, -1, &compiledStatement, NULL);
        if (sqlite3_step(compiledStatement) == SQLITE_DONE)
        {
            //            NSLog(@"Contact added");
        } else {
            NSLog(@"Failed to update user session");
        }
    }

    [self clossResource];
}

-(NSMutableArray *)select:(NSString *)sql keys:(NSArray *)k{
    NSMutableArray *all = [[NSMutableArray alloc]init];
    
    const char *select_stmt = [sql UTF8String];
    if(sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK) {
        
        if(sqlite3_prepare_v2(dataBase, select_stmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSMutableArray *data = [[NSMutableArray alloc]init];
                for (int i = 0; i < [k count]; i++) {
                    NSString *value;
                    if(sqlite3_column_text(compiledStatement, i)!=NULL)
                        value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)];
                    else
                        value = [[NSString alloc]initWithFormat:@""];
                    [data addObject:value];
                }
                [all addObject:data];
            }

        }else{
            NSLog(@"error sqlite_row");
            NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(dataBase));
        }
        
    }else{
        NSLog(@"error data bace acces");
    }
    
    [self clossResource];

    return all;
}

-(void)clossResource{
    if(compiledStatement){
        sqlite3_finalize(compiledStatement);
    }
    if(dataBase){
        sqlite3_close(dataBase);
    }
}
@end
