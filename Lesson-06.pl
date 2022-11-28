%% -*- Mode: Prolog; coding: utf-8 -*-

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

% gy05 nincs, zh volt.

% is/2
% Aritmetika lehetséges vele.
% Egyirányú

nat(0).
nat(s(X)) :- nat(X).

convert(0,0).
convert(s(N),X) :-
    convert(N,Y),
    X is Y + 1.

% var(X).      % X változó-e.
% nonvar(X).   % X nem változó.
% compound(X). % X összetett term-e.
% atomic(X).   % X atomszerű-e (atom vagy szám).
% atom(X).     % X atom-e.
% number(X).   % X szám-e.
% integer(X).  % X egész szám-e.
% float(X).    % X tört szám-e.

% Aritmetikai műveletek:
% =:= : A két oldal aritmetikailag egyenlők-e.
% =\= : A két oldal aritmetikailag nem egyenlők-e.
% <   : Első paraméter aritmetikailag kisebb-e, mint a második.
% >   : Első paraméter aritmetikailag nagyobb-e, mint a második.
% >=  : Első paraméter aritmetikailag nem kisebb-e, mint a második.
% =<  : Első paraméter aritmetikailag nem nagyobb-e, mint a második.

'/='(X,Y) :- X =\= Y.

% current_op/3 : Ez a predikátum mondja meg, hogy milyen operátorok vannak definiálva.
% 1. paraméter: A kötés erőssége, minél nagyobb a szám, annál kevésbé köt.
%               Tehát 1 a legerősebb, valahol 1300 körül a leggyengébb.
% 2. paraméter: A kötés iránya
    % xfx, infix operátor, nem köt semerre
    % yfx, infix operátor, balra köt
    % xfy, infix operátor, jobbra köt
    % fx, prefix operátor, nem köt
    % fy, prefix operátor, köt
    % xf, postfix operátor, nem köt
    % yf, postfix operátor, köt

% 3. paraméter: Az operátor neve (ezt atomként kell megadni).

:- op(700, xfx, /=).

% Illesztési, azonosság ellenőrző műveletek
% =   : A két paraméterét illeszteni próbálja.
% \=  : Vizsgálja, hogy a két paramétere nem illeszthetők egymásra. Helyettesítés nem történik.
% ==  : Azonosság vizsgálat, a két term megegyezik. Helyettesítés, illesztés nem történik.
% \== : A két term nem azonos egymással. Helyettesítés, illesztés nem történik.
% @<  : Termek közti rendezés. var,float,integer,atom,compound. (Ez a rendezés sorrendje növekvően.)
% @>  : Szintén. | Mind a 4-re igaz: összehasonlítások azonos termek esetén:
% @>= : Szintén. | var: Mindig az első a kisebb. float, integer: Számszerűen
% @=< : Szintén. | atom: unicode kódtábla szerinti sorrend. compound: aritás, majd a termek sorrendje azonos operátorral.

% =.. : Termet szétszed komponenseire.

sum([],0).
sum([X|Xs],Sum) :-
    number(X),
    sum(Xs,Y),
    Sum is X + Y.