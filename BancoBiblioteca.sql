CREATE DATABASE Biblioteca;

--------------------------------------------------------------------------------------------------

--Procedimento armazenado que tr�s informa��es sobre uma tabela.
sp_help Autor;

--------------------------------------------------------------------------------------------------

CREATE TABLE Autor(
IdAutor SMALLINT IDENTITY,
NomeAutor VARCHAR(50) NOT NULL,
SobreNomeAutor VARCHAR(60) NOT NULL,
CONSTRAINT pk_id_autor PRIMARY KEY(IdAutor)
);

-- Inserir dados na tabela Autor
INSERT INTO Autor(NomeAutor, SobreNomeAutor)
VALUES
	('Umberto', 'Eco'), ('Daniel', 'Barret'), ('Gerald', 'Carter'),
	('Mark', 'Sobell'), ('William', 'Stanek'), ('Christine', 'Bresnahan'),
	('William', 'Gibson'), ('James', 'Joyce'), ('John', 'Emsley'),
	('Jos�', 'Saramago'), ('Richard', 'Siverman'), ('Robert', 'Byrnes'),
	('Jay', 'Ts'), ('Robert', 'Eckstein'), ('Paul', 'Horowitz'),
	('Winfield', 'Hill'), ('Joel', 'Murach'), ('Paul', 'Scherz'),
	('Simon', 'Monk'), ('George', 'Orwell'), ('�talo', 'Calvino'),
	('Machado', 'de Assis'), ('Oliver', 'Sacks'), ('Ray', 'Bradbury'),
	('Walter', 'Isaacson'), ('Benjamin', 'Graham'), ('J�lio', 'Verne'),
	('Marcelo', 'Gleiser'), ('Harri', 'Lorenzi'), ('Humphrey', 'Carpenter'),
	('Isaac', 'Asimov'), ('Aldous', 'Huxley'), ('Arthur', 'Conan Doyle'),
	('Blaise', 'Pascal'), ('Jostein', 'Gaarder'), ('Stephen', 'Hawking'),
	('Stephen', 'Jay Gould'), ('Neil', 'De Grasse Tysn'), ('Charles', 'Darwin'),
	('Alan', 'Turing'), ('Arthur', 'C. Clarke');

-- Verifica�ao
SELECT * FROM Autor;

--------------------------------------------------------------------------------------------------

CREATE TABLE Editora(
IdEditora SMALLINT PRIMARY KEY IDENTITY,
NomeEditora VARCHAR(50) NOT NULL
);

-- Inserir dados na tabela Editora
INSERT INTO Editora (NomeEditora)
VALUES
	('Prentice Hall'),
	('O�Reilly');

-- Mai editoras
INSERT INTO Editora(NomeEditora)
VALUES
	('Aleph'), ('Microsoft Press'),
	('Wiley'), ('HarperCollins'),
	('�rica'), ('Novatec'),
	('McGraw-Hill'), ('Apress'),
	('Francisco Alves'), ('Sybex'),
	('Globo'), ('Comapanhia das Letras'),
	('Morro Branco'), ('Penguin Books'), ('Martin Claret'),
	('Record'), ('Springer'), ('Melhoramentos'),
	('Oxford'), ('Taschen'),('Ediouro'), ('Bookman');

-- Verifica��o
SELECT * FROM Editora;

--------------------------------------------------------------------------------------------------
CREATE TABLE Assunto(
IdAssunto TINYINT PRIMARY KEY IDENTITY,
NomeAssunto VARCHAR(25) NOT NULL
);

-- Inserir dados na tabela Assunto
INSERT INTO Assunto (NomeAssunto)
VALUES
    ('Fic��o Cient�fica'),
    ('Bot�nica'),
    ('Eletr�nica'),
    ('Matem�tica'),
    ('Aventura'),
    ('Romance'),
    ('Finan�as'),
    ('Gastronomia'),
    ('Terror'),
    ('Administra��o'),
    ('Inform�tica'),
    ('Suspense');

-- Verifica��o
SELECT * FROM Assunto;

