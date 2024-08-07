% ---------------- Base de Conocimientos ------------

% --------------- Punto 1

% habitante(nro, profesion)
habitante(912, ingMecanica).
habitante(416, aviacionMilitar).
habitante(558, inteligenciaMilitar).
habitante(920, estudiante).
habitante(453, presidente).

leGusta(912, [fuego, destruccion]).
leGusta(558, [juegosAzar, ajedrez, tiroAlBlanco]).
leGusta(920, [sufrir]).
leGusta(453, [mentir]).

esBueno(912, armarBombas).
esBueno(416, conducirAutos).
esBueno(558, tiroAlBlanco).
esBueno(920, estudiar).
esBueno(453, hablar).

historialCriminal(416, roboAeronaves).
historialCriminal(416, fraude).
historialCriminal(416, tenenciaCafeina).
historialCriminal(558, falsificacionVacunas).
historialCriminal(558, fraude).
historialCriminal(453, corrupcion).

viveEn(912, "La Severino").
viveEn(536, "La Severino").
viveEn(416, "La Severino").

viveEn(558, "Comisaria 48").
viveEn(453, "Casa Presidencial").
viveEn(920, "Universidad").

% casa (nombre, descripcion)
casa("La Severino", [cuartoSecreto(4,8), pasadizo, tunel(8,f), tunel(5,f), tunel(1,c)]).
casa("Comisaria 48", []).
casa("Casa Presidencial", [cuartoSecreto(9,8), pasadizo, pasadizo, pasadizo, tunel(10,f), tunel(20,c)]).
casa("Universidad", [cuartoSecreto(3,4), cuartoSecreto(2,5), pasadizo]).

% --------------- Punto 2
posibleDisidente(Disidente):-
    habitante(Disidente, Profesion),
    primeraCondicion(Disidente, Profesion),
    % segundaCondicion(Disidente),
    terceraCondicion(Disidente).

primeraCondicion(NroHabitante, Profesion):-
    not(trabajoMilitar(Profesion)), 
    esBueno(NroHabitante, Habilidad),
    habilidadTerrorista(Habilidad).

segundaCondicion(NroHabitante) :-
    not(leGusta(NroHabitante, _)).

segundaCondicion(NroHabitante) :-
    leGusta(NroHabitante, Lista),
    length(Lista, Long),
    Long > 3.

segundaCondicion(NroHabitante) :-
    leGusta(NroHabitante, Gustos),
    esBueno(NroHabitante, Habilidad),
    member(Habilidad, Gustos).

terceraCondicion(NroHabitante):-
    criminal(NroHabitante).

terceraCondicion(NroHabitante):-
    viveEn(NroHabitante, Casa),
    viveEn(Otro, Casa),
    NroHabitante \= Otro,
    criminal(Otro).

criminal(NroHabitante):-
    historialCriminal(NroHabitante, Crimen),
    historialCriminal(NroHabitante, Crimen2),
    Crimen \= Crimen2.

trabajoMilitar(aviacionMilitar).
trabajoMilitar(inteligenciaMilitar).

habilidadTerrorista(armarBombas).
habilidadTerrorista(tiroAlBlanco).

% --------------- Punto 3
% Parte A
viviendaVacia(Vivienda):-
    casa(Vivienda, _),
    not(viveEn(_, Vivienda)).

% Parte B
viviendaGustoComun(Vivienda):-
    casa(Vivienda, _),
    viveEn(Alguien, Vivienda),
    leGusta(Alguien, Gustos),
    member(Gusto, Gustos),
    forall(
        viveEn(Persona,Vivienda),
        (
            leGusta(Persona, SusGustos),
            member(Gusto, SusGustos) % que todos tienen
        )    
    ).

% --------------- Punto 4 

potencialRebelde(Vivienda):-
    viveEn(Disidente, Vivienda),
    superficieClandestina(Vivienda, Cant),
    Cant > 50,
    posibleDisidente(Disidente).
    
superficieClandestina(Vivienda, Cant) :-
    casa(Vivienda, Descripcion), 
    maplist(sup, Descripcion, Superficies),
    sumlist(Superficies, Cant).
    
sup(cuartoSecreto(X, Y), Superficie):-
    Superficie is X * Y.
sup(pasadizo, 1).
sup(tunel(X, f), Superficie) :-
    Superficie is 2 * X.
sup(tunel(_, c), 0).


% --------------- Punto 5

/*
?- potencialRebelde(Viv).
Viv = "La Severino" ;
Viv = "La Severino" ;
Viv = "La Severino" ;
Viv = "La Severino" ;
Viv = "La Severino" ;
Viv = "La Severino" ;
false.

?- posibleDisidente(X).
X = 912 ;
X = 912 ;
X = 912 ;
X = 912 ;
X = 912 ;
X = 912 ;
false.

?- superficieClandestina(Viv, Sup).
Viv = "La Severino",
Sup = 59 ;
Viv = "Comisaria 48",
Sup = 0 ;
Viv = "Casa Presidencial",
Sup = 95 ;
Viv = "Universidad",
Sup = 23.

?- trabajoMilitar(aviacionMilitar).
true.

?- viviendaGustoComun(Vivienda).
Vivienda = "Comisaria 48" ;
Vivienda = "Comisaria 48" ;
Vivienda = "Comisaria 48" ;
Vivienda = "Casa Presidencial" ;
Vivienda = "Universidad".

*/

% --------------- Punto 6

/*
Analizar la inversibilidad de los predicados, de manera de encontrar alguno de los realizados que sea totalmente inversible y otro que no. Justificar. 

viviendaGustoComun(Vivienda) es parcialmente inversible. Podes comprobar si una vivienda tiene un 
gusto común dado un conjunto de criterios, pero no puedes deducir el gusto común sin conocer la 
vivienda y las personas que viven en ella.

superficieClandestina(Vivienda, Cant) es totalmente inversible. Podes calcular la superficie clandestina 
de una vivienda dada su descripción. También puedes determinar qué superficie tiene una vivienda dada 
su superficie total.
*/

% --------------- Punto 7

/*
Si en algún momento se agregara algún tipo nuevo de ambiente en las viviendas, por ejemplo bunkers donde se esconden secretos o entradas a cuevas donde se puede viajar en el tiempo 
¿Qué pasaría con la actual solución? 
¿Qué se podría hacerse si se quisiera contemplar su superficie para determinar la superficie total de la casa? Implementar una solución con una lógica simple
Justificar

Lo único que habría que agregar serían nuevos casos en sup/2 que tengan en cuenta los nuevos ambientes.
No es necesario cambiar superficieClandestina/2 si se actualiza sup/2 correctamente. 
maplist(sup, Descripcion, Superficies) seguirá funcionando para calcular la superficie total.
*/


