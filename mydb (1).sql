-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: 08-Set-2019 às 17:15
-- Versão do servidor: 5.7.26
-- versão do PHP: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mydb`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `vender_veiculo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vender_veiculo` (IN `veiculo` INT, IN `vendedor` INT, OUT `valor_comissao_venda` DECIMAL)  begin

set @dataVenda=curdate();
set @valorVeiculo=0;
select valor_veiculo into @valorVeiculo from veiculo where id_veiculo=veiculo;

set @valorComissao=@valorVeiculo*0.02;

select @valorComissao into valor_comissao_venda;


insert into venda_veiculo(veiculo_id_veiculo, vendedor_id_vendedor,data_venda_veiculo,valor_venda_veiculo,valor_comissao_venda_veiculo) values
(veiculo, vendedor, @dataVenda, @valorVeiculo,@valorComissao);
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `valorVendido`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `valorVendido` (`vendedor` INT) RETURNS DECIMAL(10,0) begin 
set @num=0;
select sum(valor_venda_veiculo) into @num from venda_veiculo where vendedor_id_vendedor=vendedor;
return @num;
return 1;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `carrosvendidossetembro`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `carrosvendidossetembro`;
CREATE TABLE IF NOT EXISTS `carrosvendidossetembro` (
`modelo_veiculo` varchar(100)
,`valor_venda_veiculo` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `maiorvendedor`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `maiorvendedor`;
CREATE TABLE IF NOT EXISTS `maiorvendedor` (
`nome_vendedor` varchar(100)
,`max(soma)` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `somamaiorvendedor`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `somamaiorvendedor`;
CREATE TABLE IF NOT EXISTS `somamaiorvendedor` (
`soma` decimal(32,2)
,`nome_vendedor` varchar(100)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `veiculo`
--

DROP TABLE IF EXISTS `veiculo`;
CREATE TABLE IF NOT EXISTS `veiculo` (
  `id_veiculo` int(11) NOT NULL AUTO_INCREMENT,
  `modelo_veiculo` varchar(100) NOT NULL,
  `marca_veiculo` varchar(100) NOT NULL,
  `ano_fabricacao_veiculo` int(4) NOT NULL,
  `ano_modelo_veiculo` int(4) NOT NULL,
  `placa_veiculo` varchar(10) DEFAULT NULL,
  `chassi_veiculo` varchar(20) DEFAULT NULL,
  `valor_veiculo` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_veiculo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `veiculo`
--

INSERT INTO `veiculo` (`id_veiculo`, `modelo_veiculo`, `marca_veiculo`, `ano_fabricacao_veiculo`, `ano_modelo_veiculo`, `placa_veiculo`, `chassi_veiculo`, `valor_veiculo`) VALUES
(1, 'Civic', 'Honda', 2017, 2018, 'HJA-9831', '99933182', '94374.00'),
(2, 'Corolla', 'Toyota', 2016, 2016, 'HJC-9931', '99398103', '86346.00'),
(3, 'Camaro', 'Chevrolet', 2014, 2015, 'HAV-8829', '99288131', '186711.00'),
(4, 'Freemont', 'Fiat', 2011, 2012, 'FLJ-3128', '77312993', '52660.00'),
(5, 'HRV', 'Honda', 2016, 2016, 'FAY-8221', '88331293', '84164.00');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vendaveiculo`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vendaveiculo`;
CREATE TABLE IF NOT EXISTS `vendaveiculo` (
`Veiculo` varchar(100)
,`Vendedor` varchar(100)
,`Data da Venda` date
,`Valor de Comissão da Venda` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `venda_veiculo`
--

DROP TABLE IF EXISTS `venda_veiculo`;
CREATE TABLE IF NOT EXISTS `venda_veiculo` (
  `id_venda_veiculo` int(11) NOT NULL AUTO_INCREMENT,
  `veiculo_id_veiculo` int(11) NOT NULL,
  `vendedor_id_vendedor` int(11) NOT NULL,
  `data_venda_veiculo` date NOT NULL,
  `valor_venda_veiculo` decimal(10,2) NOT NULL DEFAULT '0.00',
  `valor_comissao_venda_veiculo` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_venda_veiculo`),
  KEY `veiculo_id_veiculo` (`veiculo_id_veiculo`),
  KEY `vendedor_id_vendedor` (`vendedor_id_vendedor`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `venda_veiculo`
--

INSERT INTO `venda_veiculo` (`id_venda_veiculo`, `veiculo_id_veiculo`, `vendedor_id_vendedor`, `data_venda_veiculo`, `valor_venda_veiculo`, `valor_comissao_venda_veiculo`) VALUES
(3, 4, 1, '2019-09-08', '52660.00', '1053.20'),
(4, 1, 2, '2019-09-08', '94374.00', '1887.48'),
(5, 5, 1, '2019-09-08', '84164.00', '1683.28'),
(6, 2, 5, '2019-09-08', '86346.00', '1726.92');

--
-- Acionadores `venda_veiculo`
--
DROP TRIGGER IF EXISTS `inc_num_carros_vendidos_vendedor`;
DELIMITER $$
CREATE TRIGGER `inc_num_carros_vendidos_vendedor` AFTER INSERT ON `venda_veiculo` FOR EACH ROW begin
update vendedor set
num_carros_vendidos_vendedor = num_carros_vendidos_vendedor+1
where id_vendedor=new.vendedor_id_vendedor;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `vendedor`
--

DROP TABLE IF EXISTS `vendedor`;
CREATE TABLE IF NOT EXISTS `vendedor` (
  `id_vendedor` int(11) NOT NULL AUTO_INCREMENT,
  `nome_vendedor` varchar(100) NOT NULL,
  `num_carros_vendidos_vendedor` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_vendedor`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `vendedor`
--

INSERT INTO `vendedor` (`id_vendedor`, `nome_vendedor`, `num_carros_vendidos_vendedor`) VALUES
(1, 'Carlos', 1),
(2, 'Joaquim', 1),
(3, 'Júlia', 0),
(4, 'Letícia', 0),
(5, 'Roberto', 1);

-- --------------------------------------------------------

--
-- Structure for view `carrosvendidossetembro`
--
DROP TABLE IF EXISTS `carrosvendidossetembro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `carrosvendidossetembro`  AS  select `v`.`modelo_veiculo` AS `modelo_veiculo`,`vv`.`valor_venda_veiculo` AS `valor_venda_veiculo` from (`venda_veiculo` `vv` join `veiculo` `v`) where ((`vv`.`veiculo_id_veiculo` = `v`.`id_veiculo`) and (`vv`.`data_venda_veiculo` between '2018-09-01' and '2018-09-30')) ;

-- --------------------------------------------------------

--
-- Structure for view `maiorvendedor`
--
DROP TABLE IF EXISTS `maiorvendedor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `maiorvendedor`  AS  select `somamaiorvendedor`.`nome_vendedor` AS `nome_vendedor`,max(`somamaiorvendedor`.`soma`) AS `max(soma)` from `somamaiorvendedor` ;

-- --------------------------------------------------------

--
-- Structure for view `somamaiorvendedor`
--
DROP TABLE IF EXISTS `somamaiorvendedor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `somamaiorvendedor`  AS  select sum(`venda_veiculo`.`valor_venda_veiculo`) AS `soma`,`vendedor`.`nome_vendedor` AS `nome_vendedor` from (`venda_veiculo` join `vendedor`) where (`venda_veiculo`.`vendedor_id_vendedor` = `vendedor`.`id_vendedor`) group by `vendedor`.`nome_vendedor` ;

-- --------------------------------------------------------

--
-- Structure for view `vendaveiculo`
--
DROP TABLE IF EXISTS `vendaveiculo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vendaveiculo`  AS  select `veiculo`.`modelo_veiculo` AS `Veiculo`,`vendedor`.`nome_vendedor` AS `Vendedor`,`vv`.`data_venda_veiculo` AS `Data da Venda`,`vv`.`valor_comissao_venda_veiculo` AS `Valor de Comissão da Venda` from ((`veiculo` join `venda_veiculo` `vv`) join `vendedor`) where ((`vv`.`veiculo_id_veiculo` = `veiculo`.`id_veiculo`) and (`vv`.`vendedor_id_vendedor` = `vendedor`.`id_vendedor`)) ;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `venda_veiculo`
--
ALTER TABLE `venda_veiculo`
  ADD CONSTRAINT `venda_veiculo_ibfk_1` FOREIGN KEY (`veiculo_id_veiculo`) REFERENCES `veiculo` (`id_veiculo`),
  ADD CONSTRAINT `venda_veiculo_ibfk_2` FOREIGN KEY (`vendedor_id_vendedor`) REFERENCES `vendedor` (`id_vendedor`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