--------------------------------------------------------------------------------------------------
CREATE TABLE Livro(
IdLivro SMALLINT NOT NULL PRIMARY KEY IDENTITY(100,1),
NomeLivro VARCHAR(70) NOT NULL,
ISBN13 CHAR(13) UNIQUE NOT NULL,
DataPub DATE,
Pre�oLivro MONEY NOT NULL,
NumeroPaginas SMALLINT NOT NULL,
IdEditora SMALLINT NOT NULL, --chave estrangeira
IdAssunto TINYINT NOT NULL,  --chave estrangeira
CONSTRAINT fk_id_editora FOREIGN KEY(IdEditora)
	REFERENCES Editora(IdEditora) ON DELETE CASCADE,
CONSTRAINT fk_id_assunto FOREIGN KEY(IdAssunto)
	REFERENCES Assunto(IdAssunto)ON DELETE CASCADE,
CONSTRAINT verifica_preco CHECK(Pre�oLivro >= 0)
);

-- Inserir dados na tabela Livro
INSERT INTO Livro(NomeLivro, ISBN13, DataPub, Pre�oLivro, NumeroPaginas, IdEditora , IdAssunto)
VALUES 
	('A arte da Eletr�nica', '9788582604342', '20170308', 300.74, 1160, 3, 24),
	('Vinte mil L�guas Submarinas', '9788582850022', '20140916', 24.50, 448, 1, 16), --J�lio Verne
	('O investidor Inteligente', '9788595080805', '20160125', 79.90, 450, 7, 6); --Benjamin Graham

-- Verifica��o
SELECT * FROM Livro;

-- Inserir em lote (bulk) a partir de arquivo CSV
INSERT INTO Livro (NomeLivro, ISBN13, DataPub, Pre�oLivro, NumeroPaginas, IdEditora, IdAssunto)
SELECT
	NomeLivro, ISBN13, DataPub, Pre�oLivro, NumeroPaginas, IdEditora, IdAssunto
FROM OPENROWSET(
	 BULK 'C:\Users\lucas\OneDrive\�rea de Trabalho\SQL\Livros.CSV',
	 FORMATFILE = 'C:\Users\lucas\OneDrive\�rea de Trabalho\SQL\Formato.xml',
	 CODEPAGE = '65001', -- UTF-8
	 FIRSTROW = 2
) AS LivrosCSV;


--------------------------------------------------------------------------------------------------

--Tabela associativa que armazena ids
CREATE TABLE LivroAutor(
IdLivro SMALLINT NOT NULL,
IdAutor SMALLINT NOT NULL,
CONSTRAINT fk_id_livros FOREIGN KEY(IdLivro) REFERENCES Livro(IdLivro),
CONSTRAINT fk_id_autores FOREIGN KEY(IdAutor) REFERENCES Autor(IdAutor),
CONSTRAINT pk_livro_autor PRIMARY KEY(IdLivro, IdAutor) --Chave prim�ria composta
);


-- Inserir dados na tabela LivroAutor
INSERT INTO LivroAutor(IdLivro, IdAutor)
VALUES
(100,15),
(100,16),
(101,27),
(102,26),
(103,41),
(104,24),
(105,32),
(106,20),
(107,27),
(108,1),
(109,22),
(110,10),
(111,21),
(112,5),
(113,10),
(114,8),
(115,18),
(115,19),
(116,31),
(117,22);

-- Verifica��o
SELECT * FROM LivroAutor;

-- Verifica��o com INNER JOIN
SELECT NomeLivro, NomeAutor, SobrenomeAutor
FROM Livro
INNER JOIN LivroAutor
	ON Livro.IdLivro = LivroAutor.IdLivro
INNER JOIN Autor
	ON Autor.IdAutor = LivroAutor.IdAutor
ORDER BY NomeLivro;

--------------------------------------------------------------------------------------------------

-- Consultas Simples com SELECT

/*
Sintaxe:
SELECT coluna(s) FROM tabela;
*/
SELECT NomeLivro FROM Livro; -- Uma coluna

SELECT SobrenomeAutor FROM Autor; -- Uma coluna

SELECT * FROM Autor; -- Todas as colunas

SELECT NomeLivro, ISBN13, Pre�oLivro -- 3 Colunas
FROM Livro;

SELECT DISTINCT IdEditora
FROM Livro;


-- SELECT INTO: Criar uma tabela com dados de outra
/*
SELECT coluna(s)
INTO nova_tabela
FROM tabela_atual;
*/
SELECT NomeLivro, ISBN13
INTO LivroISBN
FROM Livro;

SELECT * FROM LivroISBN;

DROP TABLE LivroISBN;

--------------------------------------------------------------------------------------------------
--Ver todas as tabelas do banco
SELECT name FROM Biblioteca.sys.tables;

--------------------------------------------------------------------------------------------------

-- Gerenciamento de Tabelas
-- ALTER, DROP, RENAME

