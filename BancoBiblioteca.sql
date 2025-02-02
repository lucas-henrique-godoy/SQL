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

--------------------------------------------------------------------------------------------------

--Tabela associativa que armazena ids
CREATE TABLE LivroAutor(
IdLivro SMALLINT NOT NULL,
IdAutor SMALLINT NOT NULL,
CONSTRAINT fk_id_livros FOREIGN KEY(IdLivro) REFERENCES Livro(IdLivro),
CONSTRAINT fk_id_autores FOREIGN KEY(IdAutor) REFERENCES Autor(IdAutor),
CONSTRAINT pk_livro_autor PRIMARY KEY(IdLivro, IdAutor) --Chave primária composta
);

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



