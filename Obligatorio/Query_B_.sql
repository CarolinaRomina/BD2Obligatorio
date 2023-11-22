use ObligatorioBD_275251
--1:
--a. Mostrar los datos de los participantes que han ganado mas de 1 carreras de
--velocidad, pero nunca ganaron carreras de fondo en los últimos 3 años.

select Participante.idParticipante from (
	select count(pp.posicion) as Cantidad, pp.idParticipante
	from PruebaParticipante pp, Prueba pr, Disciplina d, Carrera c
	where pp.idPrueba=pr.id and pr.idDisciplina=d.id and d.idCarrera=c.id and c.tipo='De velocidad'
	and pp.posicion=1 and pp.idParticipante not in
	(
		select pp.idParticipante
		from PruebaParticipante pp, Prueba pr, Disciplina d, Carrera c
		where pp.idPrueba=pr.id and pr.idDisciplina=d.id and d.idCarrera=c.id and c.tipo='De fondo' and datediff(year, pr.dia, getdate())>=3
	)
	group by pp.idParticipante
	having count(pp.posicion)>1
	)
as Participante

--2:
--Mostrar los datos de la federación que ha participado en todas las disciplinas el año
--pasado, pero no así este año 

select LastYear.idFederacion
from
(
	select count(pr.idDisciplina) as Disciplinas, fp.idFederacion
	from FederacionParticipante fp, PruebaParticipante pp, Prueba pr
	where pp.idParticipante=fp.idParticipante and pp.idPrueba=pr.id and year(pr.dia)='2021'
	group by fp.idFederacion
	having count(pr.idDisciplina) >=all 
	(select count(pr.idDisciplina) from Prueba pr where year(pr.dia)='2021')
) as LastYear
where LastYear.idFederacion not in
(
	select ThisYear.idFederacion from
	(
		select count(pr.idDisciplina) as Disciplinas, fp.idFederacion
		from FederacionParticipante fp, PruebaParticipante pp, Prueba pr
		where pp.idParticipante=fp.idParticipante and pp.idPrueba=pr.id and year(pr.dia)='2022'
		group by fp.idFederacion
		having count(pr.idDisciplina) >=all 
		(select count(pr.idDisciplina) from Prueba pr where year(pr.dia)='2022')
	) as ThisYear
)

--c. Mostrar los datos de la última prueba jugada, en la salida deben aparecer los nombres
--de los participantes y su nacionalidad

select pa.nombre, pa.nacionalidad
from PruebaParticipante pp, Participante pa, Prueba pr
where pp.idParticipante=pa.pasaporte and pr.id=pp.idPrueba
and pr.dia >= all (select pr.dia from Prueba pr)
group by pp.idPrueba, pa.nombre, pa.nacionalidad, pr.dia

--d. Mostrar los datos de los participantes uruguayos que superaron alguna de sus marcas
--este año respecto a los del año pasado. Se considera marca: al mejor tiempo en caso
--de carreras y mayor distancia en los saltos o lanzamientos
select max(pp.resultado), pp.idParticipante, pr.id
from PruebaParticipante pp, Prueba pr, Disciplina d
where pp.idPrueba=pr.id and pr.idDisciplina=d.id and year(pr.dia)='2022'
group by pp.idParticipante, pp.idPrueba, pr.id, d.id
having max(pp.resultado) > (
							select max(pp1.resultado) from PruebaParticipante pp1, Prueba pr2, Disciplina d1
							where pp1.idPrueba=pr2.id and pp1.idParticipante=pp.idParticipante and pr2.idDisciplina=d1.id
							and d1.id=d.id
							and year(pr2.dia)='2021' group by pp1.idParticipante, d1.id)

--e. Mostrar para cada federación que está compitiendo en la competencia del año actual, la
--cantidad de pruebas ganadas, y la cantidad de pruebas en que participo para cada
--disciplina. Puede usar funciones auxiliares en la solución.

select a.idFederacion, a.Carreras, a.Lanzamientos, a.Saltos, b.CantidadGanadas from 
	(
	select distinct federaciones.idFederacion, count(federaciones.idCarrera) as Carreras, count(federaciones.idLanzamiento) as Lanzamientos, count(federaciones.idSalto) as Saltos
	from
	(
	select cf.idFederacion, d.idCarrera, d.idLanzamiento, d.idSalto
	from CompetenciaFederacion cf, Competencia c, Prueba pr, Disciplina d
	where cf.idCompetencia=c.nombre and year(c.fechaYear)='2022' and pr.nombreCompeticion=c.nombre and pr.idDisciplina=d.id
	) as federaciones
	group by federaciones.idFederacion
	) as a
	left join 
	(
	select SelectFederacionesGanadoras.idFederacion, count(SelectFederacionesGanadoras.idFederacion) as CantidadGanadas from
	(
		select fp.idFederacion
		from PruebaParticipante pp, FederacionParticipante fp, Prueba pr
		where fp.idParticipante=pp.idParticipante and pr.id=pp.idPrueba and pp.idPrueba in
		(select pp.idPrueba from PruebaParticipante pp, Competencia c, Prueba pr where pr.id=pp.idPrueba and pr.nombreCompeticion=c.nombre and year(c.fechaYear)='2022')
		group by pp.resultado, fp.idFederacion, pr.id
		having pp.resultado >= all
		(
			select pp2.resultado from Prueba pr2, PruebaParticipante pp2 where pr.id=pr2.id and pr.id=pp2.idPrueba
			group by pp2.resultado
		)
	) as SelectFederacionesGanadoras
group by SelectFederacionesGanadoras.idFederacion) as b
on a.idFederacion=b.idFederacion

--f. Mostrar para cada participante de la federación uruguaya, cantidad de disciplinas en las
--que ha participado, la cantidad total de metros recorridos en carreras, el mejor tiempo
--puesto en carreras, la ultima carrera realizada. En la salida deben aparecer todos los
--participantes, 
select a.idParticipante, a.CantidadDisciplinas, b.TotalMetros, b.MejorTiempo, b.UltimaCarrera from
(
select pp.idParticipante, count(d.id) as CantidadDisciplinas
from FederacionParticipante fp, PruebaParticipante pp, Prueba pr, Disciplina d
where pp.idParticipante=fp.idParticipante and pp.idPrueba=pr.id and pr.idDisciplina=d.id and fp.idFederacion='Fed URU'
group by pp.idParticipante) as A
left join
(
select fp.idParticipante, sum (pp.resultado) as TotalMetros, max(pp.resultado) as MejorTiempo, max(pr.dia) as UltimaCarrera
from FederacionParticipante fp, Prueba pr, Disciplina d, PruebaParticipante pp
where pp.idParticipante=fp.idParticipante and pp.idPrueba=pr.id and pr.idDisciplina=d.id and d.tipo='Carrera' and fp.idFederacion='Fed URU'
group by fp.idParticipante) as B
on a.idParticipante=b.idParticipante