-- ALTER TABLE NomeTabela;
-- ADD / ALTER / DROP Objeto;

-- Adicionar uma nova coluna a uma tabela existente.
ALTER TABLE Livro
ADD Edi��o SMALLINT;
--------------------------------------------------------------------------------------------------
-- Alterar o tipo de dado de uma coluna:
ALTER TABLE Livro
ALTER COLUMN Edi��o Tinyint;
--------------------------------------------------------------------------------------------------
-- Adicionar chave prim�ria(s� funciona se a tabela n�o tiver uma chave prim�ria j� definida anteriormente)
ALTER TABLE NomeTabela
ADD PRIMARY KEY (Coluna);

--------------------------------------------------------------------------------------------------

-- Excluir uma constraint de uma coluna - (pode ser uma chave prim�ria por exemplo)
ALTER TABLE NomeTabela
DROP CONSTRAINT NomeConstraint;

--------------------------------------------------------------------------------------------------
-- Verificar o nome das constraints de uma tabela:
sp_help Livro;

--------------------------------------------------------------------------------------------------

-- Excluir uma coluna de uma tabela
ALTER TABLE Livro
DROP COLUMN Edi��o;

--------------------------------------------------------------------------------------------------

-- Excluir uma tabela: DROP TABLE
DROP TABLE NomeTabela;

--------------------------------------------------------------------------------------------------

-- Renomear uma tabela: sp_rename
--  sp_rename 'nome atual', 'novo nome';
sp_rename 'tbl_livros', 'Livro';
--------------------------------------------------------------------------------------------------


-- EXERC�CIOS:
-- 1 - Retornar os nomes dos livros, pre�os e datas de publica��o:
SELECT NomeLivro, Pre�oLivro, DataPub
FROM Livro;

-- 2 - Mostrar apenas os sobrenomes dos autores:
SELECT SobreNomeAutor
FROM Autor;

-- 3 - Retornar a lista de assunto:
SELECT NomeAssunto
FROM Assunto;

-- 4 - Mostrar a lista de editoras com os IDs de cada uma, com a coluna de nomes de editoras � esquerda da coluna de IDs:
SELECT NomeEditora, IdEditora
FROM Editora;

-- 5 - Mostrar os IDs de assuntos dos quais existem livros cadastrados na tabela de livros, sem repeti��o:
SELECT DISTINCT IdAssunto
FROM Livro;

-- 6 - Criar uma nova tabela chamada "LivrosFiccao" que contenha todos os dados dos livros relacionados ao assunto de ID1:
SELECT *   
INTO LivrosFiccao
FROM Livro
WHERE IdAssunto = 1;

--Verifica��o
SELECT * FROM LivrosFiccao;

DROP TABLE LivrosFiccao; -- Tabela j� exclu�da
--------------------------------------------------------------------------------------------------

-- ORDENA��O DE RESULTADOS EM CONSULTAS SQL:
-- Cl�usula ORDER BY

/* Sintaxe
SELECT coluna
FROM tabela
ORDERBY coluna_a_ordenar [ASC | DESC]
*/

--EXEMPLOS

-- Exemplo 1: Selecionando todos os livros e ordenando pelo nome do livro em ordem alfab�tica crescente
SELECT * FROM Livro
ORDER BY NomeLivro; 
-- Ordena todos os registros da tabela "Livro" pela coluna "NomeLivro" de forma crescente (ordem alfab�tica por padr�o)

--------------------------------------------------------------------------------------------------

-- Exemplo 2: Selecionando apenas o nome do livro e o ID da editora, e ordenando pelos IDs das editoras em ordem crescente
SELECT NomeLivro, IdEditora
FROM Livro
ORDER BY IdEditora; 
-- Ordena os resultados pela coluna "IdEditora" de forma crescente, mostrando apenas o nome do livro e o ID da editora

--------------------------------------------------------------------------------------------------

-- Exemplo 3: Selecionando nome do livro e pre�o, e ordenando pelos pre�os em ordem decrescente (do maior para o menor)
SELECT NomeLivro, Pre�oLivro
FROM Livro
ORDER BY Pre�oLivro DESC; 
-- Ordena os livros pelo "Pre�oLivro" de forma decrescente (do maior pre�o para o menor)

--------------------------------------------------------------------------------------------------

