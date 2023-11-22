use ObligatorioBD_275251

--a. Implementar una función que, dado una competencia, una federación y un participante
--devuelva el importe de ganancia o pérdida que dejo el participante. Para este cálculo
--tener presente que la federación recibe 1000 euros por cada primer puesto en cada
--disciplina, 500 por cada segundo puesto, y 200 por cada tercer puesto

go
create function FN_C (@nomComp varchar(30), @fedNom varchar(30), @pasaportPart char(9)) returns int
AS
BEGIN
	declare @Importe int
	declare @CantidadPrimero int
	declare @CantidadSegundo int
	declare @CantidadTercero int
	select @CantidadPrimero= count(pp.idParticipante)
	from PruebaParticipante pp, FederacionParticipante fp, Prueba pr
	where pp.idParticipante=fp.idParticipante and fp.idFederacion=@fedNom and pr.id=pp.idPrueba
	and pr.nombreCompeticion=@nomComp and pp.idParticipante=@pasaportPart and pp.posicion=1
	group by pp.idParticipante

	select @CantidadSegundo = count(pp.idParticipante)
	from PruebaParticipante pp, FederacionParticipante fp, Prueba pr
	where pp.idParticipante=fp.idParticipante and fp.idFederacion=@fedNom and pr.id=pp.idPrueba
	and pr.nombreCompeticion=@nomComp and pp.idParticipante=@pasaportPart and pp.posicion=2
	group by pp.idParticipante

	select @CantidadTercero = count(pp.idParticipante)
	from PruebaParticipante pp, FederacionParticipante fp, Prueba pr
	where pp.idParticipante=fp.idParticipante and fp.idFederacion=@fedNom and pr.id=pp.idPrueba
	and pr.nombreCompeticion=@nomComp and pp.idParticipante=@pasaportPart and pp.posicion=3
	group by pp.idParticipante
	set @Importe = (1000 * isnull(@CantidadPrimero, 0)) + (500 * isnull(@CantidadSegundo, 0)) + (200 * isnull(@CantidadTercero, 0))
	return @Importe
END
		
declare @competencia varchar(30)
declare @federacion varchar(30)
declare @participante char(9)
declare @funcion int
set @competencia = 'Competencia A'
set @federacion = 'Fed ARG'
set @Participante = 'LDL349323' 
set @funcion = dbo.FN_C(@competencia, @federacion, @participante)

Print 'Funcion: ' + Convert(varchar(12),@funcion);

select dbo.FN_C('Competencia C', 'Fed MEX', 'PSL439349')


--b. Escribir un procedimiento almacenado que, dado una federación, una disciplina y un
--rango de fechas devuelva: el mejor participante que tuvo esa federación en dicha
--disciplina en ese rango de fechas, el porcentaje de pruebas ganadas en dicha disciplina
--(cantidad de pruebas que gano / cantidad en las que participo), y si también fue el mejor
--en alguna otra disciplina.
go
create procedure P_2 (@Federacion varchar(30), @Disciplina int, @Fecha1 date, @Fecha2 date, @MejorParticipante char(9) output,  @PorcentajeGanadas decimal output, @OtraDisciplina int output)
as
begin
	
	select @MejorParticipante = MejorParticipante.idParticipante from
	(
		select top 1 pp.posicion,pp.idParticipante  
		from PruebaParticipante pp, FederacionParticipante fp, Prueba pr 
		where pp.idPrueba=pr.id and fp.idParticipante=pp.idParticipante and fp.idFederacion=@Federacion
		and pr.idDisciplina=@Disciplina and pr.id=pp.idPrueba
		and pr.dia between @Fecha1 and @Fecha2 
		order by pp.posicion asc
	) as MejorParticipante

	IF NULLIF(@MejorParticipante, '') IS NULL
	set @MejorParticipante = ''

	declare @CantidadGanadas int
	select @CantidadGanadas = count(cant.id) from
	( 
	select pr.id from PruebaParticipante pp, Prueba pr,FederacionParticipante fp
	where pp.idPrueba=pr.id and pr.idDisciplina=@Disciplina and fp.idParticipante = pp.idParticipante
	and fp.idFederacion = @Federacion and pp.posicion = 1
	and pp.idParticipante=@MejorParticipante
	group by pr.id ) as cant

	declare @CantidadPruebas int
	select @CantidadPruebas = count(pp.posicion)
	from PruebaParticipante pp, Prueba pr,FederacionParticipante fp
	where pp.idPrueba=pr.id and pr.idDisciplina=@Disciplina and fp.idParticipante=pp.idParticipante
	and fp.idParticipante = @MejorParticipante and fp.idFederacion = @Federacion 
	group by fp.idFederacion
	
	set @PorcentajeGanadas = ISNULL(@CantidadGanadas * 100 / NULLIF(@CantidadPruebas, 0), 0)

	if @MejorParticipante in (select top 1 pp.idParticipante
				from PruebaParticipante pp, FederacionParticipante fp, Prueba pr, Disciplina d
				where pp.idParticipante=pp.idParticipante and fp.idFederacion=@Federacion and pr.idDisciplina!=@Disciplina and pr.id=pp.idPrueba 
				order by pp.posicion asc)
	Begin
		set @OtraDisciplina = 1
	End
	else
	Begin
		set @OtraDisciplina = 0
	End
end

declare @mejor char(9);
declare @percentage decimal;
declare @otra int;
exec dbo.P_2 'Fed URU', 1, '2021-02-06', '2021-07-06', @mejor output, @percentage output, @otra output
print 'Participante: ' +  @mejor
print 'Porcentaje: ' + convert (varchar(20),  @percentage)
print 'Gano otra disciplina: (Si 1, No 0) ' + convert(char(1), @otra)