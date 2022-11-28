%% -*- Mode: Prolog; coding: utf-8 -*-

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

% -- nat
nat(0).
nat(s(X)) :- nat(X).

plus3(X,s(s(s(X)))) :- nat(X).

add(0,X,X) :- nat(X).
add(s(X),Y,s(Z)) :- add(X,Y,Z).

divideBy2(A,B) :- add(B,B,A).

mulBackward(0,M,0) :- nat(M).
mulBackward(s(N),M,X) :-
    add(Y,M,X),
    mulBackward(N,M,Y).

mulForward(0,M,0) :- nat(M).
mulForward(s(N),M,X) :-
    mulForward(N,M,Y),
    add(Y,M,X).

max(0,N,N) :- nat(N).
max(s(N),0,s(N)) :- nat(N).
max(s(A),s(B),s(C)) :- max(A,B,C).
% -------------------------

list([]). % Üres lista
list([_|Xs]) :- list(Xs). % Legalább egy elemű lista

% Legalább 2 elemű lista
% [X|[Y|Xs]].
% [X,Y|Xs].

null([]).

singleton([_]).
% Lista elemeit fel lehet sorolni vesszőkkel elválasztva
% pl. [1,alma,3]

head([X|_], X).
tail([_|Xs], Xs).

last_([Y],Y).
last_([_|Xs],Y) :- last_(Xs,Y).

% init [_] = []
% init (x:xs) = x : init xs

init([_],[]).
init([X|Xs], [X|Ys]) :- init(Xs,Ys).

% Egy adott érték eleme-e a listának.
% 1 [2,4,1,6,7]
elem(X,[X|_]). % 1 [1,6,7]
elem(X,[_|Xs]) :- elem(X,Xs).

% append
% length
% reverse létező predikátumok

replicate(0,_,[]).
replicate(s(N),X,[X|Xs]) :- replicate(N,X,Xs).

%% --- bináris fa és műveletek

bin_tree(leaf(_)).
bin_tree(node(L,_,R)) :- bin_tree(L), bin_tree(R).

tree_member(X,leaf(X)).
tree_member(X,node(L,X,R)) :- bin_tree(L), bin_tree(R).
tree_member(X,node(L,_,R)) :- tree_member(X,L), bin_tree(R) ; tree_member(X,R), bin_tree(L).

tree_height(leaf(_),s(0)).
tree_height(node(L,_,R),s(Y)) :- tree_height(L,A), tree_height(R,B), max(A,B,Y).

leaf_count(leaf(_),s(0)).
leaf_count(node(L,_,R),N) :- leaf_count(L,A), leaf_count(R,B), add(A,B,N).

preorder(leaf(X),[X]).
preorder(node(L,X,R),[X|Xs]) :- preorder(L,Ls), preorder(R,Rs), append(Ls,Rs,Xs).

inorder(leaf(X),[X]).
inorder(node(L,X,R),Ys) :- inorder(L,Ls), inorder(R,Rs), append(Ls,[X|Rs],Ys).

isotree(leaf(_),leaf(_)).
isotree(node(L1,_,R1),node(L2,_,R2)) :- isotree(L1,L2), isotree(R1,R2).

mirror_tree(leaf(X),leaf(X)).
mirror_tree(node(L1,X,R1),node(L2,X,R2)) :- mirror_tree(L1,R2), mirror_tree(R1,L2).

%% ---------------------------------------------------------

% 1.) Mindig f
f(_,_).
f2(f(_,_)).

% 2.) Egyenlő számok
eq_nat(X,X) :- nat(X), nat(X).

% 3.) Talán
maybe(nothing).
maybe(just(_)).

% 4.) Ismétlés
rep(_, []).
rep(X, [X]).
rep(X, [X|Xs]) :- elem(X, Xs), rep(X, Xs).

% 5.) Harmadolás - TODO
divide_by_3(0,0).
divide_by_3(A,B) :-  add(B,T,A), add(B,B,T).


% 6.) Biztonságos összeadás
safe_add(nothing, nothing, nothing).
safe_add(nothing, just(X), nothing) :- nat(X).
safe_add(just(X), nothing, nothing) :- nat(X).
safe_add(just(X), just(Y), just(Z)) :- nat(X), nat(Y), add(X,Y,Z).

% 7.) Lista lehetséges szétbontásai
same_list(X,X) :- list(X).
part_list([],[],[]).
part_list(Xs,Ys,Zs) :- same_list(Xs,Ts), append(Ys,Zs,Ts).

% 8.) Összes lehetséges törlés
delete_(X, [X|Xs], Xs).
delete_(X, [Y|Xs], [Y|Zs]) :- delete_(X,Xs,Zs).
deletions([],[]).
deletions([X|Xs],[_|Zs]) :- delete_(X,Xs,Zs).