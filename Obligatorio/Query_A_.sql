create database ObligatorioBD_275251
use ObligatorioBD_275251
set dateformat 'dmy'
--Creacion de tablas
Create table Pais
(
	codigo char(3) primary key check (codigo like '[A-Z][A-Z][A-Z]'),
	nombre char(3) not null unique check (nombre like '[A-Z][A-Z][A-Z]'),
)
Create table Ciudad
(
	nombre varchar(30) not null /*No uso primary key ya que eso la haria unique, y los nombres de ciudad se repiten*/,
	codPais char(3) not null foreign key references Pais (codigo),
)
Create table Participante
(
	pasaporte char(9) primary key check (pasaporte like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]'),--3 letras y 6 digitos
	nombre varchar(20) not null, 
	nacionalidad char(3) not null foreign key references Pais(codigo),
	sexo char(2) not null check (sexo in ('F','M')), 
	fechaNac date not null check (fechaNac<getdate()),
)

Create table Federacion
(
	nombre varchar(30) primary key,
	codPais char(3) not null foreign key references Pais(codigo),
	
)
Create table Competencia
(
	nombre varchar(30) primary key, 
	fechaYear date not null check (fechaYear<=getdate()),
	codPais char(3) not null foreign key references Pais (codigo),
)
Create table CompetenciaFederacion
(
	idCompetencia varchar(30) not null foreign key references Competencia(nombre),
	idFederacion varchar(30) not null foreign key references Federacion(nombre)
)
Create table FederacionParticipante
(
	idFederacion varchar(30) not null foreign key references Federacion(nombre),
	idParticipante char(9) not null foreign key references Participante(pasaporte),
	cantDiasPrep int not null check (cantDiasPrep>0),
	importeEstimado money not null check (importeEstimado>0),
)

Create table Carrera(
	id int primary key,
	metros int not null check (metros>=100),
	tipo varchar(20) not null check (tipo in ('De velocidad', 'De fondo', 'De Media Distancia')),
)

Create table Salto(
	id int primary key,
	saltos varchar(20) not null check (saltos in ('Altura', 'Longitud')),
)
Create table Lanzamiento(
	id int primary key,
	lanzamientos varchar(20) not null check (lanzamientos in ('Peso', 'Disco', 'Jabalina')),
)


Create table Disciplina 
(
	id int primary key,
	tipo varchar(30) not null check (tipo in('Salto','Carrera','Lanzamiento')),
	idSalto int foreign key references Salto(id),
	idCarrera int foreign key references Carrera(id),
	idLanzamiento int foreign key references Lanzamiento(id),
)

Create table Prueba
(
	id int primary key identity,
	dia date not null check (dia<=getdate()),
	horaInicio time not null,
	horaFin time not null,
	ciudad varchar(30) not null,
	nombreCompeticion varchar(30) not null foreign key references Competencia(nombre),
	idDisciplina int not null foreign key references Disciplina(id),
	check (horaInicio<horaFin)
)

Create table PruebaParticipante
(
	idPrueba int foreign key references Prueba(id),
	idParticipante char(9) not null foreign key references Participante(pasaporte),
	resultado int not null,
	posicion int not null check (posicion>0),
	constraint PK_PM PRIMARY KEY (idPrueba, idParticipante),
)

Create table AuditoriaParticipante
(
	fchamod datetime primary key check (fchaMod<=getdate()),
	usumod varchar(20) not null,
	idParticipante char(9) not null,
	tipomod char(10) not null check (tipomod in('DELETE','INSERT','UPDATE')),
)

--Indices
Create index I_Pais on Pais(nombre)
Create index I_Ciudad on Ciudad(codPais)
Create index I_Participante on Participante(nacionalidad)
Create index I_Federacion on Federacion(codPais)
Create index I_Competencia on Competencia(codPais)
Create index I_CF on CompetenciaFederacion(idCompetencia)
Create index I_FP on FederacionParticipante(idFederacion)
Create index I_Disciplina on Disciplina(idCarrera)
Create index I2_Disciplina on Disciplina(idSalto)
Create index I3_Disciplina on Disciplina(idLanzamiento)
Create index I_Prueba on Prueba(nombreCompeticion)
Create index I2_Prueba on Prueba(idDisciplina)
Create index I_PP on PruebaParticipante(idPrueba)


