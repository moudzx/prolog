parent(john, mary).
parent(mary, ann).
parent(ann, bob).

dfs_ancestor(X, Z) :-
    dfs_ancestor(X, Y),
    parent(Y, Z).
dfs_ancestor(X, Z) :-
    parent(X, Z).


ids_ancestor(Start, Goal) :-
    between(1, 10, Depth),
    depth_ancestor(Start, Goal, Depth),
    !.

depth_ancestor(Goal, Goal, _).
depth_ancestor(Start, Goal, Depth) :-
    Depth > 0,
    parent(Start, Next),
    NewDepth is Depth - 1,
    depth_ancestor(Next, Goal, NewDepth).
