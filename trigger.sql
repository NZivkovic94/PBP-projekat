USE `mydb`

DELIMITER #

CREATE TRIGGER `Ubaci_u_Osoba`
BEFORE INSERT ON `Ucenik`
FOR EACH ROW
BEGIN
    INSERT INTO `Osoba` VALUES(new.`Osoba_jmbg`, new.`ime`, new.`prezime`, new.`br_tel`, new.`email`);
END
#

DELIMITER ;