--Datos de prueba
--Datos Pais:
Insert into Pais values ('URU', 'URU');
Insert into Pais values ('ARG', 'ARG');
Insert into Pais values ('MEX', 'MEX');
Insert into Pais values ('BRA', 'BRA');
Insert into Pais values ('CAN', 'CAN');
Insert into Pais values ('USA', 'USA');
Insert into Pais values ('PAR', 'PAR');
Insert into Pais values ('RUS', 'RUS');
Insert into Pais values ('CHI', 'CHI');
Insert into Pais values ('COR', 'COR');
Insert into Pais values ('ITA', 'ITA');
Insert into Pais values ('SUE', 'SUE');
Insert into Pais values ('ING', 'ING');
Insert into Pais values ('CHI', 'CHIN'); --Dato erroneo (Interfiere con check)
Insert into Pais values ('CHIN', 'CHIN'); --Dato erroneo (Interfiere con check)
Insert into Pais values ('CHIN', 'CHI'); --Dato erroneo (Interfiere con check)
Insert into Pais values ('132', 'DIN'); --Dato erroneo (Interfiere con check)
--Datos ciudad
Insert into Ciudad values ('Montevideo', 'URU');
Insert into Ciudad values ('Buenos Aires', 'ARG');
Insert into Ciudad values ('Monterrey', 'MEX');
Insert into Ciudad values ('Rio de Janeiro', 'BRA');
Insert into Ciudad values ('Ottawa', 'CAN');
Insert into Ciudad values ('California', 'USA');
Insert into Ciudad values ('Asuncion', 'PAR');
Insert into Ciudad values ('Kiev', 'RUS');
Insert into Ciudad values ('Wuhan', 'CHI');
Insert into Ciudad values ('Seul', 'COR');
Insert into Ciudad values ('Roma', 'ITA');
Insert into Ciudad values ('Estocolmo', 'SUE');
Insert into Ciudad values ('Londres', 'ING');

--Datos Participante
--Participantes uruguayos
insert into Participante values ('AED123456', 'Romina', 'URU', 'F', '20/03/2001');
insert into Participante values ('SJF232514', 'Tiago', 'URU', 'M', '26/09/2001');
insert into Participante values ('DFS246291', 'Matias', 'URU', 'M', '24/12/2000');
insert into Participante values ('KLD439349', 'Natalia', 'URU', 'F', '05/12/2002');
insert into Participante values ('SOE939232', 'Fernando', 'URU', 'M', '11/04/2001');
insert into Participante values ('DMV930214', 'Guillermo', 'URU', 'M', '15/09/1995');
insert into Participante values ('LVJ392921', 'Claudia', 'URU', 'F', '13/04/2000');
insert into Participante values ('MCK392014', 'Sofia', 'URU', 'F', '16/01/1994');
--Participantes argentinos
insert into Participante values ('PAS536144', 'Diego', 'ARG', 'M', '30/05/1996');
insert into Participante values ('VVS242950', 'Micaela', 'ARG', 'F', '02/01/1998');
insert into Participante values ('LDL349323', 'Cecilia', 'ARG', 'F', '22/03/1993');
insert into Participante values ('LDJ102022', 'Alex', 'ARG', 'M', '26/05/1993');
insert into Participante values ('AAK394824', 'Alan', 'ARG', 'M', '29/08/1996');
insert into Participante values ('LCJ239391', 'Helena', 'ARG', 'F', '16/10/2001');
insert into Participante values ('CNJ224291', 'Ezequiel', 'ARG', 'M', '11/06/1998');
insert into Participante values ('AKC355212', 'Alba', 'ARG', 'F', '12/06/1995');
--Participantes mexicanos
insert into Participante values ('AKD219392', 'Karina', 'MEX', 'F', '04/06/2002');
insert into Participante values ('FSK129294', 'German', 'MEX', 'M', '23/04/2003');
insert into Participante values ('FGG958483', 'Marina', 'MEX', 'F', '09/01/2001');
insert into Participante values ('PSL439349', 'Elias', 'MEX', 'M', '20/03/1998');
--Participantes brasileros
insert into Participante values ('ZKD393920', 'Carmen', 'BRA', 'F', '07/03/1995');
insert into Participante values ('OOL349320', 'Mateo', 'BRA', 'M', '29/12/1989');
insert into Participante values ('PAS045030', 'Bruno', 'BRA', 'M', '30/12/1994');
insert into Participante values ('PDC430340', 'Rodrigo', 'BRA', 'M', '11/09/1989');
--Participantes canadienses
insert into Participante values ('PLE494339', 'Roberto', 'CAN', 'M', '14/05/1985');
insert into Participante values ('LAN439392', 'Tomas', 'CAN', 'M', '02/01/1996');
insert into Participante values ('PEK329329', 'Antonio', 'CAN', 'M', '19/04/2000');
insert into Participante values ('KSL322351', 'Lucia', 'CAN', 'F', '12/02/2001');
insert into Participante values ('MCJ284910', 'Sasha', 'CAN', 'F', '14/05/2002');
insert into Participante values ('SDM294021', 'Zack', 'CAN', 'M', '13/12/1994');
insert into Participante values ('CJK923202', 'Cristian', 'CAN', 'M', '19/09/2000');
insert into Participante values ('DJI492910', 'Teo', 'CAN', 'M', '13/12/2001');
--Participantes estadounidenses
insert into Participante values ('KDS949393', 'Irina', 'USA', 'F', '17/04/1992');
insert into Participante values ('LOA493932', 'Jimena', 'USA', 'F', '06/05/1988');
insert into Participante values ('ALD239239', 'Ximena', 'USA', 'F', '11/11/2002');
insert into Participante values ('PXM438921', 'Juan', 'USA', 'M', '28/10/1989');
insert into Participante values ('SKN224291', 'Emma', 'USA', 'F', '12/01/1992');
insert into Participante values ('NCJ239249', 'Lucas', 'USA', 'M', '01/05/1988');
insert into Participante values ('CMJ292910', 'Martina', 'USA', 'F', '04/03/2002');
insert into Participante values ('CDL292401', 'Julieta', 'USA', 'F', '15/05/1989');
--Participantes paraguayos
insert into Participante values ('PEL349343', 'Sara', 'PAR', 'F', '10/10/1996');
insert into Participante values ('SMD239392', 'Teresa', 'PAR', 'F', '22/02/2001');
insert into Participante values ('AJD292012', 'Karen', 'PAR', 'F', '17/12/1998');
insert into Participante values ('FLJ943920', 'Leonardo', 'PAR', 'M', '05/02/1994');
--Participantes rusos
insert into Participante values ('EJF349843', 'Kiara', 'RUS', 'F', '01/09/1981');
insert into Participante values ('LON293932', 'Francisco', 'RUS', 'M', '15/12/1990');
insert into Participante values ('KFM332551', 'Rosa', 'RUS', 'F', '14/01/1990');
insert into Participante values ('KDM235314', 'Cintia', 'RUS', 'F', '04/10/1999');
--Participantes chilenos
insert into Participante values ('PWL439349', 'Susana', 'CHI', 'F', '03/07/1993');
insert into Participante values ('LAM101202', 'Alison', 'CHI', 'F', '14/04/1990');
insert into Participante values ('CLM349329', 'George', 'CHI', 'M', '16/09/1999');
insert into Participante values ('XMD342391', 'Celia', 'CHI', 'F', '12/03/1994');
--Participantes coreanos
insert into Participante values ('APS934002', 'Sofia', 'COR', 'F', '17/01/2001');
insert into Participante values ('OXK295001', 'Julian', 'COR', 'M', '03/12/1995');
insert into Participante values ('QQK204910', 'Antonio', 'COR', 'M', '24/03/1999');
insert into Participante values ('EIC920041', 'Araceli', 'COR', 'F', '12/06/1993');
--Participantes coreanos
insert into Participante values ('APS934002', 'Sofia', 'COR', 'F', '17/01/2001');
insert into Participante values ('OXK295001', 'Julian', 'COR', 'M', '03/12/1995');
insert into Participante values ('QQK204910', 'Antonio', 'COR', 'M', '24/03/1999');
insert into Participante values ('EIC920041', 'Araceli', 'COR', 'F', '12/06/1993');
--Participantes italianos
insert into Participante values ('CMI293018', 'Agustin', 'ITA', 'M', '17/05/1994');
insert into Participante values ('KFO392049', 'Irelia', 'ITA', 'F', '02/05/1994');
insert into Participante values ('LEM209491', 'Rina', 'ITA', 'F', '06/06/1991');
insert into Participante values ('EIX394023', 'Carlos', 'ITA', 'M', '05/05/1997');
--Participantes suecos
insert into Participante values ('ZZW940022', 'Franco', 'SUE', 'M', '28/08/1999');
insert into Participante values ('KGL933019', 'Amelia', 'SUE', 'F', '11/07/1995');
insert into Participante values ('XJE392049', 'Mirelia', 'SUE', 'F', '22/04/1994');
insert into Participante values ('RID400200', 'Sasha', 'SUE', 'F', '03/08/2001');
--Participantes ingleses
insert into Participante values ('EII930111', 'Karen', 'ING', 'F', '19/01/1999');
insert into Participante values ('DAA193004', 'Pamela', 'ING', 'F', '31/08/1993');
insert into Participante values ('HKD249103', 'Ernesto', 'ING', 'M', '06/08/1991');
insert into Participante values ('NIB930183', 'Taylor', 'ING', 'F', '05/02/1995');

