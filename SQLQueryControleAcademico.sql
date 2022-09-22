CREATE DATABASE Controle_Academico

USE Controle_Academico

CREATE TABLE Aluno(
	RA int NOT NULL,
	Nome varchar(50) NOT NULL,

	CONSTRAINT PK_RA PRIMARY KEY (RA)
);

CREATE TABLE Disciplina(
	Sigla char(3) NOT NULL,
	Nome varchar(30)NOT NULL,
	Carga_Horaria int NOT NULL,

	CONSTRAINT PK_Sigla PRIMARY KEY (Sigla)
);

CREATE TABLE Matricula(
	RA int NOT NULL,
	Sigla char(3) NOT NULL,
	Data_Ano int NOT NULL,
	Data_Semestre int NOT NULL,
	Falta int,
	Nota_Nota1 float,
	Nota_Nota2 float,
	Nota_NotaSub float,
	Nota_Media float,
	Situacao /*Aprovado/Reprovado Nota/Reprovado Falta*/varchar(20),

	FOREIGN KEY (RA) REFERENCES Aluno(RA),/*Chave estrangeira)*/
	FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla),
	CONSTRAINT PK_Matricula PRIMARY KEY (RA,Sigla,Data_Ano,Data_Semestre) /*Chave composta*/
);

CREATE TRIGGER Mensagem_Cadastro_Aluno
ON Aluno 
AFTER INSERT 
AS
BEGIN
PRINT('Cadastro realizado com sucesso!')
END;


CREATE TRIGGER Mensagem_Cadastro_Disciplina
ON Disciplina
AFTER INSERT 
AS
BEGIN
PRINT('Disciplina cadastrada com sucesso!')
END;

CREATE TRIGGER Mensagem_Cadastro_Matricula
ON Matricula
AFTER INSERT 
AS
BEGIN
PRINT('Matricula efetuada com sucesso!')
END;

CREATE TRIGGER Mensagem_Inserindo_Notas
ON Matricula
AFTER UPDATE
AS
BEGIN
PRINT('Notas atualizadas com sucesso!')
END;

CREATE TRIGGER Atualiza_Matricula
ON Matricula
AFTER UPDATE
AS
IF (UPDATE(Nota_Nota1) OR UPDATE(Nota_Nota2) OR UPDATE(Nota_NotaSub))
BEGIN 
DECLARE @RA INT ,
		@Sigla char(3),
		@Nota_Nota1 float ,
		@Nota_Nota2 float,
		@Nota_NotaSub float,
		@Nota_Media float,
		@Falta int,
		@Carga_Horaria int,
		@Data_Ano int,
		@Data_Semestre int

	SELECT @Sigla = Sigla, @RA = RA, @Data_Ano = Data_Ano, @Data_Semestre = Data_Semestre FROM INSERTED;
	SELECT @Nota_Media= Nota_Media, @Nota_Nota1 = Nota_Nota1, @Nota_Nota2 = Nota_Nota2, @Nota_NotaSub = Nota_NotaSub, @Falta = Falta FROM Matricula WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;
	SELECT @Carga_Horaria = Carga_Horaria FROM Disciplina WHERE Sigla= @Sigla;
	IF(@Nota_NotaSub IS NOT NULL AND (@Nota_NotaSub > @Nota_Nota1 OR @Nota_NotaSub > @Nota_Nota2) AND @Nota_Nota1>@Nota_Nota2)
		SET @Nota_Media = ((@Nota_NotaSub + @Nota_Nota1) / 2);
			
			ELSE IF (@Nota_NotaSub IS NOT NULL  AND (@Nota_NotaSub > @Nota_Nota1 OR @Nota_NotaSub > @Nota_Nota2 )AND @Nota_Nota2 >= @Nota_Nota1)
			SET @Nota_Media = ((@Nota_NotaSub + @Nota_Nota2) / 2);
				
				ELSE
				SET @Nota_Media = ((@Nota_Nota1 + @Nota_Nota2) / 2);
	IF(@Falta >=((0.25*(@Carga_Horaria))))
	UPDATE Matricula SET Situacao = 'REPROVADO POR FALTA', Nota_Media = @Nota_Media  WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;
	ELSE IF (@Nota_Media >= 5)
	UPDATE Matricula SET Situacao = 'APROVADO', Nota_Media = @Nota_Media WHERE RA = RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;
	ELSE 
	UPDATE Matricula SET Situacao = 'REPROVADO POR NOTA', Nota_Media = @Nota_Media WHERE RA = @RA AND Sigla = @Sigla AND Data_Ano = @Data_Ano AND Data_Semestre = @Data_Semestre;
END



