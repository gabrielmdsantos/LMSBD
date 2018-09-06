Create table Usuario (

	ID int identity not null,
	Login varchar(30) not null,
	senha varchar(30) not null,
	DtExpiracao date not null default ('1900/01/01') ,

	CONSTRAINT PK_Usuario primary key (ID),
	CONSTRAINT UQ_login unique (Login)

);

CREATE TABLE COORDENADOR(

	ID INT IDENTITY NOT NULL,
	ID_USUARIO INT NOT NULL,
	NOME VARCHAR (30) NOT NULL,
	EMAIL VARCHAR (50) NOT NULL,
	CELULAR CHAR (11) NOT NULL,

	CONSTRAINT PK_COORDENARDOR PRIMARY KEY (ID),
	CONSTRAINT UQ_EMAIL UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR UNIQUE (CELULAR),
	CONSTRAINT FK_ID_USUARIO FOREIGN KEY (ID_USUARIO) 
		REFERENCES USUARIO (ID)

);

CREATE TABLE ALUNO(

	ID INT IDENTITY,
	ID_USUARIO INT,
	NOME VARCHAR(30) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	CELULAR TINYINT  NOT NULL,
	RA INT NOT NULL,
	FOTO VARCHAR(30)

	CONSTRAINT UQ_EMAIL_ALUNO UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_ALUNO UNIQUE (CELULAR),
	CONSTRAINT PK_ID PRIMARY KEY (ID)
	
);

CREATE TABLE PROFESSOR(
	
	ID_PROFESSOR INT IDENTITY NOT NULL,
	ID_USUARIO INT NOT NULL,
	EMAIL VARCHAR(30) NOT NULL,
	CELULAR CHAR(11) NOT NULL,
	APELIDO VARCHAR(15) NOT NULL

	CONSTRAINT PK_PROFESSOR PRIMARY KEY (ID_PROFESSOR),
	CONSTRAINT UQ_EMAIL UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR UNIQUE (CELULAR),
	CONSTRAINT FK_ID_USUARIO FOREIGN KEY (ID_USUARIO) 
		REFERENCES USUARIO (ID)

);

CREATE TABLE DISCIPLINAA (

	ID INT IDENTITY NOT NULL,
	NOME VARCHAR (50) NOT NULL,
	DATA DATE DEFAULT ('AAAA/MM/DD') NOT NULL,
	S_TATUS VARCHAR(10) DEFAULT ('ABERTA') NOT NULL,
	PLANO_DE_ENSINO VARCHAR(100) NOT NULL,
	CARGA_HORARIA TINYINT NOT NULL, 
	COMPETENCIAS VARCHAR(200),
	HABILIDADES VARCHAR (100),
	EMENTA VARCHAR (100) NOT NULL,
	CONTEUDO_PROGRAMATICO VARCHAR (100) NOT NULL,
	BIBLIOGRAFIA_BASICA VARCHAR (70) NOT NULL,
	BIBLIOGRAFIA_COMPLEMENTAR VARCHAR (70) NOT NULL,
	PERCENTUAL_PRATICO TINYINT NOT NULL,
	PERCENTUAL_TEORICO TINYINT NOT NULL,
	ID_COORDENADOR INT NOT NULL,

	CONSTRAINT PK_ID_DISCIPLINA PRIMARY KEY (ID),
	CONSTRAINT UQ_NOME UNIQUE(NOME),
	CONSTRAINT CK_STATUS_DISCIPLINA  
			CHECK(S_TATUS IN('ABERTA','FECHADO')),
	CONSTRAINT CK_CARGA_HORARIA 
			CHECK(CARGA_HORARIA IN('40','80')),
	CONSTRAINT CK_PERCENTUAL_PRATICO
			CHECK(PERCENTUAL_PRATICO >= '40' OR PERCENTUAL_PRATICO <= '80'),
	CONSTRAINT CK_PERCENTUAL_TEORICO
			CHECK(PERCENTUAL_TEORICO >= '40' OR PERCENTUAL_PRATICO <= '80'),
	CONSTRAINT FK_ID_COORDENADOR FOREIGN KEY (ID_COORDENADOR) 
			REFERENCES COORDENADOR (ID)
	
);

Create table Curso(

	ID int not null identity,
	Nome Varchar (200),
	CONSTRAINT PK_ID_Curso PRIMARY KEY (ID)
	
		
);


Create table DisciplinaOfertada(

	ID int not null identity,
	idCoordenador INT NOT NULL,
	DtInicioMatricula date ,
	DtFimMatricula date,
	IdDisciplina INT NOT NULL,
	IdCurso int not null,
	Ano smallint not null,
	Semestre tinyint not null ,
	Turma Varchar not null ,
	IdProfessor INT NOT NULL,
	Metodologia Varchar (200),
	Recursos Varchar (200),
	CriterioAvaliacao Varchar (200),
	PlanoDeAulas Varchar (200),

	CONSTRAINT PK_ID_DisciplinaOfertada PRIMARY KEY (ID),
	CONSTRAINT  CK_ano 
		CHECK(ano between '1900' and '2100'),
	CONSTRAINT CK_semestre
		CHECK(semestre in('1','2')),
	CONSTRAINT CK_Turma
		CHECK(Turma >= 'a'or Turma <='z' ),
	CONSTRAINT UQ_CURSO UNIQUE (IdCurso, ANO, SEMESTRE, TURMA),
	CONSTRAINT FK_CURSO FOREIGN KEY (IdCurso) 
		REFERENCES Curso (ID),
	CONSTRAINT FK_ID_COORDENADOR FOREIGN KEY (idCoordenador) 
		REFERENCES COORDENADOR (ID),
	CONSTRAINT FK_ID_DISCIPLINA FOREIGN KEY (IdDisciplina) 
		REFERENCES DISCIPLINAA (ID),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (IdProfessor) 
		REFERENCES PROFESSOR (ID_PROFESSOR)

);