-- Exemplo 4: Selecionando nome do livro, pre�o e ID da editora, ordenando primeiro pelo ID da editora em ordem crescente e depois pelo pre�o em ordem crescente
SELECT NomeLivro, Pre�oLivro, IdEditora
FROM Livro
ORDER BY IdEditora, Pre�oLivro ASC; 
-- Ordena os resultados pela coluna "IdEditora" em ordem crescente, e para os livros com o mesmo "IdEditora", ordena pelo "Pre�oLivro" tamb�m de forma crescente

--------------------------------------------------------------------------------------------------

-- Exemplo 5: Selecionando nome do livro, pre�o e ID da editora, ordenando primeiro pelo ID da editora em ordem crescente e depois pelo pre�o em ordem decrescente
SELECT NomeLivro, Pre�oLivro, IdEditora
FROM Livro
ORDER BY IdEditora ASC, Pre�oLivro DESC; 
-- Ordena os resultados pela coluna "IdEditora" em ordem crescente, e para os livros com o mesmo "IdEditora", ordena pelo "Pre�oLivro" de forma decrescente (do maior para o menor)
--___________________________________________________________________________________________________________________________________________________________________________________

--RESTRI��O DE RESUlTADOS: SELECT TOP
/* Sintaxe
SELECT TOP (n�mero |PERCENT) colunas
FROM tabela
ORDER BY 
*/

-- EXEMPLOS

-- Exemplo 1: Selecionando os 2 primeiros livros, ordenados pelo nome de forma crescente
SELECT TOP(2) NomeLivro
FROM Livro
ORDER BY NomeLivro; 
-- Retorna os 2 primeiros livros (pelo nome), ordenados em ordem alfab�tica crescente

--------------------------------------------------------------------------------------------------

-- Exemplo 2: Selecionando os primeiros 15% dos livros, ordenados pelo nome de forma crescente
SELECT TOP (15) PERCENT NomeLivro
FROM Livro
ORDER BY NomeLivro; 
-- Retorna os 15% dos livros (em rela��o ao total), ordenados de forma crescente pelo nome

--------------------------------------------------------------------------------------------------

-- Exemplo 3: Selecionando os 3 primeiros livros, ordenados pelo nome de forma decrescente
SELECT TOP (3) NomeLivro
FROM Livro
ORDER BY NomeLivro DESC;
-- Retorna os 3 primeiros livros, ordenados em ordem alfab�tica **decrescente**

--------------------------------------------------------------------------------------------------

-- Exemplo 4: Selecionando os 4 primeiros livros e seus pre�os, ordenados pelo pre�o de forma decrescente
SELECT TOP (4) NomeLivro, Pre�oLivro
FROM Livro
ORDER BY Pre�oLivro DESC;
-- Retorna os 4 livros com os maiores pre�os (ordenados de forma decrescente)

--------------------------------------------------------------------------------------------------

-- Exemplo 5: Selecionando os 3 primeiros livros com empates, ordenados pelo ID do assunto de forma decrescente
SELECT TOP (3) WITH TIES NomeLivro, IdAssunto
FROM Livro
ORDER BY IdAssunto DESC;
-- Retorna os 3 livros mais altos no ID do assunto, mas inclui livros com o mesmo ID do 3� livro (empates)
--__________________________________________________________________________________________________________________

-- FILTRAR  RESULTADOS DE CONSULTAS COM WHERE
/*
Sintaxe
SELECT colunas
FROM tabela
WHERE coluna [operador] valor;
[ORDER BY]
*/

--EXEMPLOS

-- Exemplo 1: Seleciona os nomes e datas de publica��o dos livros da editora com IdEditora igual a 3
SELECT NomeLivro, DataPub
FROM Livro
WHERE IdEditora = 3; 
-- Filtra os livros cuja editora tem o ID igual a 3 e retorna o nome e data de publica��o.

--------------------------------------------------------------------------------------------------

-- Exemplo 2: Seleciona os IDs e nomes dos autores cujo sobrenome � 'Verne'
SELECT IdAutor, NomeAutor
FROM Autor
WHERE SobreNomeAutor = 'Verne'; 
-- Filtra os autores cujo sobrenome � 'Verne' e retorna o ID e nome dos autores.

--------------------------------------------------------------------------------------------------

-- Exemplo 3: Seleciona os nomes e pre�os dos livros cujo pre�o � maior que 100.00, ordenando os resultados por pre�o crescente
SELECT NomeLivro, Pre�oLivro
FROM Livro
WHERE Pre�oLivro > 100.00
ORDER BY Pre�oLivro; 
-- Filtra os livros cujo pre�o � superior a 100.00 e os ordena de forma crescente pelo pre�o.