insert into Participante values ('DKS9302500', 'Celia', 'CHI', 'F', '12/03/1994'); --Dato erroneo (Interfiere con check de pasaporte)
insert into Participante values ('DKSJ92001', 'Celia', 'CHI', 'F', '12/03/1994'); --Dato erroneo (Interfiere con check de pasaporte)
insert into Participante values ('182940392', 'Celia', 'CHI', 'F', '12/03/1994'); --Dato erroneo (Interfiere con check de pasaporte)
insert into Participante values ('CMK293018', 'Celia', 'CHI', 'N', '12/03/1994'); --Dato erroneo (Interfiere con check de sexo)
insert into Participante values ('CMK293018', 'Celia', 'CHI', 'F', '31/12/2022'); --Dato erroneo (Interfiere con check de fechaNac)
insert into Participante values ('CMK293018', 'Celia', 'CHI', 'F', '10/11/2023'); --Dato erroneo (Interfiere con check de fechaNac)

--Prueba TR_Nacionalidad:
--Insertar participante uruguayo en federacion uruguaya (Correcto)
insert into FederacionParticipante values ('Fed URU', 'AED123456', 15, 1202)
--Insertar participante argentino en federacion uruguaya (Dato erroneo)
insert into FederacionParticipante values ('Fed URU', 'PAS536144', 15, 1202)

