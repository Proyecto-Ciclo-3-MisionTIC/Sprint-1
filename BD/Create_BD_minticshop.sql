SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema minticshop
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `minticshop` ;

-- -----------------------------------------------------
-- Schema minticshop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `minticshop`;
USE `minticshop` ;

-- -----------------------------------------------------
-- Table `minticshop`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`cliente` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`cliente` (
  `id_cliente` INT NOT NULL COMMENT 'Identificador único del cliente',
  `doc_cliente` INT NULL COMMENT 'documento de identidad del cliente',
  `nombre` VARCHAR(50) NOT NULL COMMENT 'nombre del cliente',
  `apellido` VARCHAR(50) NOT NULL COMMENT 'apellido del cliente',
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`estado_disp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`estado_disp` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`estado_disp` (
  `id_estado_disp` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador único del estado de disponibilidad',
  `descripcion` VARCHAR(15) NOT NULL COMMENT 'descripción del estado de disponibilidad: DISPONIBLE/NO DISPONIBLE',
  PRIMARY KEY (`id_estado_disp`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`estado_venta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`estado_venta` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`estado_venta` (
  `id_estado_venta` INT NOT NULL COMMENT 'id del estado de la venta',
  `descripcion` VARCHAR(50) NOT NULL COMMENT 'descripción estado de la venta: EN PROCESO/CANCELADA/ENTREGADA',
  PRIMARY KEY (`id_estado_venta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`producto` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador único del producto',
  `descripcion` VARCHAR(50) NOT NULL COMMENT 'descripción del producto',
  `valor_unitario` DECIMAL(5,2) NOT NULL COMMENT 'valor unitario del producto',
  `id_estado_disp` INT NOT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `id_estado_disp_idx` (`id_estado_disp` ASC) VISIBLE,
  CONSTRAINT `id_estado_disp`
    FOREIGN KEY (`id_estado_disp`)
    REFERENCES `minticshop`.`estado_disp` (`id_estado_disp`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`rol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`rol` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`rol` (
  `id_rol` INT NOT NULL COMMENT 'Identificador único del rol',
  `descripcion` VARCHAR(50) NOT NULL COMMENT 'descripción del rol: ADMINISTRADOR/VENDEDOR',
  PRIMARY KEY (`id_rol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`usuario` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`usuario` (
  `id_usuario` INT NOT NULL COMMENT 'Identificador único del usuario',
  `Id_rol` INT NOT NULL COMMENT 'llave foránea del rol: ADMINISTRADOR/VENDEDOR',
  `id_estado_aut` INT NULL COMMENT 'llave foránea del estado de autorización: PENDIENTE/AUTORIZADO/NO_AUTORIZADO',
  PRIMARY KEY (`id_usuario`),
  INDEX `Id_rol_idx` (`Id_rol` ASC) VISIBLE,
  CONSTRAINT `Id_rol`
    FOREIGN KEY (`Id_rol`)
    REFERENCES `minticshop`.`rol` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`vendedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`vendedor` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`vendedor` (
  `id_vendedor` INT NOT NULL COMMENT 'Identificador único del cliente',
  `nombre` VARCHAR(50) NOT NULL COMMENT 'nombre del vendedor',
  `apellido` VARCHAR(50) NOT NULL COMMENT 'apellido del vendedor',
  PRIMARY KEY (`id_vendedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`venta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`venta` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`venta` (
  `id_venta` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador único de la venta',
  `id_cliente` INT NOT NULL COMMENT 'llave foránea id del cliente',
  `id_vendedor` INT NOT NULL COMMENT 'llave foránea id del vendedor',
  `id_estado_venta` INT NOT NULL COMMENT 'llave foránea id estado de la venta',
  `valor_total_venta` DOUBLE NULL COMMENT 'valor total de la venta: (valor calculado cantidad x precio unitario del producto)',
  `fecha_venta` DATETIME NOT NULL COMMENT 'fecha de venta del producto',
  PRIMARY KEY (`id_venta`),
  INDEX `id_cliente_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `id_vendedor_idx` (`id_vendedor` ASC) VISIBLE,
  INDEX `id_estado_venta_idx` (`id_estado_venta` ASC) VISIBLE,
  CONSTRAINT `id_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `minticshop`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_vendedor`
    FOREIGN KEY (`id_vendedor`)
    REFERENCES `minticshop`.`vendedor` (`id_vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_estado_venta`
    FOREIGN KEY (`id_estado_venta`)
    REFERENCES `minticshop`.`estado_venta` (`id_estado_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minticshop`.`venta_producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `minticshop`.`venta_producto` ;

CREATE TABLE IF NOT EXISTS `minticshop`.`venta_producto` (
  `id_venta_producto` INT NOT NULL,
  `id_venta` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NULL,
  `valor` DOUBLE NULL,
  PRIMARY KEY (`id_venta_producto`),
  INDEX `id_producto_idx` (`id_producto` ASC) VISIBLE,
  INDEX `id_venta_idx` (`id_venta` ASC) VISIBLE,
  CONSTRAINT `id_venta`
    FOREIGN KEY (`id_venta`)
    REFERENCES `minticshop`.`venta` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `minticshop`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
