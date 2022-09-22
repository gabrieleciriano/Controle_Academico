CREATE DATABASE RegistroAluno;

USE RegistroAluno;

/* CRIANDO A TABELA DE REGISTRO DOS ALUNOS CONFORME A MODELAGEM */
CREATE TABLE Aluno (
	RA int NOT NULL,
	Nome varchar(50) NOT NULL

	CONSTRAINT PK_RA PRIMARY KEY (RA)
);

/* CRIANDO A TABELA DE REGISTRO DE DISCIPLINAS CONFORME A MODELAGEM */
CREATE TABLE Disciplina (
	Sigla char(3) NOT NULL,
	Nome varchar(30) NOT NULL,
	Carga_Horaria  int NOT NULL

	CONSTRAINT PK_SIGLA PRIMARY KEY (Sigla)
);

/* CRIAÇÃO DA TABELA DE RELACIONAMENTO - MATRICULA */
CREATE TABLE Matricula(
	RA int  NOT NULL,
	Sigla char(3) NOT NULL,
	Data_Ano int NOT NULL,
	Data_Semestre int NOT NULL,
	Falta int, 
	Nota_N1 float,
	Nota_N2 float,
	Nota_Sub float,
	Nota_Media float,
	Situacao varchar(20),	
	FOREIGN KEY (RA) REFERENCES Aluno(RA),
	FOREIGN KEY (SIGLA) REFERENCES Disciplina(Sigla),
	
	CONSTRAINT PK_Matricula PRIMARY KEY (RA, Sigla, Data_Ano, Data_Semestre)		 		
);

/*trigger que preenche todos os campos atualizando o cadastro do aluno */
CREATE TRIGGER TRG_Atualizar_Matricula
ON Matricula
AFTER UPDATE
AS
IF (UPDATE(Nota_N1) OR UPDATE(Nota_N2) OR UPDATE(Nota_Sub))
BEGIN
DECLARE @RA int ,
		@Sigla char(3),
		@Nota1 float ,
		@Nota2 float,
		@NotaSub float,
		@Nota_Media float,
		@Falta int,
		@Carga_Horaria int,
		@Data_Ano int,
		@Data_Semestre int

	SELECT @Sigla = Sigla, @RA = RA, @Data_Ano = Data_Ano, @Data_Semestre = Data_Semestre FROM INSERTED;
	SELECT @Nota_Media = Nota_Media, @Nota1 = Nota_N1, @Nota2 = Nota_N2, @NotaSub = Nota_Sub, @Falta = Falta FROM Matricula WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;
	SELECT @Carga_Horaria = Carga_Horaria FROM Disciplina WHERE Sigla = @Sigla;

	IF(@NotaSub IS NOT NULL AND (@NotaSub > @Nota1 OR @NotaSub > @Nota2) AND @Nota1 > @Nota2)	
		SET @Nota_Media = ((@NotaSub + @Nota1) / 2);
		 
	ELSE IF (@NotaSub IS NOT NULL AND @NotaSub > @Nota1 OR @NotaSub > @Nota2) AND @Nota2 >= @Nota1
		SET @Nota_Media = ((@NotaSub + @Nota2) / 2);

	ELSE
		SET @Nota_Media = ((@Nota1 + @Nota2) / 2);

	IF(@Falta >= ((0.25 *(@Carga_Horaria))))
	UPDATE Matricula SET Situacao = 'REPROVADO POR FALTA', Nota_Media = @Nota_Media  WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;

	ELSE IF (@Nota_Media >= 5)
	UPDATE Matricula SET Situacao = 'APROVADO', Nota_Media = @Nota_Media WHERE RA = RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;

	ELSE
	UPDATE Matricula SET Situacao = 'REPROVADO POR NOTA', Nota_Media = @Nota_Media WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;

END


SELECT * FROM Matricula


/* POPULANDO A TABELA DO REGISTRO DOS ALUNOS */
INSERT INTO Aluno (RA, Nome)
VALUES (01, 'Baratao');

INSERT INTO Aluno (RA, Nome)
VALUES (02, 'Gabriele');

INSERT INTO Aluno (RA, Nome)
VALUES (03, 'Felipe');

INSERT INTO Aluno (RA, Nome)
VALUES (04, 'Alexandre');

INSERT INTO Aluno (RA, Nome)
VALUES (05, 'Fernanda');

INSERT INTO Aluno (RA, Nome)
VALUES (06, 'Thalya');