--Datos Federacion:
insert into Federacion values ('Fed URU', 'URU');
insert into Federacion values ('Fed ARG', 'ARG');
insert into Federacion values ('Fed MEX', 'MEX');
insert into Federacion values ('Fed BRA', 'BRA');
insert into Federacion values ('Fed CAN', 'CAN');
insert into Federacion values ('Fed USA', 'USA');
insert into Federacion values ('Fed PAR', 'PAR');
insert into Federacion values ('Fed RUS', 'RUS');
insert into Federacion values ('Fed CHI', 'CHI');
insert into Federacion values ('Fed COR', 'COR');
insert into Federacion values ('Fed ITA', 'ITA');
insert into Federacion values ('Fed SUE', 'SUE');
insert into Federacion values ('Fed ING', 'ING');


--Datos FederacionParticipante:
insert into FederacionParticipante values ('Fed URU', 'AED123456', 30, 1130);
insert into FederacionParticipante values ('Fed URU', 'SJF232514', 28, 9992);
insert into FederacionParticipante values ('Fed URU', 'DFS246291', 33, 1203);
insert into FederacionParticipante values ('Fed URU', 'KLD439349', 39, 1443);
insert into FederacionParticipante values ('Fed URU', 'SOE939232', 18, 1942);
insert into FederacionParticipante values ('Fed URU', 'DMV930214', 19, 3924);
insert into FederacionParticipante values ('Fed URU', 'LVJ392921', 24, 1949);
insert into FederacionParticipante values ('Fed URU', 'MCK392014', 29, 1734);

insert into FederacionParticipante values ('Fed ARG', 'PAS536144', 27, 2463);
insert into FederacionParticipante values ('Fed ARG', 'VVS242950', 13, 1204);
insert into FederacionParticipante values ('Fed ARG', 'LDL349323', 29, 3040);
insert into FederacionParticipante values ('Fed ARG', 'LDJ102022', 30, 3204);
insert into FederacionParticipante values ('Fed ARG', 'AAK394824', 13, 3920);
insert into FederacionParticipante values ('Fed ARG', 'LCJ239391', 25, 1943);
insert into FederacionParticipante values ('Fed ARG', 'CNJ224291', 39, 1247);
insert into FederacionParticipante values ('Fed ARG', 'AKC355212', 20, 1583);


insert into FederacionParticipante values ('Fed MEX', 'AKD219392', 39, 3493);
insert into FederacionParticipante values ('Fed MEX', 'FSK129294', 44, 4030);
insert into FederacionParticipante values ('Fed MEX', 'FGG958483', 41, 3930);
insert into FederacionParticipante values ('Fed MEX', 'PSL439349', 29, 3020);

insert into FederacionParticipante values ('Fed BRA', 'ZKD393920', 38, 3929);
insert into FederacionParticipante values ('Fed BRA', 'OOL349320', 35, 3294);
insert into FederacionParticipante values ('Fed BRA', 'PAS045030', 32, 2948);
insert into FederacionParticipante values ('Fed BRA', 'PDC430340', 28, 2794);

insert into FederacionParticipante values ('Fed CAN', 'PLE494339', 26, 2849);
insert into FederacionParticipante values ('Fed CAN', 'LAN439392', 29, 3024);
insert into FederacionParticipante values ('Fed CAN', 'PEK329329', 20, 2034);
insert into FederacionParticipante values ('Fed CAN', 'KSL322351', 24, 1942);
insert into FederacionParticipante values ('Fed CAN', 'MCJ284910', 15, 2845);
insert into FederacionParticipante values ('Fed CAN', 'SDM294021', 17, 1933);
insert into FederacionParticipante values ('Fed CAN', 'CJK923202', 12, 1942);
insert into FederacionParticipante values ('Fed CAN', 'DJI492910', 26, 1362);


insert into FederacionParticipante values ('Fed USA', 'KDS949393', 35, 4039);
insert into FederacionParticipante values ('Fed USA', 'LOA493932', 39, 4294);
insert into FederacionParticipante values ('Fed USA', 'ALD239239', 43, 4930);
insert into FederacionParticipante values ('Fed USA', 'PXM438921', 29, 3849);
insert into FederacionParticipante values ('Fed USA', 'SKN224291', 25, 2483);
insert into FederacionParticipante values ('Fed USA', 'NCJ239249', 27, 1849);
insert into FederacionParticipante values ('Fed USA', 'CMJ292910', 16, 3829);
insert into FederacionParticipante values ('Fed USA', 'CDL292401', 17, 2840);


insert into FederacionParticipante values ('Fed PAR', 'PEL349343', 32, 2492); 
insert into FederacionParticipante values ('Fed PAR', 'SMD239392', 34, 2603); 
insert into FederacionParticipante values ('Fed PAR', 'AJD292012', 29, 2049); 
insert into FederacionParticipante values ('Fed PAR', 'FLJ943920', 25, 1849); 

insert into FederacionParticipante values ('Fed RUS', 'EJF349843', 25, 1492); 
insert into FederacionParticipante values ('Fed RUS', 'LON293932', 23, 1204); 
insert into FederacionParticipante values ('Fed RUS', 'KFM332551', 40, 2403); 
insert into FederacionParticipante values ('Fed RUS', 'KDM235314', 34, 2382); 

insert into FederacionParticipante values ('Fed CHI', 'PWL439349', 28, 1849);
insert into FederacionParticipante values ('Fed CHI', 'LAM101202', 20, 1203);
insert into FederacionParticipante values ('Fed CHI', 'CLM349329', 29, 1948);
insert into FederacionParticipante values ('Fed CHI', 'XMD342391', 35, 2739);