--------------------------------------------------------------------------------------------------

/*
CL�USULA WHERE: SUBCONSULTAS
PROBLEMA: Como retornar nomes de livros e datas de publica��o dos livros publicados pela editora Aleph,
sem saber o ID da editora? Os nomes das editoras n�o est�o na tabela de livros. O que fazer?
SOLU��O: Utilizar subconsulta para encontrar o ID da editora Aleph e retornar os livros associados a esse ID.
*/

-- Exemplo de subconsulta:
SELECT NomeLivro, DataPub
FROM Livro
WHERE IdEditora = (
     SELECT IdEditora
	 FROM Editora	
	 WHERE NomeEditora = 'Aleph'
)
ORDER BY NomeLivro; 
-- A subconsulta dentro do `WHERE` encontra o ID da editora 'Aleph' e retorna os livros dessa editora, ordenados por nome.
--_________________________________________________________________________________________________________________________

--EXCLUS�O DE REGISTROS (LINHAS): DELETE FROM
/*SINTAXE
DELETE FROM tabela
WHERE coluna = valor;
*/

/*Exemplos mostrando o comportamento do comando e como ele funciona em
colunas com identity.
*/

--Deletando um assunto:
DELETE FROM Assunto
WHERE NomeAssunto = 'Policial';

--Inserindo um assunto:
INSERT INTO Assunto (NomeAssunto)
VALUES ('Policial');

--Verifica��o:
SELECT * FROM Assunto;
--_________________________________________________________________________________________________________________________

-- TRUNCATE TABLE: LIMPAR UMA TABELA
/*SINTAXE
TRUNCATE TABLE nome_tabela;
*/

--Criar tabela de teste paa testar o truncate
CREATE TABLE Teste (
  IdTeste SMALLINT PRIMARY KEY IDENTITY,
  ValorTeste SMALLINT NOT NULL
 );

--Rotina para inserir dados na tabela
DECLARE @Contador INT = 1

WHILE @Contador <= 100
BEGIN
   INSERT INTO Teste (ValorTeste) VALUES (@Contador * 3)
   SET @Contador = @Contador + 1
END

SELECT * FROM Teste;

--LIMPAR A TABELA E RESETAR O IDENTITY
TRUNCATE TABLE Teste;

--VERIFICAR O VALOR ATUAL DE IDENTITY
SELECT IDENT_CURRENT('Teste');
--_________________________________________________________________________________________________________________________

-- ATUALIZAR REGISTROS: CL�USULA UPDATE
/* SINTAXE
UPDATE tabela
SET coluna = novo_valor
WHERE coluna = filtro;
*/

-- Exemplo 1: Seleciona dados da tabela Livro
SELECT IdLivro, NomeLivro, Pre�oLivro, NumeroPaginas 
FROM Livro;  -- Seleciona as colunas IdLivro, NomeLivro, Pre�oLivro e NumeroPaginas da tabela Livro


-- Exemplo 2: Atualiza o nome de um livro com IdLivro igual a 116
UPDATE Livro
SET NomeLivro = 'Eu, Rob�'  -- Altera o nome do livro para 'Eu, Rob�'
WHERE IdLivro = 116;  -- A condi��o WHERE garante que apenas o livro com IdLivro igual a 116 seja atualizado


-- Exemplo 3: Atualiza o pre�o de um livro com IdLivro igual a 105
UPDATE Livro
SET Pre�oLivro = 60.00  -- Altera o pre�o do livro para 60.00
WHERE IdLivro = 105;  -- A condi��o WHERE garante que apenas o livro com IdLivro igual a 105 seja atualizado


-- Exemplo 4: Aumenta o pre�o de um livro com IdLivro igual a 105 em 10%
UPDATE Livro
SET Pre�oLivro = Pre�oLivro * 1.1  -- O pre�o do livro ser� multiplicado por 1.1 (aumentando em 10%)
WHERE IdLivro = 105;  -- A condi��o WHERE garante que apenas o livro com IdLivro igual a 105 seja atualizado


-- Exemplo 5: Reduz o pre�o de um livro com IdLivro igual a 105 em 20%
UPDATE Livro
SET Pre�oLivro = Pre�oLivro * 0.8  -- O pre�o do livro ser� multiplicado por 0.8 (diminuindo em 20%)
WHERE IdLivro = 105;  -- A condi��o WHERE garante que apenas o livro com IdLivro igual a 105 seja atualizado


