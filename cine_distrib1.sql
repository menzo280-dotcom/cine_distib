-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           12.3.3-MariaDB - MariaDB Server
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.20.0.7320
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para cine_distrib
CREATE DATABASE IF NOT EXISTS `cine_distrib` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `cine_distrib`;

-- Copiando estrutura para tabela cine_distrib.cinema
CREATE TABLE IF NOT EXISTS `cinema` (
  `id_cinema` int(11) NOT NULL AUTO_INCREMENT,
  `id_exibidor` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `endereco` varchar(200) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `estado` varchar(2) DEFAULT NULL,
  `quantidade_salas` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_cinema`),
  KEY `fk_cinema_exibidor` (`id_exibidor`),
  CONSTRAINT `fk_cinema_exibidor` FOREIGN KEY (`id_exibidor`) REFERENCES `exibidor` (`id_exibidor`),
  CONSTRAINT `chk_quantidade_salas` CHECK (`quantidade_salas` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.contrato_distribuicao
CREATE TABLE IF NOT EXISTS `contrato_distribuicao` (
  `id_contrato` int(11) NOT NULL AUTO_INCREMENT,
  `id_titular` int(11) NOT NULL,
  `numero_contrato` varchar(50) NOT NULL,
  `data_assinatura` date NOT NULL,
  `valor_contrato` decimal(12,2) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`id_contrato`),
  UNIQUE KEY `numero_contrato` (`numero_contrato`),
  KEY `fk_cd_titular` (`id_titular`),
  CONSTRAINT `fk_cd_titular` FOREIGN KEY (`id_titular`) REFERENCES `titular_direitos` (`id_titular`),
  CONSTRAINT `chk_status_contrato` CHECK (`status` in ('Ativo','Encerrado','Suspenso'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.contrato_filme
CREATE TABLE IF NOT EXISTS `contrato_filme` (
  `id_contrato_filme` int(11) NOT NULL AUTO_INCREMENT,
  `id_contrato` int(11) NOT NULL,
  `id_filme` int(11) NOT NULL,
  `territorio` varchar(100) NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date NOT NULL,
  `exclusivo` tinyint(1) NOT NULL DEFAULT 0,
  `tipo_direito` varchar(60) NOT NULL,
  PRIMARY KEY (`id_contrato_filme`),
  KEY `fk_cf_contrato` (`id_contrato`),
  KEY `fk_cf_filme` (`id_filme`),
  CONSTRAINT `fk_cf_contrato` FOREIGN KEY (`id_contrato`) REFERENCES `contrato_distribuicao` (`id_contrato`),
  CONSTRAINT `fk_cf_filme` FOREIGN KEY (`id_filme`) REFERENCES `filme` (`id_filme`),
  CONSTRAINT `chk_periodo_contrato_filme` CHECK (`data_fim` >= `data_inicio`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.exibidor
CREATE TABLE IF NOT EXISTS `exibidor` (
  `id_exibidor` int(11) NOT NULL AUTO_INCREMENT,
  `razao_social` varchar(150) NOT NULL,
  `nome_fantasia` varchar(150) DEFAULT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_exibidor`),
  UNIQUE KEY `cnpj` (`cnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.filme
CREATE TABLE IF NOT EXISTS `filme` (
  `id_filme` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(150) NOT NULL,
  `titulo_original` varchar(150) DEFAULT NULL,
  `sinopse` text DEFAULT NULL,
  `ano_lancamento` int(11) DEFAULT NULL,
  `duracao_minutos` int(11) DEFAULT NULL,
  `classificacao_indicativa` varchar(20) DEFAULT NULL,
  `pais_origem` varchar(80) DEFAULT NULL,
  `idioma_original` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_filme`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.filme_genero
CREATE TABLE IF NOT EXISTS `filme_genero` (
  `id_filme` int(11) NOT NULL,
  `id_genero` int(11) NOT NULL,
  PRIMARY KEY (`id_filme`,`id_genero`),
  KEY `fk_fg_genero` (`id_genero`),
  CONSTRAINT `fk_fg_filme` FOREIGN KEY (`id_filme`) REFERENCES `filme` (`id_filme`) ON DELETE CASCADE,
  CONSTRAINT `fk_fg_genero` FOREIGN KEY (`id_genero`) REFERENCES `genero` (`id_genero`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.filme_produtora
CREATE TABLE IF NOT EXISTS `filme_produtora` (
  `id_filme` int(11) NOT NULL,
  `id_produtora` int(11) NOT NULL,
  PRIMARY KEY (`id_filme`,`id_produtora`),
  KEY `fk_fp_produtora` (`id_produtora`),
  CONSTRAINT `fk_fp_filme` FOREIGN KEY (`id_filme`) REFERENCES `filme` (`id_filme`) ON DELETE CASCADE,
  CONSTRAINT `fk_fp_produtora` FOREIGN KEY (`id_produtora`) REFERENCES `produtora` (`id_produtora`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.genero
CREATE TABLE IF NOT EXISTS `genero` (
  `id_genero` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `descricao` text DEFAULT NULL,
  PRIMARY KEY (`id_genero`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.licenca_exibicao
CREATE TABLE IF NOT EXISTS `licenca_exibicao` (
  `id_licenca` int(11) NOT NULL AUTO_INCREMENT,
  `id_contrato_filme` int(11) NOT NULL,
  `id_cinema` int(11) NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date NOT NULL,
  `percentual_distribuidora` decimal(5,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Ativa',
  PRIMARY KEY (`id_licenca`),
  KEY `fk_licenca_contrato_filme` (`id_contrato_filme`),
  KEY `fk_licenca_cinema` (`id_cinema`),
  CONSTRAINT `fk_licenca_cinema` FOREIGN KEY (`id_cinema`) REFERENCES `cinema` (`id_cinema`),
  CONSTRAINT `fk_licenca_contrato_filme` FOREIGN KEY (`id_contrato_filme`) REFERENCES `contrato_filme` (`id_contrato_filme`),
  CONSTRAINT `chk_periodo_licenca` CHECK (`data_fim` >= `data_inicio`),
  CONSTRAINT `chk_percentual` CHECK (`percentual_distribuidora` between 0 and 100)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.pagamento
CREATE TABLE IF NOT EXISTS `pagamento` (
  `id_pagamento` int(11) NOT NULL AUTO_INCREMENT,
  `id_relatorio` int(11) NOT NULL,
  `valor_pago` decimal(14,2) NOT NULL,
  `data_pagamento` date NOT NULL,
  `forma_pagamento` varchar(50) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Confirmado',
  PRIMARY KEY (`id_pagamento`),
  KEY `fk_pagamento_relatorio` (`id_relatorio`),
  CONSTRAINT `fk_pagamento_relatorio` FOREIGN KEY (`id_relatorio`) REFERENCES `relatorio_bilheteria` (`id_relatorio`),
  CONSTRAINT `chk_valor_pagamento` CHECK (`valor_pago` > 0),
  CONSTRAINT `chk_status_pagamento` CHECK (`status` in ('Pendente','Confirmado','Cancelado'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.produtora
CREATE TABLE IF NOT EXISTS `produtora` (
  `id_produtora` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `pais_origem` varchar(80) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_produtora`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.relatorio_bilheteria
CREATE TABLE IF NOT EXISTS `relatorio_bilheteria` (
  `id_relatorio` int(11) NOT NULL AUTO_INCREMENT,
  `id_licenca` int(11) NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date NOT NULL,
  `quantidade_ingressos` int(11) NOT NULL DEFAULT 0,
  `receita_bruta` decimal(14,2) NOT NULL DEFAULT 0.00,
  `valor_devido` decimal(14,2) NOT NULL DEFAULT 0.00,
  `data_envio` date DEFAULT curdate(),
  PRIMARY KEY (`id_relatorio`),
  KEY `fk_relatorio_licenca` (`id_licenca`),
  CONSTRAINT `fk_relatorio_licenca` FOREIGN KEY (`id_licenca`) REFERENCES `licenca_exibicao` (`id_licenca`),
  CONSTRAINT `chk_periodo_relatorio` CHECK (`data_fim` >= `data_inicio`),
  CONSTRAINT `chk_valores_relatorio` CHECK (`quantidade_ingressos` >= 0 and `receita_bruta` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela cine_distrib.titular_direitos
CREATE TABLE IF NOT EXISTS `titular_direitos` (
  `id_titular` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `documento` varchar(30) DEFAULT NULL,
  `pais` varchar(80) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_titular`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para trigger cine_distrib.trg_calcular_valor_devido_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER trg_calcular_valor_devido_insert
BEFORE INSERT ON relatorio_bilheteria
FOR EACH ROW
BEGIN
    DECLARE v_percentual DECIMAL(5,2);
    SELECT percentual_distribuidora INTO v_percentual
    FROM licenca_exibicao WHERE id_licenca = NEW.id_licenca;
    SET NEW.valor_devido = ROUND(NEW.receita_bruta * v_percentual / 100, 2);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cine_distrib.trg_calcular_valor_devido_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER trg_calcular_valor_devido_update
BEFORE UPDATE ON relatorio_bilheteria
FOR EACH ROW
BEGIN
    DECLARE v_percentual DECIMAL(5,2);
    SELECT percentual_distribuidora INTO v_percentual
    FROM licenca_exibicao WHERE id_licenca = NEW.id_licenca;
    SET NEW.valor_devido = ROUND(NEW.receita_bruta * v_percentual / 100, 2);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cine_distrib.trg_validar_pagamento_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER trg_validar_pagamento_insert
BEFORE INSERT ON pagamento
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(14,2);
    DECLARE v_devido DECIMAL(14,2);
    IF NEW.status = 'Confirmado' THEN
        SELECT COALESCE(SUM(valor_pago), 0) INTO v_total
        FROM pagamento
        WHERE id_relatorio = NEW.id_relatorio AND status = 'Confirmado';
        SELECT valor_devido INTO v_devido
        FROM relatorio_bilheteria WHERE id_relatorio = NEW.id_relatorio;
        IF v_total + NEW.valor_pago > v_devido THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Pagamentos confirmados excedem o valor devido.';
        END IF;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cine_distrib.trg_validar_pagamento_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER trg_validar_pagamento_update
BEFORE UPDATE ON pagamento
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(14,2);
    DECLARE v_devido DECIMAL(14,2);
    IF NEW.status = 'Confirmado' THEN
        SELECT COALESCE(SUM(valor_pago), 0) INTO v_total
        FROM pagamento
        WHERE id_relatorio = NEW.id_relatorio
          AND status = 'Confirmado'
          AND id_pagamento <> OLD.id_pagamento;
        SELECT valor_devido INTO v_devido
        FROM relatorio_bilheteria WHERE id_relatorio = NEW.id_relatorio;
        IF v_total + NEW.valor_pago > v_devido THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Pagamentos confirmados excedem o valor devido.';
        END IF;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