INSERT INTO Aluno (RA, Nome)
VALUES (07, 'Louise');

INSERT INTO Aluno (RA, Nome)
VALUES (08, 'Moranguinho');

INSERT INTO Aluno (RA, Nome)
VALUES (09, 'Jhow');

INSERT INTO Aluno (RA, Nome)
VALUES (10, 'Julia');

SELECT * FROM Aluno


/* POPULANDO A TABELA DE REGISTRO DAS DISCIPLINAS */
INSERT INTO Disciplina(Sigla, Nome, Carga_Horaria)
VALUES('CA', 'Calculo', 100),
		('ES', 'Estatistica', 40),
		('ED', 'Estrutura de Dados', 30),
		('LPD', 'Logica Programacao', 80),
		('ADM', 'Administracao', 80),	
		('CE', 'Comunicacao e Expressao', 30),	
		('LBH', 'Laboratorio Hardware', 40),	
		('AOC', 'Arquitetura Computadores', 30),	
		('FIS', 'Fisica', 80),	
		('MTD', 'Matematica Discreta', 80),
		('CON', 'Contabilidade', 40),
		('PIN', 'Processos Industriais', 40),
		('GEA', 'Gestao Ambiental', 40),
		('EMP', 'Empreendedorismo', 20),
		('IA', 'Inteligencia Artificial',80);

SELECT * FROM Disciplina

/* POPULANDO A TABELA DE MATRICULA INSERINDO OS VALORES */ /* SERIAM APENAS DOIS SEMESTRES*/
INSERT INTO Matricula (RA, Sigla, Data_Ano, Data_Semestre, Falta)
VALUES (01, 'LPD', 2021,2, 0 ),
		(01, 'CA', 2021, 2, 0),
		(02, 'CA', 2021, 1, 0),
		(02, 'LPD', 2021, 1, 0),
		(03, 'ED', 2021, 2, 0),
		(03, 'ES', 2021, 2, 0),
		(04, 'AOC', 2021, 1, 0),
		(04, 'IA', 2021, 1, 0),
		(05, 'CE', 2021, 2, 0),
		(05, 'PIN', 2021, 2, 0),
		(06, 'GEA', 2021, 2, 0),
		(06, 'CON', 2021, 2, 0),
		(07, 'CA', 2021, 1, 0),
		(07, 'LPD', 2021, 1, 0),
		(08, 'FIS', 2021, 1, 0),
		(08, 'MTD', 2021, 1, 0),
		(09, 'LBH', 2021, 2, 0),
		(09, 'FIS', 2021, 2, 0),
		(10, 'EMP', 2021, 2, 0),
		(10, 'IA', 2021, 2, 0);

SELECT * FROM Matricula



/*UPDATE NAS FALTAS*/
UPDATE Matricula set Falta = 19 where RA = 01 And Sigla = 'GEA';
UPDATE Matricula set Falta = 5  where RA = 01 And Sigla = 'CA';

UPDATE Matricula set Falta = 20 where RA = 02 And Sigla = 'LPD';
UPDATE Matricula set Falta = 3 where RA = 02 And Sigla = 'CA';

UPDATE Matricula set Falta = 15 where RA = 03 And Sigla = 'ED';
UPDATE Matricula set Falta = 11 where RA = 03 And Sigla = 'ES';

UPDATE Matricula set Falta = 3 where RA = 04 And Sigla = 'AOC';
UPDATE Matricula set Falta = 9 where RA = 04 And Sigla = 'IA';

UPDATE Matricula set Falta = 45 where RA = 05 And Sigla = 'CE';
UPDATE Matricula set Falta = 25 where RA = 05 And Sigla = 'PIN';

UPDATE Matricula set Falta = 45 where RA = 06 And Sigla = 'GEA';
UPDATE Matricula set Falta = 25 where RA = 06 And Sigla = 'CON';

UPDATE Matricula set Falta = 45 where RA = 07 And Sigla = 'ED';
UPDATE Matricula set Falta = 25 where RA = 07 And Sigla = 'PIN';

UPDATE Matricula set Falta = 45 where RA = 08 And Sigla = 'FIS';
UPDATE Matricula set Falta = 25 where RA = 08 And Sigla = 'MTD';

UPDATE Matricula set Falta = 45 where RA = 09 And Sigla = 'LBH';
UPDATE Matricula set Falta = 25 where RA = 09 And Sigla = 'FIS';

