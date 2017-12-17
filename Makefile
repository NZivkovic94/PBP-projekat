DIR = mydb
PROGRAM = app.out
SRC = app.c
FLAGS = -g -Wall `mysql_config --cflags --libs`

.PHONY: all baza trigger insert clean app

all: baza trigger insert $(PROGRAM) 

$(PROGRAM): $(SRC)
	gcc $(SRC) -o $(PROGRAM) $(FLAGS)

baza:
	mysql -u root -p <baza.sql
	
insert: trigger
	mysql -u root -p -D mydb <insert.sql
	
trigger:
	mysql -u root -p -D mydb <trigger.sql
	
clean:
	-rm -f *.mwb.bak *.out