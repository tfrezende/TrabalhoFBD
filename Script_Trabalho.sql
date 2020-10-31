-- EREINF01145 - Fundamentos de Bancos de Dados (Turma B)
-- Alunos: Douglas Flôres e Thalles Rezende
-- Script desenvolvido em PostgreSQL

CREATE DATABASE "Trabalho"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE TABLESPACE "Trabalho"
  OWNER postgres
  LOCATION 'D:\UFRGS\FBD';

ALTER TABLESPACE "Trabalho"
  OWNER TO postgres;

CREATE TABLE Usuario (
	id_usuario INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	emaiL VARCHAR(50) NOT NULL,
	senha VARCHAR(30) NOT NULL,
	telefone_ddd NUMERIC(2) NOT NULL,
	telefone_nro NUMERIC(9) NOT NULL,
	PRIMARY KEY(id_usuario),
	UNIQUE(email)
);

CREATE TABLE Cliente (
	id_user INTEGER NOT NULL,
	cpf CHAR(14) NOT NULL,
	PRIMARY KEY(id_user),
	FOREIGN KEY(id_user) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL,
	UNIQUE(cpf)
);

CREATE TABLE Vendedor (
	id_user INTEGER NOT NULL,
	cnpj CHAR(18) NOT NULL,
	nome_fantasia VARCHAR(60) NOT NULL,
	descricao VARCHAR(300),
	PRIMARY KEY(id_user),
	FOREIGN KEY(id_user) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL,
	UNIQUE(cnpj)
);

CREATE TABLE Cartao (
	numero NUMERIC(16) NOT NULL,
	vencimento CHAR(5) NOT NULL,
	cpf_titular CHAR(14) NOT NULL,
	nome_titular VARCHAR(50) NOT NULL,
	PRIMARY KEY(numero),
	FOREIGN KEY(cpf_titular) REFERENCES Cliente(cpf) ON UPDATE CASCADE ON DELETE SET NULL,
	UNIQUE(cpf_titular)
);