UPDATE Matricula set Falta = 45 where RA = 10 And Sigla = 'EMP';
UPDATE Matricula set Falta = 25 where RA = 10 And Sigla = 'IA';

SELECT * FROM Matricula

/*UPDATE NAS NOTAS*/
UPDATE Matricula set Nota_N1 = 10, Nota_N2 = 5 where RA = 01 And Sigla = 'GEA';
UPDATE Matricula set Nota_N1 = 10, Nota_N2 = 5 , Nota_Sub = 0 where RA = 01 And Sigla = 'CA';

UPDATE Matricula set Nota_N1 = 0, Nota_N2 = 2 , Nota_Sub = 6 where RA = 02 And Sigla = 'LPD';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 02 And Sigla = 'CA';

UPDATE Matricula set Nota_N1 = 0, Nota_N2 = 2 , Nota_Sub = 6 where RA = 03 And Sigla = 'ED';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 03 And Sigla = 'ES';

UPDATE Matricula set Nota_N1 = 0, Nota_N2 = 2 , Nota_Sub = 6 where RA = 04 And Sigla = 'AOC';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 04 And Sigla = 'IA';

UPDATE Matricula set Nota_N1 = 0, Nota_N2 = 2 , Nota_Sub = 6 where RA = 05 And Sigla = 'CE';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 05 And Sigla = 'PIN';

UPDATE Matricula set Nota_N1 = 0, Nota_N2 = 2 , Nota_Sub = 0 where RA = 06 And Sigla = 'GEA';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 06 And Sigla = 'CON';

UPDATE Matricula set Nota_N1 = 4, Nota_N2 = 8 , Nota_Sub = 0 where RA = 07 And Sigla = 'ED';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 2 , Nota_Sub = 4 where RA = 07 And Sigla = 'PIN';

UPDATE Matricula set Nota_N1 = 10, Nota_N2 = 5 , Nota_Sub = 0 where RA = 08 And Sigla = 'FIS';
UPDATE Matricula set Nota_N1 = 3 , Nota_N2 = 9 , Nota_Sub = 0 where RA = 08 And Sigla = 'MTD';

UPDATE Matricula set Nota_N1 = 7, Nota_N2 = 2 , Nota_Sub = 10 where RA = 09 And Sigla = 'LBH';
UPDATE Matricula set Nota_N1 = 9, Nota_N2 = 8 , Nota_Sub = 0 where RA = 09 And Sigla = 'FIS';

UPDATE Matricula set Nota_N1 = 1, Nota_N2 = 6 , Nota_Sub = 6 where RA = 10 And Sigla = 'EMP';
UPDATE Matricula set Nota_N1 = 5, Nota_N2 = 3 , Nota_Sub = 8 where RA = 10 And Sigla = 'IA';

SELECT * FROM Matricula


/*CONSULTAS */

/*Busca os alunos matriculados em cada materia que deseja consultar*/
SELECT a.RA, a.Nome AS 'Aluno', d.Nome 'Disciplina', m.Nota_N1, m.Nota_N2, m.Nota_Sub, m.Nota_Media, m.Falta, m.Situacao
	FROM Aluno a, Matricula m, Disciplina d
	WHERE a.RA = m.RA AND m.Sigla = d.Sigla AND m.Sigla = 'LPD'

/*Busca UM aluno pelo RA e mostra todas as disciplinas que ele cursa no SEGUNDO SEMESTRE*/
SELECT a.RA, a.Nome AS 'Aluno', d.Nome 'Disciplina', m.Nota_N1, m.Nota_N2, m.Nota_Sub, m.Nota_Media, m.Falta, m.Situacao, m.Data_Semestre
	FROM Aluno a, Matricula m, Disciplina d
	WHERE a.RA = m.RA AND m.Sigla = d.Sigla AND a.RA = 01 AND Data_Ano = 2021 and Data_Semestre = 2


/*Busca quais sao os  alunos reprovados por NOTA */
SELECT a.RA, a.Nome AS 'Aluno', d.Nome 'Disciplina', m.Data_Ano, m.Nota_N1, m.Nota_N2, m.Nota_Sub, m.Nota_Media, m.Situacao
	FROM Aluno a, Matricula m, Disciplina d
	WHERE a.RA = m.RA AND m.Sigla = d.Sigla and Data_Ano = 2021 AND m.Nota_Media < 5

