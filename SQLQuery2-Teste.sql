-- Criando o banco de dados BibliotecaDB
CREATE DATABASE BibliotecaDB;
GO

-- Usando o banco de dados rec�m-criado
USE BibliotecaDB;
GO


-- Criando a tabela Autores
CREATE TABLE Autores (
    AutorID INT PRIMARY KEY IDENTITY(1,1),  -- Chave prim�ria com incremento autom�tico
    Nome NVARCHAR(100) NOT NULL,             -- Nome do autor
    Nacionalidade NVARCHAR(50)              -- Nacionalidade do autor
);
GO


-- Criando a tabela Livros
CREATE TABLE Livros (
    LivroID INT PRIMARY KEY IDENTITY(1,1),     -- Chave prim�ria com incremento autom�tico
    Titulo NVARCHAR(200) NOT NULL,              -- T�tulo do livro
    AutorID INT,                                -- Chave estrangeira para a tabela Autores
    AnoPublicacao INT,                          -- Ano de publica��o
    Genero NVARCHAR(50),                        -- G�nero do livro (ex: Fic��o, Hist�ria, etc.)
    CONSTRAINT FK_Autor FOREIGN KEY (AutorID)  -- Chave estrangeira para o Autor
        REFERENCES Autores(AutorID)
);
GO


-- Criando a tabela Emprestimos
CREATE TABLE Emprestimos (
    EmprestimoID INT PRIMARY KEY IDENTITY(1,1), -- Chave prim�ria com incremento autom�tico
    LivroID INT,                                  -- Chave estrangeira para a tabela Livros
    DataEmprestimo DATE NOT NULL,                 -- Data de empr�stimo
    DataDevolucao DATE,                           -- Data de devolu��o
    Usuario NVARCHAR(100),                        -- Nome do usu�rio que pegou o livro
    CONSTRAINT FK_Livro FOREIGN KEY (LivroID)    -- Chave estrangeira para o Livro
        REFERENCES Livros(LivroID)
);
GO

-- Inserindo autores
INSERT INTO Autores (Nome, Nacionalidade)
VALUES 
    ('J.K. Rowling', 'Brit�nica'),
    ('George Orwell', 'Brit�nica'),
    ('J.R.R. Tolkien', 'Brit�nica'),
    ('Gabriel Garc�a M�rquez', 'Colombiana');
GO

-- Inserindo livros
INSERT INTO Livros (Titulo, AutorID, AnoPublicacao, Genero)
VALUES 
    ('Harry Potter e a Pedra Filosofal', 1, 1997, 'Fantasia'),
    ('1984', 2, 1949, 'Distopia'),
    ('O Hobbit', 3, 1937, 'Fantasia'),
    ('Cem Anos de Solid�o', 4, 1967, 'Realismo M�gico');
GO

-- Inserindo empr�stimos
INSERT INTO Emprestimos (LivroID, DataEmprestimo, DataDevolucao, Usuario)
VALUES 
    (1, '2024-11-01', '2024-11-15', 'Lucas Silva'),
    (2, '2024-11-02', '2024-11-16', 'Mariana Costa'),
    (3, '2024-11-03', '2024-11-17', 'Carlos Pereira'),
    (4, '2024-11-04', '2024-11-18', 'Ana Oliveira');
GO





