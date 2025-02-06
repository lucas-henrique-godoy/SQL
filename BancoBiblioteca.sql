CREATE DATABASE Biblioteca;

--------------------------------------------------------------------------------------------------

--Procedimento armazenado que trás informações sobre uma tabela.
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
	('José', 'Saramago'), ('Richard', 'Siverman'), ('Robert', 'Byrnes'),
	('Jay', 'Ts'), ('Robert', 'Eckstein'), ('Paul', 'Horowitz'),
	('Winfield', 'Hill'), ('Joel', 'Murach'), ('Paul', 'Scherz'),
	('Simon', 'Monk'), ('George', 'Orwell'), ('Ítalo', 'Calvino'),
	('Machado', 'de Assis'), ('Oliver', 'Sacks'), ('Ray', 'Bradbury'),
	('Walter', 'Isaacson'), ('Benjamin', 'Graham'), ('Júlio', 'Verne'),
	('Marcelo', 'Gleiser'), ('Harri', 'Lorenzi'), ('Humphrey', 'Carpenter'),
	('Isaac', 'Asimov'), ('Aldous', 'Huxley'), ('Arthur', 'Conan Doyle'),
	('Blaise', 'Pascal'), ('Jostein', 'Gaarder'), ('Stephen', 'Hawking'),
	('Stephen', 'Jay Gould'), ('Neil', 'De Grasse Tysn'), ('Charles', 'Darwin'),
	('Alan', 'Turing'), ('Arthur', 'C. Clarke');

-- Verificaçao
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
	('O´Reilly');

-- Mai editoras
INSERT INTO Editora(NomeEditora)
VALUES
	('Aleph'), ('Microsoft Press'),
	('Wiley'), ('HarperCollins'),
	('Érica'), ('Novatec'),
	('McGraw-Hill'), ('Apress'),
	('Francisco Alves'), ('Sybex'),
	('Globo'), ('Comapanhia das Letras'),
	('Morro Branco'), ('Penguin Books'), ('Martin Claret'),
	('Record'), ('Springer'), ('Melhoramentos'),
	('Oxford'), ('Taschen'),('Ediouro'), ('Bookman');

-- Verificação
SELECT * FROM Editora;

--------------------------------------------------------------------------------------------------
CREATE TABLE Assunto(
IdAssunto TINYINT PRIMARY KEY IDENTITY,
NomeAssunto VARCHAR(25) NOT NULL
);

-- Inserir dados na tabela Assunto
INSERT INTO Assunto (NomeAssunto)
VALUES
    ('Ficção Científica'),
    ('Botânica'),
    ('Eletrônica'),
    ('Matemática'),
    ('Aventura'),
    ('Romance'),
    ('Finanças'),
    ('Gastronomia'),
    ('Terror'),
    ('Administração'),
    ('Informática'),
    ('Suspense');

-- Verificação
SELECT * FROM Assunto;

--------------------------------------------------------------------------------------------------
CREATE TABLE Livro(
IdLivro SMALLINT NOT NULL PRIMARY KEY IDENTITY(100,1),
NomeLivro VARCHAR(70) NOT NULL,
ISBN13 CHAR(13) UNIQUE NOT NULL,
DataPub DATE,
PreçoLivro MONEY NOT NULL,
NumeroPaginas SMALLINT NOT NULL,
IdEditora SMALLINT NOT NULL, --chave estrangeira
IdAssunto TINYINT NOT NULL,  --chave estrangeira
CONSTRAINT fk_id_editora FOREIGN KEY(IdEditora)
	REFERENCES Editora(IdEditora) ON DELETE CASCADE,
CONSTRAINT fk_id_assunto FOREIGN KEY(IdAssunto)
	REFERENCES Assunto(IdAssunto)ON DELETE CASCADE,
CONSTRAINT verifica_preco CHECK(PreçoLivro >= 0)
);

-- Inserir dados na tabela Livro
INSERT INTO Livro(NomeLivro, ISBN13, DataPub, PreçoLivro, NumeroPaginas, IdEditora , IdAssunto)
VALUES 
	('A arte da Eletrônica', '9788582604342', '20170308', 300.74, 1160, 3, 24),
	('Vinte mil Léguas Submarinas', '9788582850022', '20140916', 24.50, 448, 1, 16), --Júlio Verne
	('O investidor Inteligente', '9788595080805', '20160125', 79.90, 450, 7, 6); --Benjamin Graham

-- Verificação
SELECT * FROM Livro;

-- Inserir em lote (bulk) a partir de arquivo CSV
INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PreçoLivro, NumeroPaginas, IdEditora, IdAssunto)
SELECT
	NomeLivro, ISBN13, DataPub, PreçoLivro, NumeroPaginas, IdEditora, IdAssunto
FROM OPENROWSET(
	 BULK 'C:\Users\lucasgodoy\Desktop\SQL\Livros.CSV',
	 FORMATFILE = 'C:\Users\lucasgodoy\Desktop\SQL\Formato.xml',
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
CONSTRAINT pk_livro_autor PRIMARY KEY(IdLivro, IdAutor) --Chave primária composta
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

-- Verificação
SELECT * FROM LivroAutor;

-- Verificação com INNER JOIN
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
SELECT NomeLivro FROM Livro;

SELECT SobrenomeAutor FROM Autor;

SELECT * FROM Autor;

SELECT NomeLivro, PreçoLivro
FROM Livro;


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
ADD Edição SMALLINT;
--------------------------------------------------------------------------------------------------
-- Alterar o tipo de dado de uma coluna:
ALTER TABLE Livro
ALTER COLUMN Edição Tinyint;
--------------------------------------------------------------------------------------------------
-- Adicionar chave primária(só funciona se a tabela não tiver uma chave primária já definida anteriormente)
ALTER TABLE NomeTabela
ADD PRIMARY KEY (Coluna);

--------------------------------------------------------------------------------------------------

-- Excluir uma constraint de uma coluna - (pode ser uma chave primária por exemplo)
ALTER TABLE NomeTabela
DROP CONSTRAINT NomeConstraint;

--------------------------------------------------------------------------------------------------
-- Verificar o nome das constraints de uma tabela:
sp_help Livro;

--------------------------------------------------------------------------------------------------

-- Excluir uma coluna de uma tabela
ALTER TABLE Livro
DROP COLUMN Edição;

--------------------------------------------------------------------------------------------------

-- Excluir uma tabela: DROP TABLE
DROP TABLE NomeTabela;

--------------------------------------------------------------------------------------------------

-- Renomear uma tabela: sp_rename
--  sp_rename 'nome atual', 'novo nome';
sp_rename 'tbl_livros', 'Livro';
--------------------------------------------------------------------------------------------------