Create table SolicitacaoMatricula(

	ID int identity not null,
	IDAluno int not null,
	IDDisciplinaOfertada int not null,
	DtSolicitacao datetime not null DEFAULT (GETDATE()),
	IDCoordenador int,
	Status varchar(30) DEFAULT ('Solicitada'),

	CONSTRAINT PK_Solicitacao primary key (id),
	CONSTRAINT CK_Status check (Status in ('Solicitada', 'Aprovada','Rejeitada', 'Cancelada')),
	CONSTRAINT FK_ID_ALUNO FOREIGN KEY (IDAluno) 
		REFERENCES ALUNO (ID),
	CONSTRAINT FK_ID_DISCIPLINA_OFERTADA FOREIGN KEY (IDDisciplinaOfertada) 
		REFERENCES DisciplinaOfertada (ID),
	CONSTRAINT FK_ID_COORDENADOR FOREIGN KEY (IDCoordenador) 
		REFERENCES COORDENADOR (ID)

);

CREATE TABLE ATIVIDADE(

	ID INT IDENTITY NOT NULL,
	TITULO_ATIVIDADE VARCHAR (20) NOT NULL,
	DESCRICAO_ATIVIDADE VARCHAR (100),
	CONTEUDO_ATIVIDADE VARCHAR (100) NOT NULL,
	TIPO_ATIVIDADE VARCHAR (15) NOT NULL,
	EXTRA_ATIVIDADE VARCHAR (100),
	ID_PROFESSOR INT NOT NULL

	CONSTRAINT PK_ATIVIDADE PRIMARY KEY (ID),
	CONSTRAINT UQ_TITULO UNIQUE (TITULO_ATIVIDADE),
	CONSTRAINT CK_TIPO_ATIVIDADE CHECK (TIPO_ATIVIDADE IN ('RESPOSTA ABERTA', 'TESTE')),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (ID_PROFESSOR) 
		REFERENCES PROFESSOR (ID_PROFESSOR)

);

CREATE TABLE ATIVIDADE_VINCULADA(

	ID INT IDENTITY NOT NULL,
	ID_ATIVIDADE INT NOT NULL,
	ID_PROFESSOR INT NOT NULL,
	ID_DICIPLINA_OFERTA INT NOT NULL,
	ROTULO VARCHAR(60) NOT NULL,
	STATUS VARCHAR(30) NOT NULL,
	DTLINICIO_RESPOSTA VARCHAR(100) NOT NULL,
	DTFIM_RESPOSTA VARCHAR (100) NOT NULL,

	CONSTRAINT ATIVIDADE_VINCULADA_CK_STATUS CHECK (STATUS IN('DISPONIBILIZADA', 'ABERTA', 'FECHADA','ENCERRADA','PRORROGADA')),
	CONSTRAINT FK_ID_ATIVIDADE FOREIGN KEY (ID_ATIVIDADE) 
		REFERENCES ATIVIDADE (ID),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (ID_PROFESSOR) 
		REFERENCES PROFESSOR (ID_PROFESSOR),
	CONSTRAINT FK_ID_DISCIPLINA_OFERTA FOREIGN KEY (ID_DICIPLINA_OFERTA) 
		REFERENCES DisciplinaOfertada (ID)

);

CREATE TABLE ENTREGA(
 
	ID_ENTREGA INT IDENTITY NOT NULL,
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

	CONSTRAINT PK_ENTREGA PRIMARY KEY (ID_ENTREGA),
	CONSTRAINT CK_ENTREGA_STATUS CHECK (STATUS IN ('ENTREGUE', 'CORRIGIDO')),
	CONSTRAINT CK_NOTA CHECK (NOTA >= '0.00' AND NOTA <= '10.00'),
	CONSTRAINT FK_ID_ALUNO FOREIGN KEY (ID_ALUNO) 
		REFERENCES ALUNO (ID),
	CONSTRAINT FK_ID_ATIVIDADE_VINCULADA FOREIGN KEY (ID_ATIVIDADE_VINCULADA) 
		REFERENCES ATIVIDADE_VINCULADA (ID),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (ID_PROFESSOR) 
		REFERENCES PROFESSOR (ID_PROFESSOR)

	);

	CREATE TABLE MENSAGEMM (

	ID INT IDENTITY NOT NULL,
    ID_ALUNO INT NOT NULL,
	ID_PROFESSOR INT NOT NULL,
	ASSUNTO VARCHAR(200) NOT NULL,
	REFERENCIA VARCHAR(150) NOT NULL,
	CONTEUDO VARCHAR (300) NOT NULL,
	S_TATUS VARCHAR (10) DEFAULT ('ABERTA') NOT NULL,
	DT_ENVIO DATE DEFAULT ('AAAA/MM/DD') NOT NULL,
	DT_RESPOSTA DATE,
	RESPOSTA VARCHAR (8000),

	CONSTRAINT PK_ID_MENSAGEM PRIMARY KEY (ID),
	CONSTRAINT CK_STATUS_MENSAGEM 
			CHECK(S_TATUS IN('ABERTA','FECHADO')),
	CONSTRAINT FK_ID_ALUNO FOREIGN KEY (ID_ALUNO) 
		REFERENCES ALUNO (ID),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (ID_PROFESSOR) 
		REFERENCES PROFESSOR (ID_PROFESSOR)

);