-- Exemplo 6: Atualiza o pre�o e o n�mero de p�ginas de um livro com IdLivro igual a 105
UPDATE Livro
SET Pre�oLivro = 60.00,  -- Altera o pre�o do livro para 60.00
    NumeroPaginas = 320  -- Altera o n�mero de p�ginas do livro para 320
WHERE IdLivro = 105;  -- A condi��o WHERE garante que apenas o livro com IdLivro igual a 105 seja atualizado
--_________________________________________________________________________________________________________________________

-- NOMES ALTERNATIVOS: AS (ALIAS) 
/* SINTAXE
SELECT coluna1 [AS] nome_alternativo1
FROM tabela [AS] nome_alternativo_tabela
*/
/*
a palavra as � opcional, mas � recomendada pelo professor a ser usada
OBS elas dentro dos colchetes somente para mostrar a sua opcionalidade,
mas na sintaxe os colchetes n�o s�o usados.
*/

-- Seleciona o campo "NomeLivro" da tabela "Livro" e o renomeia como "Livros"
SELECT NomeLivro AS Livros 
FROM Livro;

-- Seleciona o campo "NomeLivro" da tabela "Livro" e o renomeia como "Livros", sem usar a palavra-chave "AS"
SELECT NomeLivro  Livros 
FROM Livro;

-- Seleciona "NomeAutor" e "SobreNomeAutor" da tabela "Autor", renomeando para "Nome" e "Sobrenome" respectivamente
SELECT NomeAutor AS Nome, A.SobreNomeAutor AS Sobrenome 
FROM Autor AS A;

-- Seleciona os 3 livros mais caros e seus pre�os, ordenando pelo pre�o de forma decrescente
SELECT TOP(3) NomeLivro AS 'Livros mais caros', Pre�oLivro AS 'Pre�o do Livro' 
FROM Livro AS L 
ORDER BY 'Pre�o do Livro' DESC;

--___________________________________________________________________________________________________________________

-- FILTROS COMBINADOS: OPERADORES L�GICOS AND, OR, NOT
/* AND
OR
NOT
*/

-- Seleciona todos os livros com IdLivro entre 102 e 108 (excluindo 102 e 108)
SELECT * FROM Livro
WHERE IdLivro > 102 AND IdLivro < 108;

-- Seleciona todos os livros onde IdLivro � maior que 110 ou IdEditora � menor que 4
SELECT * FROM Livro
WHERE IdLivro > 110 OR IdEditora < 4;

-- Seleciona todos os livros onde IdLivro � maior que 110 ou IdEditora n�o � menor que 4 (ou seja, IdEditora � 4 ou maior)
SELECT * FROM Livro
WHERE IdLivro > 110 OR NOT IdEditora < 4;



-- BETWEEN: SELE��O DE INTERVALOS
/*
SINTAXE:
SELECT colunas
FROM tabela
WHERE coluna BETWEEN valor1 AND valor2;
*/

-- Seleciona todos os livros publicados entre 7 de maio de 2004 e 7 de maio de 2014
SELECT * FROM Livro
WHERE DataPub BETWEEN '20040507' AND '20140507';

-- Seleciona os livros com pre�o entre 50.00 e 100.00, renomeando as colunas para 'Livro' e 'Pre�o'
SELECT NomeLivro AS Livro, Pre�oLivro AS Pre�o
FROM Livro
WHERE Pre�oLivro BETWEEN 50.00 AND 100.00;

-- Seleciona os livros com pre�o maior ou igual a 20.00, e publicados entre 20 de junho de 2005 e 20 de junho de 2010,
-- ou publicados entre 1� de janeiro de 2016 e 1� de janeiro de 2020, ordenados por DataPub em ordem decrescente
SELECT NomeLivro, DataPub, Pre�oLivro
FROM Livro
WHERE Pre�oLivro >= 20.00 
AND DataPub BETWEEN '20050620' AND '20100620'
OR DataPub BETWEEN '20160101' AND '20200101'
ORDER BY DataPub DESC;
--______________________________________________________________________________________________________________________

/*
COMBINAR CONSULTAS COM OPERADOR UNION
SINTAXE:
SELECT colunas FOM tabela1
UNION
SELECT clunas FROM tabela2
*/

--EXEMPLO 01
SELECT NomeAutor Nome, 'Autor' AS Tipo FROM Autor
UNION 
SELECT NomeEditora Nome, 'Editora' AS Tipo FROM Editora;