insert into FederacionParticipante values ('Fed COR', 'APS934002', 24, 1938);
insert into FederacionParticipante values ('Fed COR', 'OXK295001', 29, 1203);
insert into FederacionParticipante values ('Fed COR', 'QQK204910', 20, 1849);
insert into FederacionParticipante values ('Fed COR', 'EIC920041', 29, 1958);

insert into FederacionParticipante values ('Fed ITA', 'CMI293018', 22, 1957);
insert into FederacionParticipante values ('Fed ITA', 'KFO392049', 26, 1942);
insert into FederacionParticipante values ('Fed ITA', 'LEM209491', 21, 1583);
insert into FederacionParticipante values ('Fed ITA', 'EIX394023', 28, 2104);

insert into FederacionParticipante values ('Fed SUE', 'ZZW940022', 15, 2094);
insert into FederacionParticipante values ('Fed SUE', 'KGL933019', 19, 1958);
insert into FederacionParticipante values ('Fed SUE', 'XJE392049', 24, 1923);
insert into FederacionParticipante values ('Fed SUE', 'RID400200', 21, 2194);

insert into FederacionParticipante values ('Fed ING', 'EII930111', 11, 1953);
insert into FederacionParticipante values ('Fed ING', 'DAA193004', 26, 1963);
insert into FederacionParticipante values ('Fed ING', 'HKD249103', 14, 2193);
insert into FederacionParticipante values ('Fed ING', 'NIB930183', 18, 2294);

insert into FederacionParticipante values ('Fed ING', 'XJE930193', 0, 2193); --Dato erroneo (Interfiere con check de cantDiasPrep)
insert into FederacionParticipante values ('Fed ING', 'CVJ291003', -1, 2294); --Dato erroneo (Interfiere con check de cantDiasPrep)
insert into FederacionParticipante values ('Fed ING', 'XJE930193', 2, 0); --Dato erroneo (Interfiere con check de importeEstimado)
insert into FederacionParticipante values ('Fed ING', 'CVJ291003', 3, -1); --Dato erroneo (Interfiere con check de importeEstimado)

--Datos Competencia:
insert into Competencia values ('Competencia A', '18/12/2021', 'ARG');
insert into Competencia values ('Competencia B', '09/11/2022', 'RUS');
insert into Competencia values ('Competencia C', '02/12/2018', 'BRA');
insert into Competencia values ('Competencia D', '05/12/2019', 'USA');

insert into Competencia values ('Competencia E', '05/12/2023', 'USA'); --Dato erroneo (Interfiere con check de fechaYear)

--Datos CompetenciaFederacion:
insert into CompetenciaFederacion values ('Competencia A', 'Fed URU');
insert into CompetenciaFederacion values ('Competencia A', 'Fed ARG');
insert into CompetenciaFederacion values ('Competencia A', 'Fed CAN');
insert into CompetenciaFederacion values ('Competencia A', 'Fed USA');
insert into CompetenciaFederacion values ('Competencia A', 'Fed CHI');
insert into CompetenciaFederacion values ('Competencia A', 'Fed MEX');
insert into CompetenciaFederacion values ('Competencia A', 'Fed ING');


insert into CompetenciaFederacion values ('Competencia B', 'Fed URU');
insert into CompetenciaFederacion values ('Competencia B', 'Fed ARG');
insert into CompetenciaFederacion values ('Competencia B', 'Fed MEX');
insert into CompetenciaFederacion values ('Competencia B', 'Fed ITA');
insert into CompetenciaFederacion values ('Competencia B', 'Fed PAR');
insert into CompetenciaFederacion values ('Competencia B', 'Fed RUS');

insert into CompetenciaFederacion values ('Competencia C', 'Fed MEX');
insert into CompetenciaFederacion values ('Competencia C', 'Fed BRA');
insert into CompetenciaFederacion values ('Competencia C', 'Fed CAN');
insert into CompetenciaFederacion values ('Competencia C', 'Fed USA');
insert into CompetenciaFederacion values ('Competencia C', 'Fed SUE');
insert into CompetenciaFederacion values ('Competencia C', 'Fed COR');

insert into CompetenciaFederacion values ('Competencia D', 'Fed PAR');
insert into CompetenciaFederacion values ('Competencia D', 'Fed RUS');
insert into CompetenciaFederacion values ('Competencia D', 'Fed CHI');
insert into CompetenciaFederacion values ('Competencia D', 'Fed BRA');

--Datos Carrera:
insert into Carrera values (1, 500, 'De velocidad');
insert into Carrera values (2, 4000, 'De fondo');
insert into Carrera values (3, 3000, 'De Media Distancia');

insert into Carrera values (4, 3000, 'De'); --Dato erroneo (Tipo no existe) No se agrega

