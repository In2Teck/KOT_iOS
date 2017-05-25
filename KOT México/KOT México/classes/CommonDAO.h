//
//  CommonDAO.h
//  Aula Mobile
//
//  Created by Gilberto Julián de la Orta Hernández on 08/10/11.
//  Copyright 2011 Naranya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CommonDAO : NSObject{
    NSString *databaseName;
    NSString *databasePath;
    //Data Base Source
    sqlite3      *dataBase;
    sqlite3_stmt *compiledStatement;
}

-(void) initDataBaseSource;

-(void) checkAndCreateDatabase;

-(void) insert:(NSString *)sql;

-(void) update:(NSString *)sql;

-(void) delete:(NSString *)sql;

-(NSMutableArray *) select:(NSString *)sql keys:(NSArray *)k;

-(void) clossResource;

@end
