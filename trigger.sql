USE `mydb`

DELIMITER #

CREATE TRIGGER `Rasporedi_u_grupu`
AFTER INSERT ON `Ucenik`
FOR EACH ROW
BEGIN
    IF (
      select count(*)
      from `Ucenik`
      where `Grupa_idGrupe` = new.`Grupa_idGrupe`
    ) >= (
        select sum(`Kapacitet`)
          from `Grupa` 
            join `Polaze` on `Grupa`.`idGrupe` = `Polaze`.`Grupa_idGrupe`
            join `Ucionica` on `Polaze`.`Ucionica_broj_ucionice` = `Ucionica`.`broj_ucionice` 
         where `idGrupe` = new.`Grupa_idGrupe`
    )
    THEN
        IF EXISTS (
            select `idGrupe`
              from `Grupa` g
             where (
                 select count(*)
                   from `Ucenik`
                  where `Grupa_idGrupe` = g.`idGrupe`
             ) < (
                select sum(`Kapacitet`)
                from `Grupa` 
                    join `Polaze` on `Grupa`.`idGrupe` = `Polaze`.`Grupa_idGrupe`
                    join `Ucionica` on `Polaze`.`Ucionica_broj_ucionice` = `Ucionica`.`broj_ucionice` 
                where `idGrupe` = g.`idGrupe`
             )
        )
        THEN 
            update `Ucenik`
                set `Ucenik`.`Grupa_idGrupe` = (
                    select g.`idGrupe`
                    from `Grupa` g
                    where (
                        select count(*)
                        from `Ucenik`
                        where `Grupa_idGrupe` = g.`idGrupe`
                        ) < (
                            select sum(`Kapacitet`)
                            from `Grupa` 
                                join `Polaze` on `Grupa`.`idGrupe` = `Polaze`.`Grupa_idGrupe`
                                join `Ucionica` on `Polaze`.`Ucionica_broj_ucionice` = `Ucionica`.`broj_ucionice` 
                            where `idGrupe` = g.`idGrupe`
                        )
                    group by g.`idGrupe`
                    having max(`idGrupe`)
                );
        END IF;        
    END IF;  
END
#

CREATE TRIGGER zabraniti_unos_ako_nigde_nema_mesta
BEFORE INSERT ON `Ucenik`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
            select `idGrupe`
              from `Grupa` g
             where (
                 select count(*)
                   from `Ucenik`
                  where `Grupa_idGrupe` = g.`idGrupe`
             ) < (
                select sum(`Kapacitet`)
                from `Grupa` 
                    join `Polaze` on `Grupa`.`idGrupe` = `Polaze`.`Grupa_idGrupe`
                    join `Ucionica` on `Polaze`.`Ucionica_broj_ucionice` = `Ucionica`.`broj_ucionice` 
                where `idGrupe` = g.`idGrupe`
             )
        )
    THEN
        signal sqlstate '75000' set message_text = 'Nema vise slobodnih grupa';
    END IF;
    IF NOT EXISTS (
        select `idGrupe`
        from `Grupa`
        where new.`Grupa_idGrupe` = `idGrupe`
    )
    THEN 
        signal sqlstate '45000' set message_text = 'Ne postoji ta grupa, probajte opet';
    END IF;
END
#

DELIMITER ;