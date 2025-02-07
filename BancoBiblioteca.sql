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
