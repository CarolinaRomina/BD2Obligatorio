--Los participantes solo pueden competir como representante de su paísgo
create trigger TR_Nacionalidad
on FederacionParticipante
Instead of Insert
AS
BEGIN
declare @ParticipanteDePais char(9)
select @ParticipanteDePais = isnull(i.idParticipante, '') from Inserted i, Participante p, Federacion f
where p.pasaporte=i.idParticipante and f.nombre=i.idFederacion and f.codPais=p.nacionalidad
if @ParticipanteDePais !=''
begin
	insert into FederacionParticipante select i.idFederacion, i.idParticipante, i.cantDiasPrep, i.importeEstimado
	from Inserted i
end
end
--Si la carrera es de velocidad la distancia puede variar entre 100 y 800 mtrs
--Si la carrera es de media distancia, la distancia debe ser entre 800 y 3000 mtrs
--Si la carrera es de fondo la distancia será mayor a 3000mtrs 
go
create trigger TR_Carrera
on Carrera
Instead of Insert
AS
BEGIN
	declare @metros int;
	declare @tipo varchar(20);
	select @metros=i.metros from Inserted i 
	select @tipo=i.tipo from Inserted i
	if (@tipo='De velocidad' and @metros>=100 and @metros<=800)
		BEGIN
		Insert into Carrera 
		select I.* from Inserted I
		END
	if (@tipo='De Media Distancia' and @metros>=800 and @metros<=3000)
		BEGIN
		Insert into Carrera 
		select I.* from Inserted I
		END
	if (@tipo='De fondo' and @metros>3000)
		BEGIN
		Insert into Carrera
		select I.* from Inserted I
		END
END

--a. Implementar un disparador que cada vez que se agreguen o modifiquen pruebas se
--cumplan las restricciones de nacionalidad entre los datos participantes. No pueden
--competir entre si participantes de la misma federación. Considerar múltiples registros. 
go
create trigger TR_Participante on PruebaParticipante
Instead of insert, update
as
begin
DECLARE @Operation VARCHAR(15)
DECLARE @Encontrado varchar(9)
DECLARE @FederacionParticipante varchar(30)
IF EXISTS (SELECT * FROM inserted)
BEGIN
	IF EXISTS (SELECT * FROM deleted)
	BEGIN 
			SELECT @Operation = 'UPDATE'
	END ELSE
	BEGIN
		SELECT @Operation = 'INSERT'
	END
END
if @Operation = 'INSERT'
	select @FederacionParticipante = fp.idFederacion from FederacionParticipante fp,inserted i
	where fp.idParticipante = i.idParticipante;

	select @Encontrado = ISNULL(pp.idParticipante,'') 
	from PruebaParticipante pp,inserted i,FederacionParticipante fp 
	where pp.idPrueba = i.idPrueba and fp.idFederacion = @FederacionParticipante
	and fp.idParticipante != i.idParticipante;

	IF @Encontrado = ''
	BEGIN
	insert into PruebaParticipante select i.idParticipante,i.idPrueba,i.posicion,i.resultado from inserted i
	END
if @Operation = 'UPDATE'

	select @FederacionParticipante = fp.idFederacion from FederacionParticipante fp,inserted i
	where fp.idParticipante = i.idParticipante;

	select @Encontrado = ISNULL(pp.idParticipante,'') 
	from PruebaParticipante pp,inserted i,FederacionParticipante fp 
	where pp.idPrueba = i.idPrueba and fp.idFederacion = @FederacionParticipante
	and fp.idParticipante != i.idParticipante;

	IF @Encontrado = ''
	BEGIN
	update PruebaParticipante set idPrueba=i.idPrueba, idParticipante=i.idParticipante,
	resultado=i.resultado, posicion=i.posicion from Inserted i
	END

end

--Prueba:
insert into PruebaParticipante values (1, 'LVJ392921', 493, 1)
update PruebaParticipante set idParticipante='LVJ392921' where idPrueba=1 and idParticipante='SJF232514'

--Implementar un disparador que controle que solo se puedan eliminar participantes de
--una federación en una competencia siempre que este no haya participado de alguna
--prueba y en tal caso se guarde registro en una tabla de auditoría de la eliminación
--realizada, quien hizo la eliminación y cuando. El esquema de la tabla de auditoria debe
--ser definido por el estudiante. El estudiante debe asegurarse que solo pueda eliminar de
--aun registro por vez.
GO
create trigger TR_DELETE on FederacionParticipante
instead of delete
as
Begin
declare @IdParticipante char(9)
select @IdParticipante = d.idParticipante from Deleted d
if not exists(select pp.idParticipante from PruebaParticipante pp where pp.idParticipante=@IdParticipante)
	begin
		delete from FederacionParticipante where FederacionParticipante.idParticipante=@IdParticipante;
		insert into AuditoriaParticipante values (getdate(), user, @IdParticipante, 'Delete')
	end
end

--Prueba
--Eliminar participante que no participo en una prueba:
delete from FederacionParticipante where idParticipante='XMD342391'
--Eliminar participante que si participo en una prueba:
delete from FederacionParticipante where idParticipante='LDL349323'
