DROP DATABASE IF EXISTS `mydb`;
CREATE DATABASE IF NOT EXISTS `mydb`;

CREATE TABLE IF NOT EXISTS `mydb`.`Osoba` (
  `jmbg` INT NOT NULL,
  `ime` VARCHAR(45) NULL,
  `prezime` VARCHAR(45) NULL,
  `br_tel` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`jmbg`))
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Skola` (
  `ptt` INT NOT NULL,
  `Adresa` VARCHAR(45) NULL,
  `Naziv` VARCHAR(45) NULL,
  `prima_ucenika` INT NULL,
  PRIMARY KEY (`ptt`))
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Polaganje` (
  `idPolaganja` INT NOT NULL,
  `Datum` DATE NULL,
  `Skola_ptt` INT NOT NULL,
  PRIMARY KEY (`idPolaganja`),
  INDEX `fk_Polaganje_Skola1_idx` (`Skola_ptt` ASC),
  CONSTRAINT `fk_Polaganje_Skola1`
    FOREIGN KEY (`Skola_ptt`)
    REFERENCES `mydb`.`Skola` (`ptt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Grupa` (
  `idGrupe` INT NOT NULL,
  `vreme_pocetka` TIME NULL,
  `vreme_zavrsetka` TIME NULL,
  `Polaganje_idPolaganja` INT NOT NULL,
  PRIMARY KEY (`idGrupe`, `Polaganje_idPolaganja`),
  INDEX `fk_Grupa_Polaganje1_idx` (`Polaganje_idPolaganja` ASC),
  CONSTRAINT `fk_Grupa_Polaganje1`
    FOREIGN KEY (`Polaganje_idPolaganja`)
    REFERENCES `mydb`.`Polaganje` (`idPolaganja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Ucenik` (
  `Osoba_jmbg` INT NOT NULL,
  `ime` VARCHAR(45) NULL,
  `prezime` VARCHAR(45) NULL,
  `br_tel` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `Grupa_idGrupe` INT,
  PRIMARY KEY (`Osoba_jmbg`),
  INDEX `fk_Ucenik_Grupa1_idx` (`Grupa_idGrupe` ASC),
  CONSTRAINT `fk_Ucenik_Osoba1`
    FOREIGN KEY (`Osoba_jmbg`)
    REFERENCES `mydb`.`Osoba` (`jmbg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ucenik_Grupa1`
    FOREIGN KEY (`Grupa_idGrupe`)
    REFERENCES `mydb`.`Grupa` (`idGrupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Ucionica` (
  `broj_ucionice` INT NOT NULL,
  `kapacitet` INT NULL,
  `Skola_ptt` INT NOT NULL,
  PRIMARY KEY (`broj_ucionice`, `Skola_ptt`),
  INDEX `fk_Ucionica_Skola1_idx` (`Skola_ptt` ASC),
  CONSTRAINT `fk_Ucionica_Skola1`
    FOREIGN KEY (`Skola_ptt`)
    REFERENCES `mydb`.`Skola` (`ptt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Nastavnik` (
  `Osoba_jmbg` INT NOT NULL,
  `Ucionica_broj_ucionice` INT NOT NULL,
  PRIMARY KEY (`Osoba_jmbg`, `Ucionica_broj_ucionice`),
  INDEX `fk_Nastavnik_Ucionica1_idx` (`Ucionica_broj_ucionice` ASC),
  CONSTRAINT `fk_Nastavnik_Osoba`
    FOREIGN KEY (`Osoba_jmbg`)
    REFERENCES `mydb`.`Osoba` (`jmbg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nastavnik_Ucionica1`
    FOREIGN KEY (`Ucionica_broj_ucionice`)
    REFERENCES `mydb`.`Ucionica` (`broj_ucionice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Rad` (
  `Ucenik_Osoba_jmbg` INT NOT NULL,
  `Nastavnik_Osoba_jmbg` INT NOT NULL,
  PRIMARY KEY (`Ucenik_Osoba_jmbg`, `Nastavnik_Osoba_jmbg`),
  INDEX `fk_Rad_Nastavnik1_idx` (`Nastavnik_Osoba_jmbg` ASC),
  CONSTRAINT `fk_Rad_Ucenik1`
    FOREIGN KEY (`Ucenik_Osoba_jmbg`)
    REFERENCES `mydb`.`Ucenik` (`Osoba_jmbg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rad_Nastavnik1`
    FOREIGN KEY (`Nastavnik_Osoba_jmbg`)
    REFERENCES `mydb`.`Nastavnik` (`Osoba_jmbg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Dezura_u_grupi` (
  `Nastavnik_Osoba_jmbg` INT NOT NULL,
  `Grupa_idGrupe` INT NOT NULL,
  PRIMARY KEY (`Nastavnik_Osoba_jmbg`, `Grupa_idGrupe`),
  INDEX `fk_Nastavnik_has_Grupa_Grupa1_idx` (`Grupa_idGrupe` ASC),
  INDEX `fk_Nastavnik_has_Grupa_Nastavnik1_idx` (`Nastavnik_Osoba_jmbg` ASC),
  CONSTRAINT `fk_Nastavnik_has_Grupa_Nastavnik1`
    FOREIGN KEY (`Nastavnik_Osoba_jmbg`)
    REFERENCES `mydb`.`Nastavnik` (`Osoba_jmbg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nastavnik_has_Grupa_Grupa1`
    FOREIGN KEY (`Grupa_idGrupe`)
    REFERENCES `mydb`.`Grupa` (`idGrupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `mydb`.`Polaze` (
  `Ucionica_broj_ucionice` INT NOT NULL,
  `Grupa_idGrupe` INT NOT NULL,
  PRIMARY KEY (`Ucionica_broj_ucionice`, `Grupa_idGrupe`),
  INDEX `fk_Ucionica_has_Grupa_Grupa1_idx` (`Grupa_idGrupe` ASC),
  INDEX `fk_Ucionica_has_Grupa_Ucionica1_idx` (`Ucionica_broj_ucionice` ASC),
  CONSTRAINT `fk_Ucionica_has_Grupa_Ucionica1`
    FOREIGN KEY (`Ucionica_broj_ucionice`)
    REFERENCES `mydb`.`Ucionica` (`broj_ucionice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ucionica_has_Grupa_Grupa1`
    FOREIGN KEY (`Grupa_idGrupe`)
    REFERENCES `mydb`.`Grupa` (`idGrupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
;
