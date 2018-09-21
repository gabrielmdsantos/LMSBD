
-- TABELA USUARIO
CREATE TABLE USUARIO (
	ID INT IDENTITY NOT NULL,
	LOGIN VARCHAR(30) NOT NULL,
	SENHA VARCHAR(30) NOT NULL,
	DT_EXPIRACAO DATE NOT NULL DEFAULT ('1900/01/01') ,

	CONSTRAINT PK_USUARIO PRIMARY KEY (ID),
	CONSTRAINT UQ_LOGIN UNIQUE (LOGIN)


);

--TABELA COORDENADOR
CREATE TABLE COORDENADOR
(
	ID INT IDENTITY NOT NULL,
	ID_USUARIO INT NOT NULL,
	NOME VARCHAR (30) NOT NULL,
	EMAIL VARCHAR (50) NOT NULL,
	CELULAR CHAR (11) NOT NULL,

	CONSTRAINT PK_COORDENARDOR PRIMARY KEY (ID),
	CONSTRAINT UQ_EMAIL_COORDENADOR UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_COORDENADOR UNIQUE (CELULAR),
	CONSTRAINT FK_COORDENADOR_USUARIO FOREIGN KEY (ID_USUARIO)
	REFERENCES USUARIO (ID)

);

--TABELA ALUNO
CREATE TABLE ALUNO
(
	ID INT IDENTITY NOT NULL,
	ID_USUARIO INT NOT NULL,
	NOME VARCHAR(30) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	CELULAR CHAR(11)  NOT NULL,
	RA INT NOT NULL,
	FOTO VARCHAR(30),
	CONSTRAINT UQ_EMAIL_ALUNO UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_ALUNO UNIQUE (CELULAR),
	CONSTRAINT PK_ID PRIMARY KEY (ID),
	CONSTRAINT FK_ALUNO_USUARIO FOREIGN KEY (ID_USUARIO)
	REFERENCES USUARIO (ID)
	);

-- TEBELA PROFESSOR
	CREATE TABLE PROFESSOR
	(	
		ID INT IDENTITY NOT NULL,
		ID_USUARIO INT NOT NULL,
		EMAIL VARCHAR(30) NOT NULL,
		CELULAR CHAR(11) NOT NULL,
		APELIDO VARCHAR(15) NOT NULL

		CONSTRAINT PK_PROFESSOR PRIMARY KEY (ID),
		CONSTRAINT UQ_EMAIL_PROFESSOR UNIQUE (EMAIL),
		CONSTRAINT UQ_PROFESSOR_CELULAR UNIQUE (CELULAR),
		CONSTRAINT FK_PROFESSOR_USUARIO FOREIGN KEY (ID_USUARIO)
		REFERENCES USUARIO (ID)
	);

-- TABELA DISCIPLINA
CREATE TABLE DISCIPLINA (

	ID INT IDENTITY NOT NULL,
	NOME VARCHAR (50) NOT NULL,
	DATA DATETIME NOT NULL DEFAULT (GETDATE()),
	STATUS VARCHAR(10) DEFAULT ('ABERTA') NOT NULL,
	PLANO_DE_ENSINO VARCHAR(100) NOT NULL,
	CARGA_HORARIA TINYINT NOT NULL, 
	COMPETENCIAS VARCHAR(200)NOT NULL,
	HABILIDADES VARCHAR (100)NOT NULL,
	EMENTA VARCHAR (100) NOT NULL,
	CONTEUDO_PROGRAMATICO VARCHAR (100) NOT NULL,
	BIBLIOGRAFIA_BASICA VARCHAR (70) NOT NULL,
	BIBLIOGRAFIA_COMPLEMENTAR VARCHAR (70) NOT NULL,
	PERCENTUAL_PRATICO TINYINT NOT NULL,
	PERCENTUAL_TEORICO TINYINT NOT NULL,
	ID_COORDENADOR INT NOT NULL
	
	CONSTRAINT PK_ID_DISCIPLINA PRIMARY KEY (ID),
	CONSTRAINT UQ_NOME_DISCIPLINA UNIQUE(NOME),
	CONSTRAINT CK_STATUS_DISCIPLINA CHECK(STATUS IN('ABERTA','FECHADO')),
	CONSTRAINT CK_CARGA_HORARIA CHECK(CARGA_HORARIA IN('40','80')),
	CONSTRAINT CK_PERCENTUAL_PRATICO CHECK(PERCENTUAL_PRATICO >= '00' OR PERCENTUAL_PRATICO <= '100'),
	CONSTRAINT CK_PERCENTUAL_TEORICO CHECK(PERCENTUAL_TEORICO >= '00' OR PERCENTUAL_PRATICO <= '100'),
	CONSTRAINT FK_DISCIPLINA_COORDENADOR FOREIGN KEY (ID_COORDENADOR)
	REFERENCES COORDENADOR(ID),
);
-- TABELA CURSO
CREATE TABLE CURSO
(
	ID INT IDENTITY NOT NULL,
	NOME VARCHAR (30) NOT NULL,
	CONSTRAINT PK_ID_CURSO PRIMARY KEY (ID),
	CONSTRAINT UQ_NOME_CURSO UNIQUE (NOME)
	
		
);

