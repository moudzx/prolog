% Algorithms: BFS, IDS

parent(john, mary).
parent(mary, ann).
parent(ann, bob).

dfs_ancestor(X, Z) :-
    dfs_ancestor(X, Y),
    parent(Y, Z).
dfs_ancestor(X, Z) :-
    parent(X, Z).

bfs_ancestor(Start, Goal) :-
    bfs_ancestor([[Start]], Goal).

bfs_ancestor([[Goal|Path]|_], Goal) :-
    reverse([Goal|Path], _).
bfs_ancestor([Path|Paths], Goal) :-
    extend_ancestor(Path, NewPaths),
    append(Paths, NewPaths, Paths1),
    bfs_ancestor(Paths1, Goal).

extend_ancestor([Node|Path], NewPaths) :-
    findall([Child, Node|Path],
            (parent(Node, Child), not(member(Child, [Node|Path]))),
            NewPaths),
    !.
extend_ancestor(_, []).

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