INSERT INTO Aluno(RA,Nome)
Values (01,'Heloísa'),
	   (02,'Roberta'),
	   (03,'Josival'),
	   (04,'Naiara'),
	   (05,'Leonardo'),
	   (06,'Mateus'),
	   (07,'João'),
	   (08,'Fábio'),
	   (09,'Maria'),
	   (10,'Gustavo');

SELECT * FROM Aluno;  /*Ver se foi inserido certo*/


INSERT INTO Disciplina(Sigla,Nome,Carga_Horaria)
Values('CA','Cálculo',100),
	  ('LP','Lógica Programação', 80),
	  ('ES','Estatística',50),
	  ('BD','Banco de Dados',80),
	  ('ED','Estrutura de Dados',80),
	  ('FIL','Filosofia',40),
	  ('FIS','Física',50),
	  ('QUI','Química',50),
	  ('BIO','Biologia',50),
	  ('SOC','Sociologia',40);

	 SELECT * FROM Disciplina; /*Ver se foi inserido certo*/


INSERT INTO Matricula(RA,Sigla,Data_Ano,Data_Semestre)
VALUES (01,'SOC',2021,1),
	   (01,'FIL',2021,1),

	   (02,'BD',2021,2),
	   (02,'ED',2021,2),

	   (03,'ES',2021,1),
	   (03,'CA',2021,1),

	   (04,'LP',2021,2),
	   (04,'BD',2021,2),

	   (05,'ED',2021,2),
	   (05,'BD',2021,2),

	   (06,'FIL',2021,1),
	   (06,'SOC',2021,1),

	   (07,'FIS',2021,2),
	   (07,'QUI',2021,2),

	   (08,'QUI',2021,2),
	   (08,'FIS',2021,2),

	   (09,'CA',2021,1),
	   (09,'ES',2021,1),

	   (10,'BIO',2021,1),
	   (10,'FIL',2021,1);
	  

  SELECT * FROM Matricula;/*Ver se foi inserido certo*/
 

  UPDATE Matricula set Nota_Nota1 = 5.5 where RA=1 AND Sigla='SOC'; 
  UPDATE Matricula set Nota_Nota2 = 9.5 where RA=1  AND Sigla='SOC';
  UPDATE Matricula set Falta=3 where RA=1 AND Sigla='SOC';
  UPDATE Matricula set Nota_Nota1 = 10 where RA=1 AND Sigla='FIL'; 
  UPDATE Matricula set Nota_Nota2 = 5 where RA=1  AND Sigla='FIL';
  UPDATE Matricula set Falta=0 where RA=1 AND Sigla='FIL';


  UPDATE Matricula set Nota_Nota1 = 10 where RA=2 AND Sigla='BD';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=2  AND Sigla='BD';
  UPDATE Matricula set Falta=0 where RA=2 AND Sigla='BD';
  UPDATE Matricula set Nota_Nota1 = 9 where RA=2 AND Sigla='ED';
  UPDATE Matricula set Nota_Nota2 = 9 where RA=2  AND Sigla='ED';
  UPDATE Matricula set Falta=1 where RA=2 AND Sigla='ED';

  
  UPDATE Matricula set Nota_Nota1 = 8 where RA=3 AND Sigla='ES';
  UPDATE Matricula set Nota_Nota2 = 7 where RA=3  AND Sigla='ES';
  UPDATE Matricula set Falta= 0 where RA=3 AND Sigla='ES';
  UPDATE Matricula set Nota_Nota1 = 8 where RA=3 AND Sigla='CA';
  UPDATE Matricula set Nota_Nota2 = 8 where RA=3  AND Sigla='CA';
  UPDATE Matricula set Falta= 3 where RA=3 AND Sigla='CA';


  UPDATE Matricula set Nota_Nota1 = 8 where RA=4 AND Sigla='LP';
  UPDATE Matricula set Nota_Nota2 = 7 where RA=4  AND Sigla='LP';
  UPDATE Matricula set Falta= 2 where RA=4 AND Sigla='LP';
  UPDATE Matricula set Nota_Nota1 = 0 where RA=4 AND Sigla='BD';
  UPDATE Matricula set Nota_Nota2 = 4 where RA=4  AND Sigla='BD';
  UPDATE Matricula set Falta= 0 where RA=4 AND Sigla='BD';
  UPDATE Matricula set Nota_NotaSub=6 where RA=4 AND Sigla='BD';


  UPDATE Matricula set Nota_Nota1 = 6 where RA=5 AND Sigla='ED';
  UPDATE Matricula set Nota_Nota2 = 6 where RA=5  AND Sigla='ED';
  UPDATE Matricula set Falta= 30 where RA=5 AND Sigla='ED';
  UPDATE Matricula set Nota_Nota1 = 0 where RA=5 AND Sigla='BD';
  UPDATE Matricula set Nota_Nota2 = 5 where RA=5  AND Sigla='BD';
  UPDATE Matricula set Falta= 0 where RA=5 AND Sigla='BD';
  UPDATE Matricula set Nota_NotaSub=2 where  RA=5 AND Sigla='BD';

  UPDATE Matricula set Nota_Nota1 = 2 where RA=6 AND Sigla='FIL';
  UPDATE Matricula set Nota_Nota2 = 0 where RA=6 AND Sigla='FIL';
  UPDATE Matricula set Falta = 3 where RA=6 AND Sigla='FIL';
  UPDATE Matricula set Nota_Nota1 = 0 where RA=6 AND Sigla='SOC';
  UPDATE Matricula set Nota_Nota2 = 0 where RA=6 AND Sigla='SOC';
  UPDATE Matricula set Falta = 5 where RA=6 AND Sigla='SOC';
  UPDATE Matricula set Nota_NotaSub=10 where RA=6 AND Sigla='SOC';


  UPDATE Matricula set Nota_Nota1 = 10 where RA=7 AND Sigla='FIS';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=7 AND Sigla='FIS';
  UPDATE Matricula set Falta = 8 where RA=7 AND Sigla='FIS';
  UPDATE Matricula set Nota_Nota1 = 10 where RA=7 AND Sigla='QUI';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=7 AND Sigla='QUI';
  UPDATE Matricula set Falta = 0 where RA=7 AND Sigla='QUI';


  UPDATE Matricula set Nota_Nota1 = 10 where RA=8 AND Sigla='QUI';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=8 AND Sigla='QUI';
  UPDATE Matricula set Falta = 25 where RA=8 AND Sigla='QUI';
  UPDATE Matricula set Nota_Nota1 = 5 where RA=8 AND Sigla='FIS';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=8 AND Sigla='FIS';
  UPDATE Matricula set Falta = 12 where RA=8 AND Sigla='FIS';


  UPDATE Matricula set Nota_Nota1 = 2 where RA=9 AND Sigla='CA';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=9 AND Sigla='CA';
  UPDATE Matricula set Falta = 13 where RA=9 AND Sigla='CA';
  UPDATE Matricula set Nota_Nota1 = 10 where RA=9 AND Sigla='ES';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=9 AND Sigla='ES';
  UPDATE Matricula set Falta = 0 where RA=9 AND Sigla='ES';


  UPDATE Matricula set Nota_Nota1 = 5 where RA=10 AND Sigla='BIO';
  UPDATE Matricula set Nota_Nota2 = 5 where RA=10 AND Sigla='BIO';
  UPDATE Matricula set Falta = 0 where RA=10 AND Sigla='BIO';
  UPDATE Matricula set Nota_Nota1 = 10 where RA=10 AND Sigla='FIL';
  UPDATE Matricula set Nota_Nota2 = 10 where RA=10 AND Sigla='FIL';
  UPDATE Matricula set Falta = 2 where RA=10 AND Sigla='FIL';

  /*Consultar alunos da diciplina*/