-- TABELA DICIPLINA_OFERTADA
CREATE TABLE DICIPLINA_OFERTADA
(
	ID INT IDENTITY NOT NULL,
	ID_COORDENADOR INT NOT NULL,
	DT_INICIO_MATRICULA DATE ,
	DT_FIM_MATRICULA DATE,
	ID_DISCIPLINA INT NOT NULL,
	ID_CURSO INT NOT NULL,
	ANO SMALLINT NOT NULL,
	SEMESTRE TINYINT NOT NULL ,
	TURMA VARCHAR(50) NOT NULL ,
	ID_PROFESSOR INT,
	METODOLOGIA VARCHAR (200),
	RECURSOS VARCHAR (200),
	CRITERIO_AVALIACAO VARCHAR (200),
	PLANO_AULA VARCHAR (200),
	
	CONSTRAINT PK_ID_DICIPLINA_OFERTADA PRIMARY KEY (ID),
	CONSTRAINT CK_ANO CHECK(ANO BETWEEN '1900' AND '2100'),
	CONSTRAINT CK_SEMESTRE CHECK(SEMESTRE IN('1','2')),
	CONSTRAINT CK_TURMA CHECK(TURMA >= 'A'OR TURMA <='Z' ),
	CONSTRAINT FK_OFERTADA_CURSO FOREIGN KEY (ID_CURSO) 
	REFERENCES CURSO (ID),
	CONSTRAINT FK_OFERTADA_COORDENADOR FOREIGN KEY (ID_COORDENADOR)
	REFERENCES COORDENADOR (ID),
	CONSTRAINT FK_OFERTADA_DISCIPLINA FOREIGN KEY (ID_DISCIPLINA)
	REFERENCES DISCIPLINA (ID),
	CONSTRAINT FK_OFERTADA_PROFESSOR FOREIGN KEY (ID_PROFESSOR)
	REFERENCES PROFESSOR (ID)
);

Create table SolicitacaoMatricula(
	ID int identity not null,
	ID_ALUNO int not null,
	ID_DISCIPLINA_OFERTADA int not null,
	DtSolicitacao datetime not null DEFAULT (GETDATE()),
	ID_COORDENADOR int,
	Status varchar(30) DEFAULT ('Solicitada'),
	CONSTRAINT PK_Solicitacao primary key (id),
	CONSTRAINT CK_Status check (Status in ('Solicitada', 'Aprovada','Rejeitada', 'Cancelada')),
	CONSTRAINT FK_MATRICULA_ALUNO FOREIGN KEY (ID_ALUNO)
	REFERENCES ALUNO (ID),
	CONSTRAINT FK_MATRICULA_OFERTADA FOREIGN KEY (ID_DISCIPLINA_OFERTADA)
	REFERENCES DICIPLINA_OFERTADA (ID),
	CONSTRAINT FK_MATRICULA_COORDENADOR FOREIGN KEY (ID_COORDENADOR)
	REFERENCES COORDENADOR (ID)
);

