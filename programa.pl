% Parcial Age Of Empires II

% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).      % unidad(Unidad, Cantidad)
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).    % recurso(Madera, Alimento, Oro)
tiene(aleP, edificio(casa, 40)).        % edificio(Tipo, Cantidad)
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% De las unidades sabemos que pueden ser militares o aldeanos

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

% 1) Definir el predicado esUnAfano/2, que nos dice si al jugar
% el primero contra el segundo, la diferencia de rating entre 
% el primero y el segundo es mayor a 500.

esUnAfano(JugadorA, JugadorB) :-
    jugador(JugadorA, RatingA, _),
    jugador(JugadorB, RatingB, _),
    abs(RatingA - RatingB) > 500.   % Pueden usar el predicado abs/2, que relaciona al primer número con su valor absoluto

/*
2) Definir el predicado esEfectivo/2, que relaciona dos unidades si 
la primera puede ganarle a la otra según su categoría, 
dado por el siguiente piedra, papel o tijeras:
- a) La caballería le gana a la arquería.
- b) La arquería le gana a la infantería.
- c) La infantería le gana a los piqueros.
- d) Los piqueros le ganan a la caballería.
Por otro lado, los Samuráis son efectivos contra otras unidades 
únicas (incluidos los samurái). Los aldeanos nunca son efectivos 
contra otras unidades
*/

% LOS QUE TIENEN CATEGORIA SON LOS MILITARES

esEfectivo(UnidadA, UnidadB) :-
    militar(UnidadA, _, CategoriaA),
    militar(UnidadB, _, CategoriaB),
    leGana(CategoriaA, CategoriaB).

esEfectivo(samurai, UnidadB) :-
    militar(UnidadB, _, unica).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).


% 3) Definir el predicado alarico/1 que se cumple para un jugador 
% si solo tiene unidades de infantería

alarico(Jugador) :-
    tiene(Jugador, _),
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad, _, infanteria)).

esDeInfanteria(Unidad) :- militar(Unidad, _, infanteria).    

% 4) Definir el predicado leonidas/1, que se cumple para un jugador
% si solo tiene unidades de piqueros.

leonidas(Jugador) :-
    tiene(Jugador, _),
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad, _, piquero)).

esPiquero(Unidad) :- militar(Unidad, _, piquero).

% 5) Definir el predicado nomada/1, que se cumple para un jugador 
% si no tiene casas

nomada(Jugador) :-
   tiene(Jugador, _),
   not(tiene(Jugador, edificio(casa, _))). 

% 6) Definir el predicado cuantoCuesta/2, que relaciona una 
% unidad o edificio con su costo. De las unidades militares y de los
% edificios conocemos sus costos. Los aldeanos cuestan 50 unidades 
% de alimento. Las carretas y urnas mercantes cuestan 100 
% unidades de madera y 50 de oro cada una.

cuantoCuesta(Unidad, Costo) :-      % creo que es innecesario esto
    costoSegunUnidad(Unidad, Costo).

costoSegunUnidad(Unidad, Costo) :-
    militar(Unidad, Costo, _).

costoSegunUnidad(Unidad, costo(0, 50, 0)) :-
    aldeano(Unidad, _).

costoSegunUnidad(Edificio, Costo) :-
    edificio(Edificio, Costo).

costoSegunUnidad(Unidad, costo(100, 0, 50)) :- 
    esCarretaOUrnaMercante(Unidad).

esCarretaOUrnaMercante(carreta).
esCarretaOUrnaMercante(urnaMercante).
       
%unidad(Unidad) :- tiene(_, unidad(Unidad, _)).
%unidad(Unidad) :- tiene(_, edificio(Unidad, _)).

% 7) Definir el predicado produccion/2, que relaciona una unidad 
% con su producción de recursos por minuto. De los aldeanos, 
% según su profesión, se conoce su producción. Las carretas 
% y urnas mercantes producen 32 unidades de oro por minuto. 
% Las unidades militares no producen ningún recurso, 
% salvo los Keshiks, que producen 10 de oro por minuto.

produccion(Unidad, Produccion) :- % produccion de Recursos Por minuto
    produccionSegunUnidad(Unidad, Produccion).

produccionSegunUnidad(Unidad, Recursos) :-
    aldeano(Unidad, Recursos).

produccionSegunUnidad(Unidad, produce(0, 0, 32)) :-
    esCarretaOUrnaMercante(Unidad).

produccionSegunUnidad(keshik, produce(0, 0, 10)).

produccionSegunUnidad(Unidad, produce(0, 0, 0)) :-
    militar(Unidad, _, _), Unidad \= keshik.

% 8) Definir el predicado produccionTotal/3 que relaciona a un jugador
% con su producción total por minuto de cierto recurso, que se calcula
% como la suma de la producción total de todas sus unidades de ese 
% recurso.

% produce(Madera, Alimento, Oro)

recurso(madera).
recurso(alimento).
recurso(oro).

produccionTotal(Jugador, ProduccionTotal, Recurso) :-
    tiene(Jugador, _),
    recurso(Recurso),
    findall(Produccion, (tiene(Jugador, Unidad),  
    produccionSegunRecurso(Unidad, Recurso, Produccion)), 
    Producciones),
    sum_list(Producciones, ProduccionTotal).
    
produccionSegunRecurso(Unidad, Recurso, ProduccionRecurso) :-
    produccion(Unidad, ProduccionTotal),
    produccionDelRecurso(Recurso, ProduccionTotal, ProduccionRecurso).

produccionDelRecurso(madera, produce(Madera, _, _), Madera).
produccionDelRecurso(alimento, produce(_, Alimento, _), Alimento).
produccionDelRecurso(oro, produce(_, _, Oro), Oro).



    