CREATE TABLE Endereco (
	id_endereco INTEGER NOT NULL,
	proprietario INTEGER NOT NULL,
	rua VARCHAR(30) NOT NULL,
	numero SMALLINT NOT NULL,
	complemento VARCHAR(10),
	cep NUMERIC(8) NOT NULL,
	cidade VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	pais VARCHAR(30) NOT NULL,
	PRIMARY KEY(id_endereco),
	FOREIGN KEY(proprietario) REFERENCES Usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Departamento (
	id_departamento INTEGER NOT NULL,
	nome VARCHAR(30),
	PRIMARY KEY(id_departamento)
);

CREATE TABLE Produto (
	id_produto INTEGER NOT NULL,
	nome VARCHAR(30) NOT NULL,
	descricao VARCHAR(300),
	avaliacao FLOAT(3),
	classificacao INTEGER NOT NULL,
	PRIMARY KEY(id_produto),
	FOREIGN KEY(classificacao) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Oferta (
	id_oferta INTEGER NOT NULL,
	id_produto INTEGER NOT NULL,
	cnpj_vendedor CHAR(18) NOT NULL,
	valor MONEY NOT NULL,
	estoque INTEGER NOT NULL,
	PRIMARY KEY(id_oferta),
	FOREIGN KEY(id_produto) REFERENCES Produto(id_produto) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(cnpj_vendedor) REFERENCES Vendedor(cnpj) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Avaliacao (
	id_cliente INTEGER NOT NULL,
	id_oferta INTEGER NOT NULL,
	valiacao FLOAT(3) NOT NULL,
	comentario VARCHAR(300),
	PRIMARY KEY(id_cliente, id_oferta),
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id_user) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(id_oferta) REFERENCES Oferta(id_oferta) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Cupom (
	id_cupom INTEGER NOT NULL,
	nome VARCHAR(30) NOT NULL,
	valor MONEY NOT NULL,
	validade TIMESTAMP,
	limite_uso SMALLINT,
	PRIMARY KEY(id_cupom)
);

CREATE TABLE Uso_Cupom (
	id_cupom INTEGER NOT NULL,
	cpf CHARACTER(14) NOT NULL,
	PRIMARY KEY(id_cupom, cpf),
	FOREIGN KEY(id_cupom) REFERENCES Cupom(id_cupom) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(cpf) REFERENCES Cliente(cpf) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Pedido (
	numero BIGINT NOT NULL,
	metodo_pagamento VARCHAR(10) NOT NULL check(metodo_pagamento in ('Boleto','Cartao','Cartão')),
	status VARCHAR(15) NOT NULL,
	valor_final MONEY NOT NULL,
	end_destino INTEGER NOT NULL,
	cartao NUMERIC(16),
	PRIMARY KEY(numero),
	FOREIGN KEY(end_destino) REFERENCES Endereco(id_endereco) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(cartao) REFERENCES cartao(numero) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Desconto (
	id_cupom INTEGER NOT NULL,
	num_pedido BIGINT NOT NULL,
	PRIMARY KEY(id_cupom, num_pedido),
	FOREIGN KEY(id_cupom) REFERENCES Cupom(id_cupom) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(num_pedido) REFERENCES Pedido(numero) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Transportadora (
	id_transportadora INTEGER NOT NULL,
	cnpj CHAR(18) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY(id_transportadora),
	UNIQUE(cnpj)
);

CREATE TABLE Selecao_Transportadora (
	id_oferta INTEGER NOT NULL,
	transporte INTEGER NOT NULL,
	PRIMARY KEY(id_oferta, transporte),
	FOREIGN KEY(id_oferta) REFERENCES Oferta(id_oferta) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(transporte) REFERENCES Transportadora(id_transportadora) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Pacote (
	id_remessa INTEGER NOT NULL,
	valor MONEY NOT NULL,
	status VARCHAR(15) NOT NULL,
	data_prevista TIMESTAMP NOT NULL,
	transporte INTEGER NOT NULL,
	destino INTEGER NOT NULL,
	PRIMARY KEY(id_remessa),
	FOREIGN KEY(transporte) REFERENCES Transportadora(id_transportadora) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(destino) REFERENCES Endereco(id_endereco) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Item (
	id_oferta INTEGER NOT NULL,
	num_pedido BIGINT NOT NULL,
	quantidade INTEGER NOT NULL,
	id_pacote INTEGER NOT NULL,
	PRIMARY KEY(id_oferta, num_pedido),
	FOREIGN KEY(id_oferta) REFERENCES Oferta(id_oferta) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(num_pedido) REFERENCES Pedido(numero) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY(id_pacote) REFERENCES Pacote(id_remessa) ON UPDATE CASCADE ON DELETE SET NULL,
	UNIQUE(id_pacote)
);

------------------------------------------------------------------------------------------------------------

INSERT INTO Usuario VALUES (111111, 'Joao da Silva', 'joao@email.com', '12345', 51, 999999999);
INSERT INTO Usuario VALUES (222222, 'Maria da Silva', 'maria@email.com', '54321', 54, 888888888);
INSERT INTO Usuario VALUES (333333, 'Jô Soares', 'josoares@email.com', 'senha', 11, 777777777);
INSERT INTO Usuario VALUES (444444, 'Ferragem do Zé', 'contato@ferragem.com', 'senhasegura', 51, 555555555);
INSERT INTO Usuario VALUES (555555, 'Loja da Sandra', 'loja@sandra.com', 'password', 53, 444444444);
INSERT INTO Usuario VALUES (666666, 'Padaria do Manuel', 'manuel@padaria.com', '7zJ7%9PqL', 51, 999999999);

INSERT INTO Cliente VALUES (111111, '111.111.111-11');
INSERT INTO Cliente VALUES (222222, '222.222.222-22');
INSERT INTO Cliente VALUES (333333, '333.333.333-33');

INSERT INTO Endereco VALUES (1, 111111, 'Rua 1', 10, 'Ap 101', 99999999, 'Porto Alegre', 'RS', 'Brasil');
INSERT INTO Endereco VALUES (2, 222222, 'Rua 2', 23, 'Ap 404', 88888888, 'Caxias do Sul', 'RS', 'Brasil');
INSERT INTO Endereco VALUES (3, 333333, 'Rua 3', 45, 'Ap 705', 77777777, 'São Paulo', 'SP', 'Brasil');

INSERT INTO Vendedor VALUES (444444, '11.111.111/0001-91', 'Zé Ferragens LTDA', 'Melhor ferragem da cidade');
INSERT INTO Vendedor VALUES (555555, '22.222.222/0002-92', 'Loja da Santa SA');
INSERT INTO Vendedor VALUES (666666, '33.333.333/0003-93', 'Padaria do Manuel LTDA', 'Aqui tem pão');

INSERT INTO Departamento VALUES (1, 'Eletronicos');
INSERT INTO Departamento VALUES (2, 'Jardinagem');
INSERT INTO Departamento VALUES (3, 'Livros');

INSERT INTO Produto (id_produto, nome, classificacao) VALUES (1, 'MP3 player', 1);
INSERT INTO Produto (id_produto, nome, descricao, classificacao) VALUES (2, 'Vaso para plantas', 'Material: argila', 2);
INSERT INTO Produto (id_produto, nome, classificacao) VALUES (3, 'SQL for Dummies', 3);

INSERT INTO Oferta VALUES (1, 1, '22.222.222/0002-92', 150, 20);
INSERT INTO Oferta VALUES (2, 2, '11.111.111/0001-91', 30, 10);
INSERT INTO Oferta VALUES (3, 3, '33.333.333/0003-93', 70, 8);

INSERT INTO Cupom VALUES (1, 'OUTUBRO20', 20, '2020-10-31 23:59:59', 3);
INSERT INTO Cupom VALUES (2, 'PROMO50', 50, '2020-10-10 23:59:59', 1);
INSERT INTO Cupom VALUES (3, 'FACIL10', 10, '2020-10-31 23:59:59', 10);

INSERT INTO Uso_Cupom VALUES (1, '111.111.111-11');
INSERT INTO Uso_Cupom VALUES (2, '222.222.222-22');
INSERT INTO Uso_Cupom VALUES (3, '333.333.333-33');

INSERT INTO Cartao VALUES (1111111111111111, '10/22', '111.111.111-11', 'Joao da Silva');
INSERT INTO Cartao VALUES (2222222222222222, '05/23', '222.222.222-22', 'Maria da Silva');
INSERT INTO Cartao VALUES (3333333333333333, '10/22', '333.333.333-33', 'Jô Soares');

INSERT INTO Pedido VALUES (1, 'Boleto', 'Entregue', 50, 1);
INSERT INTO Pedido VALUES (2, 'Cartao', 'Separando Itens', 150, 2, 2222222222222222);
INSERT INTO Pedido VALUES (3, 'Boleto', 'A caminho', 200, 3);

INSERT INTO Desconto VALUES (1, 1);
INSERT INTO Desconto VALUES (2, 3);
INSERT INTO Desconto VALUES (3, 2);

INSERT INTO Transportadora VALUES (1, '99.999.999/0001-99', 'É Cilada Bino');
INSERT INTO Transportadora VALUES (2, '88.888.888/0001-98', 'CheirosEx');
INSERT INTO Transportadora VALUES (3, '77.777.777/0001-97', 'Reedus & Kojima');

INSERT INTO Selecao_Transportadora VALUES (1, 3);
INSERT INTO Selecao_Transportadora VALUES (2, 1);
INSERT INTO Selecao_Transportadora VALUES (3, 2);

INSERT INTO Pacote VALUES (1, 25, 'Entregue', '2020-10-11 12:00:00', 1, 1);
INSERT INTO Pacote VALUES (2, 0, 'Separando Itens', '2020-10-28 14:00:00', 2, 2);
INSERT INTO Pacote VALUES (3, 150, 'A caminho', '2047-03-05 23:00:00', 3, 3);

INSERT INTO Item VALUES (1, 1, 5, 1);
INSERT INTO Item VALUES (2, 2, 15, 2);
INSERT INTO Item VALUES (3, 3, 1, 3);

INSERT INTO Avaliacao VALUES (111111, 1, 7.5);
INSERT INTO Avaliacao VALUES (222222, 2, 2.5, 'Muito caro');
INSERT INTO Avaliacao VALUES (333333, 3, 9.5, 'Entrega muito rápida, recomendo');