--Prueba TR_Carrera:
--Si la carrera es de velocidad la distancia puede variar entre 100 y 800 mtrs
--Si la carrera es de media distancia, la distancia debe ser entre 800 y 3000 mtrs
--Si la carrera es de fondo la distancia será mayor a 3000mtrs 
insert into Carrera values (5, 801, 'De velocidad'); --Dato erroneo
insert into Carrera values (6, 99, 'De velocidad'); --Dato erroneo
insert into Carrera values (7, 850, 'De velocidad'); --Dato erroneo
insert into Carrera values (8, 790, 'De Media Distancia'); --Dato erroneo
insert into Carrera values (9, 3002, 'De Media Distancia'); --Dato erroneo
insert into Carrera values (10, 2999, 'De fondo'); --Dato erroneo

--Datos Salto:
insert into Salto values (1, 'Altura')
insert into Salto values (2, 'Longitud')

insert into Salto values (3, 'Peso') --Dato erroneo (Interfiere con check de saltos)

--Datos Lanzamiento:
insert into Lanzamiento values (1, 'Peso')
insert into Lanzamiento values (2, 'Disco')
insert into Lanzamiento values (3, 'Jabalina')

insert into Lanzamiento values (4, 'Altura') --Dato erroneo (Interfiere con check de lanzamientos)

--Datos Disciplina:
insert into Disciplina values (1, 'Carrera', null, 1, null); --De velocidad
insert into Disciplina values (2, 'Carrera', null, 2, null); --De fondo
insert into Disciplina values (3, 'Carrera', null, 3, null); --De media distancia
insert into Disciplina values (4, 'Salto', 1, null, null); --Altura
insert into Disciplina values (5, 'Salto', 2, null, null); --Longitud
insert into Disciplina values (6, 'Lanzamiento', null, null, 1); --Peso
insert into Disciplina values (7, 'Lanzamiento', null, null, 2); --Disco
insert into Disciplina values (8, 'Lanzamiento', null, null, 3); --Jabalina

insert into Disciplina values (9, 'Disco', null, null, 3); --Dato erroneo (Interfiere con check de tipo)

delete Prueba where id=9
delete from PruebaParticipante where idPrueba=9
dbcc checkident (Prueba, reseed, 7);
--URU ARG CAN USA CHI MEX ING
--Pruebas para Competencia A, Carrera de Velocidad
insert into Prueba values ('06/03/2021', '06:43:02', '09:22:08', 'Montevideo', 'Competencia A', 1);
insert into PruebaParticipante values (1, 'SJF232514', 493, 1) --Uru
insert into PruebaParticipante values (1, 'LAM101202', 385, 3) --Chi
insert into PruebaParticipante values (1, 'DAA193004', 483, 2) --Ing
insert into PruebaParticipante values (1, 'VVS242950', 285, 4) --Arg

--Pruebas para Competencia A, Carrera de fondo
insert into Prueba values ('20/04/2021', '10:14:44', '11:30:21', 'Montevideo', 'Competencia A', 2);
insert into PruebaParticipante values (2, 'CLM349329', 3840, 1) --Chi
insert into PruebaParticipante values (2, 'DAA193004', 3456, 2) --Ing
insert into PruebaParticipante values (2, 'KSL322351', 3264, 3) --Can
insert into PruebaParticipante values (2, 'SJF232514', 3234, 4) --Uru

--Pruebas para Competencia A, Carrera de Media Distancia
insert into Prueba values ('05/03/2021', '07:24:44', '10:48:05', 'Montevideo', 'Competencia A', 3);
insert into PruebaParticipante values (3, 'LAM101202', 395, 3) --Chi
insert into PruebaParticipante values (3, 'FSK129294', 848, 1) --Mex
insert into PruebaParticipante values (3, 'CMJ292910', 283, 4) --Usa
insert into PruebaParticipante values (3, 'DAA193004', 758, 2) --Ing

--Pruebas para Competencia A, Salto de Altura
insert into Prueba values ('11/06/2021', '15:43:02', '17:22:08', 'Montevideo', 'Competencia A', 4);
insert into PruebaParticipante values (4, 'LCJ239391', 14, 3) --Arg
insert into PruebaParticipante values (4, 'FGG958483', 24, 1) --Chi
insert into PruebaParticipante values (4, 'HKD249103', 12, 4) --Ing
insert into PruebaParticipante values (4, 'PXM438921', 17, 2) --Usa

--Pruebas para Competencia A, Salto de Longitud
insert into Prueba values ('28/04/2021', '11:43:02', '14:22:08', 'Montevideo', 'Competencia A', 5);
insert into PruebaParticipante values (5, 'LAN439392', 10, 3) --Can
insert into PruebaParticipante values (5, 'LVJ392921', 14, 2) --Uru
insert into PruebaParticipante values (5, 'LAM101202', 9, 4) --Chi
insert into PruebaParticipante values (5, 'EII930111', 15, 1) --Ing

--Pruebas para Competencia A, Lanzamiento de Peso
insert into Prueba values ('05/01/2021', '18:43:02', '20:22:08', 'Montevideo', 'Competencia A', 6);
insert into PruebaParticipante values (6, 'LAM101202', 5, 4) --Chi 
insert into PruebaParticipante values (6, 'AKC355212', 13, 2) --Arg
insert into PruebaParticipante values (6, 'DAA193004', 14, 1) --Ing
insert into PruebaParticipante values (6, 'MCJ284910', 7, 3) --Can

