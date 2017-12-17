#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>
#include <stdarg.h>
#include <errno.h>

#define QUERY_SIZE 256

#define BUFFER_SIZE 80


static void error_fatal (char *format, ...)
{
  va_list arguments;
  va_start (arguments, format);
  vfprintf (stderr, format, arguments);
  va_end (arguments);
  exit (EXIT_FAILURE);
}

int main(int argc, char** argv) {
    MYSQL *connection;
    MYSQL_RES *result;
    MYSQL_ROW row;
    MYSQL_FIELD *field;
    
    int i;
    int option;
    int idg;
    
    char query[QUERY_SIZE];
 //   char buffer[BUFFER_SIZE];

    int id;
    char name[45];
    char sname[45];
    char tel[45];
    char email[45];

    char ans[45];

    connection = mysql_init(NULL);

    if(mysql_real_connect(connection, "localhost","root","","mydb",0, NULL,0) == NULL) {
        error_fatal ("Greska u konekciji. %s\n", mysql_error (connection));
    }

    while(1) {
          fprintf(stdout,"Odaberite sta zelite da uradite:\n");
          fprintf(stdout,"1 - informacije o svim ucenicima koji polazu prijemni ispit;\n");
          fprintf(stdout,"2 - informacije o svim nastavnicima koji kontrolisu polaganje;\n");
          fprintf(stdout,"3 - raspored ucenika po grupama;\n");
          fprintf(stdout,"4 - unos novih ucenika;\n");
          fprintf(stdout,"5 - izmena nekih podataka o ucenicima;\n");
          fprintf(stdout,"6 - izlazak iz aplikacije\n");
          
          fscanf(stdin, "%d", &option);
          
          if (option == 1) {
              sprintf(query, "SELECT ime AS `Ime`, prezime AS `Prezime`, br_tel AS `Telefon`, email AS `e-mail` FROM Ucenik");
              if (mysql_query (connection, query) != 0) {
                  error_fatal ("Greska u upitu %s\n", mysql_error (connection));
              }
              result = mysql_use_result (connection);
              field = mysql_fetch_field (result);
              for (i = 0; i < mysql_field_count(connection); i++){
                  printf("%-20s", field[i].name);
                  
            }
            printf("\n");
            
            while ((row = mysql_fetch_row (result)) != 0){
                for(i = 0; i < mysql_field_count(connection); i++){
                    printf ("%-20s", row[i]);
                }
                printf ("\n");
                
            }
            mysql_free_result (result);
              
        } else if (option == 2) {
            sprintf(query, "SELECT ime AS `Ime`, prezime AS `Prezime`, br_tel AS `Telefon`, email AS `e-mail` FROM Nastavnik");
              if (mysql_query (connection, query) != 0) {
                  error_fatal ("Greska u upitu %s\n", mysql_error (connection));
              }
              result = mysql_use_result (connection);
              field = mysql_fetch_field (result);
              for (i = 0; i < mysql_field_count(connection); i++){
                  printf("%-20s", field[i].name);
                  
            }
            printf("\n");
            
            while ((row = mysql_fetch_row (result)) != 0){
                for(i = 0; i < mysql_field_count(connection); i++){
                    printf ("%-20s", row[i]);
                }
                printf ("\n");
                
            }
            mysql_free_result (result);
        } else if (option == 3) {
            fprintf(stdout,"Unesite grupu koju zelite da vidite:\n");
            fscanf(stdin,"%d",&idg);
            
            sprintf(query, "SELECT ime AS `Ime`, prezime AS `Prezime` FROM Ucenik WHERE %d=`Grupa_idGrupe`",idg);
              if (mysql_query (connection, query) != 0) {
                  error_fatal ("Greska u upitu %s\n", mysql_error (connection));
              }
              result = mysql_use_result (connection);
              field = mysql_fetch_field (result);
              for (i = 0; i < mysql_field_count(connection); i++){
                  printf("%-20s", field[i].name);
                  
            }
            printf("\n");
            
            while ((row = mysql_fetch_row (result)) != 0){
                for(i = 0; i < mysql_field_count(connection); i++){
                    printf ("%-20s", row[i]);
                }
                printf ("\n");
                
            }
            mysql_free_result (result);
            
        } else if (option == 4) {
            fprintf(stdout,"unesite novog ucenika:\n");
            fprintf(stdout,"Unesite jmbg, ime, prezime, kontakt telefon, email i grupu:\n");
            fscanf(stdin,"%d%s%s%s%s%d", &id, name, sname, tel, email, &idg);
            
            sprintf(query, "INSERT INTO Ucenik VALUES('%d','%s','%s','%s','%s', %d);", id, name, sname, tel, email, idg);

                if (mysql_query (connection, query) != 0) {
                    error_fatal ("Greska u upitu %s\n", mysql_error (connection));
                }
                
                fprintf(stdout,"Ucenik uspesno upisan!\n");                

        } else if (option == 5) {
            fprintf(stdout,"Unesite jmbg ucenika kojeg zelite da izmenite:\n");
            fscanf(stdin,"%d", &id);
            fprintf(stdout,"Zelite da izmenite: ime, prezime ili telefon?\n");
            fscanf(stdin,"%s",ans);
            
            if (!strcmp(ans,"ime")) {
                fprintf(stdout,"Unesite ime:\n");
                fscanf(stdin,"%s",name);
                sprintf(query, "UPDATE Ucenik SET ime='%s' WHERE Osoba_jmbg='%d'",name, id);
            }
            else if (!strcmp(ans,"prezime")) {
                fprintf(stdout,"Unesite prezime:\n");
                fscanf(stdin,"%s",sname);
                sprintf(query, "UPDATE Ucenik SET prezime='%s' WHERE Osoba_jmbg='%d'", sname, id);
            } else if (!strcmp(ans,"telefon")) {
                fprintf(stdout,"Unesite telefon:\n");
                fscanf(stdin,"%s", tel);
                sprintf(query, "UPDATE Ucenik SET br_tel = '%s' WHERE Osoba_jmbg='%d'", tel, id);
            }
            if (mysql_query (connection, query) != 0) {
                error_fatal ("Greska u upitu %s\n", mysql_error (connection));
            }
                
            fprintf(stdout,"Podaci uspesno izmenjeni!\n");
            
        }  else if (option == 6) {
            fprintf(stdout,"Bye!\n");
            exit(EXIT_SUCCESS);
        }
    }
    
    mysql_close (connection);

    return 0;
}