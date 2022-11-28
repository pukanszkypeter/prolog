%% -*- Mode: Prolog; coding: utf-8 -*-

% bin_tree
% Legyen levélben és csomópontban is adat.
bin_tree(leaf(_)).
bin_tree(node(L,_,R)) :- bin_tree(L), bin_tree(R).

% tree_member
tree_member(X,leaf(X)).
tree_member(X,node(L,X,R)) :- bin_tree(L), bin_tree(R).
tree_member(X,node(L,_,R)) :- tree_member(X,L), bin_tree(R) ; tree_member(X,R), bin_tree(L).

tree_member_(X,leaf(X)).
tree_member_(X,node(L,X,R)) :- bin_tree(L), bin_tree(R).
tree_member_(X,node(L,_,R)) :- tree_member_(X,L), bin_tree(R).
tree_member_(X,node(L,_,R)) :- tree_member_(X,R), bin_tree(L).

%   1
%  / \
% 2   3
preorder(leaf(X),[X]).
preorder(node(L,X,R),[X,Xs]) :- preorder(L,Ls), preorder(R,Rs), append(Ls,Rs,Xs).

%   2
%  / \
% 1   3
inorder(leaf(X),[X]).
inorder(node(L,X,R),Ys) :- inorder(L,Ls), inorder(R,Rs), append(Ls,[X|Rs],Ys).

%   3
%  / \
% 1   2
postorder(leaf(X),[X]).
postorder(node(L,X,R), Ys) :- postorder(L,Ls), postorder(R,Rs), append(Ls,Rs,Zs), append(Zs,[X],Ys).

% isotree
isotree(leaf(_),leaf(_)).
isotree(node(L1,_,R1),node(L2,_,R2)) :- isotree(L1,L2), isotree(R1,R2).
% isotree(node(_,R1),node(_,R2)) :- isotree(R1,R2).

mirror_tree(leaf(X),leaf(X)).
mirror_tree(node(L1,X,R1),node(L2,X,R2)) :- mirror_tree(L1,R2), mirror_tree(L2,R1).

nat(0).
nat(s(X)) :- nat(X).

max(0,N,N) :- nat(N).
max(s(N),0,s(N)) :- nat(N).
max(s(A),s(B),s(C)) :- max(A,B,C).

add(0,X,X) :- nat(X).
add(s(X),Y,s(Z)) :- add(X,Y,Z).

tree_height(leaf(_),s(0)).
tree_height(node(L,_,R),s(Y)) :- tree_height(L,A), tree_height(R,B), max(A,B,Y).

tree_width(leaf(_),s(0)).
tree_width(node(L,_,R),N) :- tree_width(L,A), tree_width(R,B), add(A,B,N).

delete_(X, [X|Xs], Xs).
delete_(X, [Y|Xs], [Y|Zs]) :- delete_(X,Xs,Zs).

% GYAKORLÁS
% Üres lista
list([]).
list([_|Xs]) :- list(Xs).

% Lista összegzés
sum_list([], 0).
sum_list([X|Xs], N) :- sum_list(Xs, M), add(X,M,N). 

% Listák listájának összegzése
sum_list_list([], 0).
sum_list_list([X|Xs], N) :- sum_list(X,M), sum_list_list(Xs,Z), add(M,Z,N).

% Eleme-e a listának
elem(X,[X|_]).
elem(X,[_|Xs]) :- elem(X,Xs).

% Minden eleme a listának ugyanaz-e.
is_all_same([]).
is_all_same([_]).
is_all_same([X|Xs]) :- elem(X,Xs), is_all_same(Xs).