--Pruebas para Competencia A, Lanzamiento de Disco
insert into Prueba values ('29/06/2021', '12:43:02', '14:22:08', 'Montevideo', 'Competencia A', 7);
insert into PruebaParticipante values (7, 'SJF232514', 15, 4) --Uru
insert into PruebaParticipante values (7, 'LDL349323', 12, 3) --Arg
insert into PruebaParticipante values (7, 'NIB930183', 8, 1) --Ing
insert into PruebaParticipante values (7, 'PWL439349', 14, 2) --Chi

--Pruebas para Competencia A, Lanzamiento de Jabalina
insert into Prueba values ('06/11/2021', '16:43:02', '17:22:08', 'Montevideo', 'Competencia A', 8);
insert into PruebaParticipante values (8, 'NCJ239249', 12, 2) --Usa
insert into PruebaParticipante values (8, 'PSL439349', 11, 3) --Mex
insert into PruebaParticipante values (8, 'DAA193004', 16, 1) --Ing
insert into PruebaParticipante values (8, 'XMD342391', 9, 4) --Chi

--URU ARG MEX ITA PAR RUS
--Pruebas para Competencia B, Carrera de Velocidad
insert into Prueba values ('06/11/2022', '14:40:33', '20:22:08', 'Montevideo', 'Competencia B', 1);
insert into PruebaParticipante values (9, 'AJD292012', 384, 3) --Par
insert into PruebaParticipante values (9, 'KFO392049', 284, 4) --Ita
insert into PruebaParticipante values (9, 'SJF232514', 759, 1) --Uru
insert into PruebaParticipante values (9, 'AKC355212', 685, 2) --Arg

--Pruebas para Competencia B, Carrera de Fondo
insert into Prueba values ('18/05/2022', '16:46:04', '18:06:33', 'Montevideo', 'Competencia B', 2);
insert into PruebaParticipante values (10, 'SJF232514', 2032, 4) --Uru
insert into PruebaParticipante values (10, 'LDL349323', 3000, 2) --Arg
insert into PruebaParticipante values (10, 'FSK129294', 2382, 3) --Mex
insert into PruebaParticipante values (10, 'KFO392049', 3024, 1) --Ita

--Pruebas para Competencia B, Carrera de Media Distancia
insert into Prueba values ('12/05/2022', '21:12:54', '21:34:53', 'Montevideo', 'Competencia B', 3);
insert into PruebaParticipante values (11, 'AJD292012', 833, 4) --Par
insert into PruebaParticipante values (11, 'KFO392049', 853, 3) --Ita
insert into PruebaParticipante values (11, 'AKD219392', 1834, 1) --Mex
insert into PruebaParticipante values (11, 'MCK392014', 1300, 2) --Uru

--Pruebas para Competencia B, Salto de Altura
insert into Prueba values ('26/07/2022', '21:12:54', '21:34:53', 'Montevideo', 'Competencia B', 4);
insert into PruebaParticipante values (12, 'KFO392049', 14, 2) --Ita
insert into PruebaParticipante values (12, 'AAK394824', 5, 4) --Arg
insert into PruebaParticipante values (12, 'EJF349843', 15, 1) --Rus
insert into PruebaParticipante values (12, 'PSL439349', 10, 3) --Mex

--Pruebas para Competencia B, Salto de Longitud
insert into Prueba values ('26/03/2022', '18:43:02', '20:22:08', 'Montevideo', 'Competencia B', 5);
insert into PruebaParticipante values (13, 'LDL349323', 15, 2) --Arg
insert into PruebaParticipante values (13, 'LVJ392921', 10, 3) --Uru
insert into PruebaParticipante values (13, 'FLJ943920', 16, 1) --Par
insert into PruebaParticipante values (13, 'KFO392049', 6, 4) --Ita

--Pruebas para Competencia B, Lanzamiento de Peso
insert into Prueba values ('17/02/2022', '18:43:02', '21:34:53', 'Montevideo', 'Competencia B', 6);
insert into PruebaParticipante values (14, 'SJF232514', 13, 2) --Uru
insert into PruebaParticipante values (14, 'LEM209491', 16, 1) --Ita
insert into PruebaParticipante values (14, 'LON293932', 9, 4) --Rus
insert into PruebaParticipante values (14, 'FSK129294', 12, 3) --Mex

--Pruebas para Competencia B, Lanzamiento de Disco
insert into Prueba values ('13/07/2022', '14:40:33', '16:04:55', 'Montevideo', 'Competencia B', 7);
insert into PruebaParticipante values (15, 'PSL439349', 15, 2) --Mex
insert into PruebaParticipante values (15, 'KFO392049', 16, 1) --Ita
insert into PruebaParticipante values (15, 'SMD239392', 9, 4) --Par
insert into PruebaParticipante values (15, 'LVJ392921', 13, 3) --Uru

--Pruebas para Competencia B, Lanzamiento de Jabalina
insert into Prueba values ('11/08/2022', '14:40:33', '16:04:55', 'Montevideo', 'Competencia B', 8);
insert into PruebaParticipante values (16, 'LVJ392921', 13, 3) --Uru
insert into PruebaParticipante values (16, 'CNJ224291', 16, 2) --Arg
insert into PruebaParticipante values (16, 'KFO392049', 9, 4) --Ita
insert into PruebaParticipante values (16, 'EJF349843', 18, 1) --Rus

