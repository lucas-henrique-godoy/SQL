CREATE DATABASE Biblioteca;

CREATE TABLE Autor(
IdAutor SMALLINT IDENTITY,
NomeAutor VARCHAR(50) NOT NULL,
SobreNomeAutor VARCHAR(60) NOT NULL,
CONSTRAINT pk_id_autor PRIMARY KEY(IdAutor)
);

--Procedimento armazenadoque trás informações sobre a tabela.
sp_help Autor;

CREATE TABLE Editora(
IdEditora SMALLINT PRIMARY KEY IDENTITY,
NomeEditora VARCHAR(50) NOT NULL
);

CREATE TABLE Assunto(
IdAssunto TINYINT PRIMARY KEY IDENTITY,
NomeAssunto VARCHAR(25) NOT NULL
);

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


--Tabela associativa
CREATE TABLE LivroAutor(

);







