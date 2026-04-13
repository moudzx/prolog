% Algorithms : DFS, IDS

maze(1, 2).
maze(2, 3).
maze(3, 4).
maze(4, 5).
maze(5, 6).
maze(6, 7).
maze(7, 8).
maze(8, 9).
maze(9, 10).
maze(10, 11).
maze(11, 12).
maze(12, 13).
maze(13, 14).
maze(14, 15).
maze(15, 16).
maze(16, 17).
maze(17, 18).
maze(18, 19).
maze(19, 20).
maze(20, 21).
maze(21, 22).
maze(22, 23).
maze(23, 24).
maze(24, 25).
maze(25, 26).
maze(26, 27).
maze(27, 28).
maze(28, 29).
maze(29, 30).
maze(30, 31).
maze(31, 32).
maze(32, 33).
maze(33, 34).
maze(34, 35).
maze(35, 36).
maze(36, 37).
maze(37, 38).
maze(38, 39).
maze(39, 40).
goal_maze(40).

dfs_maze(Start, Goal) :-
    dfs_maze(Start, Goal, [Start]).

dfs_maze(Goal, Goal, _).
dfs_maze(Start, Goal, Visited) :-
    maze(Start, Next),
    not(member(Next, Visited)),
    dfs_maze(Next, Goal, [Next|Visited]).

ids_maze(Start, Goal) :-
    between(1, 100, Depth),
    depth_maze(Start, Goal, Depth, [Start]),
    !.

depth_maze(Goal, Goal, _, _).
depth_maze(Start, Goal, Depth, Visited) :-
    Depth > 0,
    maze(Start, Next),
    not(member(Next, Visited)),
    NewDepth is Depth - 1,
    depth_maze(Next, Goal, NewDepth, [Next|Visited]).