--MEX BRA CAN USA SUE COR
--Pruebas para Competencia C, Carrera de velocidad
insert into Prueba values ('02/02/2018', '11:30:12', '16:04:21', 'Rio de Janeiro', 'Competencia C', 1);
insert into PruebaParticipante values (17, 'FSK129294', 423, 1) --mex
insert into PruebaParticipante values (17, 'PAS045030', 294, 3) --bra
insert into PruebaParticipante values (17, 'QQK204910', 184, 4) --cor
insert into PruebaParticipante values (17, 'LOA493932', 356, 2) --usa

--Pruebas para Competencia C, Carrera de fondo
insert into Prueba values ('06/02/2018', '14:30:12', '16:04:21', 'Rio de Janeiro', 'Competencia C', 2);
insert into PruebaParticipante values (18, 'OXK295001', 2943, 3) --cor
insert into PruebaParticipante values (18, 'KGL933019', 4583, 1) --sue
insert into PruebaParticipante values (18, 'SDM294021', 3839, 2) --can
insert into PruebaParticipante values (18, 'SKN224291', 2934, 4) --usa

--Pruebas para Competencia C, Carrera de Media Distancia
insert into Prueba values ('18/02/2018', '09:15:22', '11:05:05', 'Rio de Janeiro', 'Competencia C', 3);
insert into PruebaParticipante values (19, 'RID400200', 2053, 3) --sue
insert into PruebaParticipante values (19, 'PAS045030', 2943, 1) --bra
insert into PruebaParticipante values (19, 'PEK329329', 1593, 4) --can
insert into PruebaParticipante values (19, 'LOA493932', 2934, 2) --usa

--Pruebas para Competencia C, Salto de Altura
insert into Prueba values ('11/03/2018', '06:22:03', '08:10:23', 'Rio de Janeiro', 'Competencia C', 4);
insert into PruebaParticipante values (20, 'PSL439349', 25, 1) --mex
insert into PruebaParticipante values (20, 'PDC430340', 15, 3) --bra
insert into PruebaParticipante values (20, 'MCJ284910', 17, 2) --can
insert into PruebaParticipante values (20, 'PXM438921', 13, 4) --usa

--Pruebas para Competencia C, Salto de Longitud
insert into Prueba values ('04/03/2018', '07:22:03', '09:10:23', 'Rio de Janeiro', 'Competencia C', 5);
insert into PruebaParticipante values (21, 'EIC920041', 15, 4) --cor
insert into PruebaParticipante values (21, 'KGL933019', 16, 3) --sue
insert into PruebaParticipante values (21, 'KSL322351', 19, 2) --can
insert into PruebaParticipante values (21, 'SKN224291', 22, 1) --usa

--Pruebas para Competencia C, Lanzamiento de peso
insert into Prueba values ('04/05/2018', '09:05:22', '11:04:22', 'Rio de Janeiro', 'Competencia C', 6);
insert into PruebaParticipante values (22, 'FSK129294', 103, 1) --mex
insert into PruebaParticipante values (22, 'OOL349320', 95, 2) --bra
insert into PruebaParticipante values (22, 'KGL933019', 58, 4) --sue
insert into PruebaParticipante values (22, 'ALD239239', 69, 3) --usa

--Pruebas para Competencia C, Lanzamiento de Disco
insert into Prueba values ('14/05/2018', '13:26:22', '18:04:22', 'Rio de Janeiro', 'Competencia C', 7);
insert into PruebaParticipante values (23, 'PSL439349', 129, 1) --mex
insert into PruebaParticipante values (23, 'PDC430340', 121, 2) --bra
insert into PruebaParticipante values (23, 'APS934002', 74, 4) --cor
insert into PruebaParticipante values (23, 'ALD239239', 95, 3) --usa

--Pruebas para Competencia C, Lanzamiento de Jabalina
insert into Prueba values ('26/05/2018', '10:26:22', '11:10:53', 'Rio de Janeiro', 'Competencia C', 8);
insert into PruebaParticipante values (24, 'AKD219392', 95, 3) --mex
insert into PruebaParticipante values (24, 'KGL933019', 132, 1) --sue
insert into PruebaParticipante values (24, 'KSL322351', 84, 4) --can
insert into PruebaParticipante values (24, 'LOA493932', 104, 2) --usa

--Dato erroneo (Interfiere con check de hora, hora de inicio no puede ser mayor a hora de fin)
insert into Prueba values ('26/05/2018', '13:26:22', '11:10:53', 'Rio de Janeiro', 'Competencia C', 8);
--Dato erroneo (Interfiere con check de dia, dia debe ser mayor a 0)
insert into Prueba values ('26/05/2023', '10:26:22', '11:10:53', 'Rio de Janeiro', 'Competencia C', 8); 

--Dato erroneo (Interfiere con check de posicion, posicion debe ser mayor a 0)
insert into PruebaParticipante values (24, 'LOA493932', 104, 0) --usa
insert into PruebaParticipante values (24, 'LOA493932', 104, -1) --usa