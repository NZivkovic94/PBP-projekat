USE `mydb`

DELIMITER #

CREATE TRIGGER `Ubaci_u_Osoba`
BEFORE INSERT ON `Ucenik`
FOR EACH ROW
BEGIN
    INSERT INTO `Osoba` VALUES(new.`Osoba_jmbg`, new.`ime`, new.`prezime`, new.`br_tel`, new.`email`);
    IF (
      select count(*)
      from `Ucenik`
      where `Grupa_idGrupe` = new.`Grupa_idGrupe`
      ) >= (
          select distinct `kapacitet`
            from `Ucenik` join `Grupa` on `Ucenik`.`Grupa_idGrupe` = `idGrupe`
                    join `Polaze` on `idGrupe` = `Polaze`.`Grupa_idGrupe`
                    join `Ucionica` on `Ucionica_broj_ucionice` = `broj_ucionice`
           where new.`Grupa_idGrupe` = `Ucenik`.`Grupa_idGrupe`
      )
    THEN
        signal sqlstate '45000' set message_text = 'Nema mesta u grupi';
    END IF;  
END
#

CREATE TRIGGER `Ubaci_u_Polaze_Ucionica`
AFTER INSERT ON `Ucionica`
FOR EACH ROW
BEGIN
    INSERT INTO `Polaze` VALUES(new.`broj_ucionice`, NULL);
END
#

CREATE TRIGGER `Dodaj_grupu_u_Polaze`
AFTER INSERT ON `Grupa`
FOR EACH ROW
BEGIN
    UPDATE `Polaze`
        SET `Grupa_idGrupe` = new.`idGrupe`;
END
#


DELIMITER ;

/*
    

*/