SELECT Disciplina.Sigla, Disciplina.Nome, Aluno.RA, Aluno.Nome,Matricula.Data_Ano,Matricula.Nota_Nota1, Matricula.Nota_Nota2,Matricula.Nota_NotaSub,Matricula.Nota_Media,Matricula.Falta,Matricula.Situacao
FROM Aluno,Matricula, Disciplina
WHERE  Matricula.RA = Aluno.RA and Matricula.Sigla = Disciplina.Sigla and Disciplina.Sigla= 'SOC' and  Data_Ano = 2021
/*Consulta notas, faltas e situação de um aluno*/
SELECT Aluno.RA,Aluno.Nome,Matricula.Sigla,Matricula.Data_Ano,Matricula.Data_Semestre,Matricula.Nota_Nota1,Matricula.Nota_Nota2,Matricula.Nota_NotaSub,Matricula.Falta,Matricula.Situacao
FROM Aluno,Matricula
WHERE Matricula.RA = Aluno.RA and Aluno.Nome ='Heloísa' and  Data_Ano = 2021 and Data_Semestre = 1
/*Consultar média menor que 5 em 2021*/
SELECT Aluno.RA, Aluno.Nome, Matricula.Sigla,Matricula.Data_Ano,Matricula.Nota_Nota1,Matricula.Nota_NotaSub,Matricula.Nota_Media,Matricula.Situacao
FROM Aluno,Matricula
WHERE  Matricula.RA = Aluno.RA and Data_Ano = 2021 and Nota_Media < 5