CREATE TABLE ATIVIDADE
(
	ID INT IDENTITY NOT NULL,
	TITULO_ATIVIDADE VARCHAR (20) NOT NULL,
	DESCRICAO_ATIVIDADE VARCHAR (100),
	CONTEUDO_ATIVIDADE VARCHAR (100) NOT NULL,
	TIPO_ATIVIDADE VARCHAR (15) NOT NULL,
	EXTRA_ATIVIDADE VARCHAR (100),
	ID_PROFESSOR INT NOT NULL

	CONSTRAINT PK_ATIVIDADE PRIMARY KEY (ID),
	CONSTRAINT UQ_TITULO_ATIVIDADE UNIQUE (TITULO_ATIVIDADE),
	CONSTRAINT CK_TIPO_ATIVIDADE CHECK (TIPO_ATIVIDADE IN ('RESPOSTA ABERTA', 'TESTE')),
	CONSTRAINT FK_ATIVIDADE_PROFESSOR FOREIGN KEY (ID_PROFESSOR)
	REFERENCES PROFESSOR (ID)
	);

	CREATE TABLE ATIVIDADE_VINCULADA(
	ID INT IDENTITY NOT NULL,
	ID_ATIVIDADE INT NOT NULL,
	ID_PROFESSOR INT NOT NULL,
	ID_DISCIPLINA_OFERTADA INT NOT NULL,
	ROTULO VARCHAR(60)NOT NULL,
	STATUS VARCHAR(30)NOT NULL,
	DTLINICIO_RESPOSTA VARCHAR(100)NOT NULL,
	DTFIM_RESPOSTA VARCHAR (100)NOT NULL,

	CONSTRAINT PK_ATIVIDADE_VINCULADA PRIMARY KEY (ID),
	CONSTRAINT ATIVIDADE_VINCULADA_CK_STATUS CHECK (STATUS IN('DISPONIBILIZADA', 'ABERTA', 'FECHADA',
	'ENCERRADA','PRORROGADA')),
	CONSTRAINT FK_VINCULADA_PROFESSOR FOREIGN KEY (ID_PROFESSOR)
	REFERENCES PROFESSOR (ID),
	CONSTRAINT FK_OFERTADA_OFERTADA FOREIGN KEY (ID_DISCIPLINA_OFERTADA)
	REFERENCES DICIPLINA_OFERTADA (ID),
	CONSTRAINT FK_VINCULADA_ATIVIDADE FOREIGN KEY (ID_ATIVIDADE)
	REFERENCES ATIVIDADE (ID)
	);
	
	CREATE TABLE ENTREGA
	( 
		ID INT IDENTITY NOT NULL,
		ID_ALUNO INT NOT NULL,
		ID_ATIVIDADE_VINCULADA INT NOT NULL,
		TITULO VARCHAR(30)NOT NULL,
		RESPOSTA VARCHAR(140) NOT NULL,
		DT_ENTREGA DATETIME NOT NULL DEFAULT (GETDATE()),
		STATUS VARCHAR(30) NOT NULL DEFAULT ('ENTREGUE'),
		ID_PROFESSOR INT,
		NOTA DECIMAL(3,1),
		DT_AVALIACAO DATE,
 		OBS VARCHAR (100),


		CONSTRAINT PK_ENTREGA PRIMARY KEY (ID),
		CONSTRAINT CK_ENTREGA_STATUS CHECK (STATUS IN ('ENTREGUE', 'CORRIGIDO')),
		CONSTRAINT CK_NOTA CHECK (NOTA >= '0.00' AND NOTA <= '10.00'),
		CONSTRAINT FK_ENTREGA_PROFESSOR FOREIGN KEY (ID_PROFESSOR)
		REFERENCES PROFESSOR (ID),
		CONSTRAINT FK_ENTREGA_ALUNO FOREIGN KEY (ID_ALUNO)
		REFERENCES ALUNO (ID),
		CONSTRAINT FK_ENTREGA_ATIVIDADE FOREIGN KEY (ID_ATIVIDADE_VINCULADA)
		REFERENCES ATIVIDADE_VINCULADA (ID)
	);

	CREATE TABLE MENSAGEM (


	ID INT IDENTITY NOT NULL,
	ID_ALUNO INT NOT NULL,
	ID_PROFESSOR INT NOT NULL,
	ASSUNTO VARCHAR(200) NOT NULL,
	REFERENCIA VARCHAR(150) NOT NULL,
	CONTEUDO VARCHAR (300) NOT NULL,
	STATUS VARCHAR (10) DEFAULT ('ABERTA') NOT NULL,
	DT_ENVIO DATE DEFAULT ('AAAA/MM/DD') NOT NULL,
	DT_RESPOSTA DATE,
	RESPOSTA VARCHAR (143),

	CONSTRAINT PK_ID_MENSAGEM PRIMARY KEY (ID),
	CONSTRAINT CK_STATUS_MENSAGEM CHECK(STATUS IN('ABERTA','FECHADO')),
	CONSTRAINT FK_MENSAGEM_PROFESSOR FOREIGN KEY (ID_PROFESSOR)
	REFERENCES PROFESSOR (ID),
	CONSTRAINT FK_MENSAGEM_ALUNO FOREIGN KEY (ID_ALUNO)
	REFERENCES ALUNO (ID)


);


