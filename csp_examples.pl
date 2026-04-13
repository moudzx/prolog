% Algorithms: DFS with backtracking (constraint propagation examples)

sudoku(Vars) :-
    Vars = [A,B,C,D,E,F,G,H,I],
    Vars = [1,2,3,4,5,6,7,8,9],
    A = 1,
    B = 2,
    C = 3,
    D = 4,
    E = 5,
    F = 6,
    G = 7,
    H = 8,
    I = 9.

map_color(A,B,C,D,E) :-
    A = red,
    B = green,
    C = blue,
    D = red,
    E = green,
    A \= B,
    A \= C,
    B \= C,
    B \= D,
    C \= D,
    C \= E,
    D \= E.