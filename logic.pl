inside(X) :- 
    1 #=< X, 
    X #=< 8.

get_next_cell(Row-Column, NextRow-1) :-
    Column mod 8 =:= 0, !,
    NextRow is Row + Column // 8.
get_next_cell(Row-Column, NextRow-NextColumn) :-
    NextRow is Row + Column // 8,
    NextColumn is Column + 1.

getCellsNumber(GameBoard, 9-1, []).
getCellsNumber(GameBoard, Row-Column, [Row-Column-Value|Cells]) :-
    get_value(Row, Column, GameBoard, Value),
    number(Value), !,                       
    get_next_cell(Row-Column, NextRow-NextColumn),
    getCellsNumber(GameBoard, NextRow-NextColumn, Cells).
getCellsNumber(GameBoard, Row-Column, Cells) :-
    get_next_cell(Row-Column, NextRow-NextColumn),
    getCellsNumber(GameBoard, NextRow-NextColumn, Cells).
 
/*attack_all_with_number(_, [], _).
attack_all_with_number(GameBoard, [Cell | Cells], Positions) :-
    write(Cell), nl,
    cell_attacks(GameBoard, Cell, Positions),
    attack_all_with_number(GameBoard, Cells, Positions).*/

percorrer_lista(_, [], ListRestrict, ListRestrict).
percorrer_lista(KingX-KingY, [[X,Y] | CellsAttackedKing], Acc, ListRestrict) :-
    append([(KingX #\= X #\/ KingY #\= Y)], Acc, NewAcc),
    %(KingX #\= X #\/ KingY #\= Y),
    percorrer_lista(KingX-KingY, CellsAttackedKing, NewAcc, ListRestrict).

% [PawnX, PawnY, KnightX, KnightY, KingX, KingY, RookX, RookY, BishopX, BishopY, QueenX, QueenY]
cell_attacks(GameBoard, [PawnX, PawnY, RookX, RookY], Row-Column-0) :-
    %write('Para a cell ['), write(Row), write(', '), write(Column), write(']'), nl,
    (PawnX #\= Xa #\/ PawnY #\= Ya),
    pawn([Xa, Ya], [Row, Column], 1), % ????? VER ISTO
    %findall(Teste, knight(Teste, [Row, Column], 1), CellsAttackedKnight),
    %write(CellsAttackedKnight), nl,
    %percorrer_lista(KnightX-KnightY, CellsAttackedKnight),
    %findall(ABC, king(ABC, [Row, Column], 1), CellsAttackedKing), 
    %write(CellsAttackedKing), nl,
    %percorrer_lista(KingX-KingY, CellsAttackedKing),
    findall(BCD, rook(GameBoard, BCD, [Row, Column], [PawnX, PawnY, RookX, RookY], 1), CellsAttackedRook), 
    % write(CellsAttackedRook), nl,
    percorrer_lista(RookX-RookY, CellsAttackedRook, [], Restrictions),
    fd_batch(Restrictions).

% [PawnX, PawnY, KnightX, KnightY, KingX, KingY, RookX, RookY, BishopX, BishopY, QueenX, QueenY]
cell_attacks(GameBoard, [PawnX, PawnY, QueenX, QueenY], Row-Column-Number) :-    % 3º param - Positions [PawnX, PawnY, KnightX, KnightY, KingX, KingY]
   
    /*findall(X, pawn_TEST([PawnX, PawnY], X), CellsAttackedPawn),
    findall(X, knight_TEST([KnightX, KnightY], X), CellsAttackedKnight),
    findall(X, king_TEST([KingX, KingY], X), CellsAttackedKing),

    write(PawnAttack), nl,
    write(CellsAttackedPawn), nl,
    write(KnightAttack), nl,
    write(CellsAttackedKnight), nl,
    write(KingAttack), nl,
    write(CellsAttackedKing), nl,*/

    %repeat,
    %(PawnX #\= KnightX #\/ PawnY #\= KnightY),
    %(PawnX #\= KingX #\/ PawnY #\= KingY),
    %(KnightX #\= KingX #\/ KnightY #\= KingY),

    pawn([PawnX, PawnY], [Row, Column], PawnAttack),
    %knight([KnightX, KnightY], [Row, Column], KnightAttack),
    %king([KingX, KingY], [Row, Column], KingAttack),
    %rook(GameBoard, [RookX, RookY], [Row, Column], [PawnX, PawnY, RookX, RookY], RookAttack),
    %bishop(GameBoard, [BishopX, BishopY], [Row, Column], [PawnX, PawnY, RookX, RookY], BishopAttack),
    queen(GameBoard, [QueenX, QueenY], [Row, Column], [PawnX, PawnY, QueenX, QueenY], QueenAttack),

    % write('PAWNATTACK: '), write(PawnAttack), nl,
    % write('NUMBER: '), write(Number), nl,
    % isAttacked([Row, Column], CellsAttackedPawn, PawnAttack),
    
    % findall(X, knight([3, 2], X), CellsAttackedKnight),
    % isAttacked([Row, Column], CellsAttackedKnight, KnightAttack),

    % findall(X, king([2, 3], X), CellsAttackedKing),
    % isAttacked([Row, Column], CellsAttackedKing, KingAttack),

    /*findall(X, rook(GameBoard, [4, 3], X), CellsAttackedRook),
    isAttacked([Row, Column], CellsAttackedRook, RookAttack),

    % findall(X, bishop(GameBoard, [4, 4], X), CellsAttackedBishop),
    getDiagonalValue_BOTTOM_right(2-4, BR),
    getDiagonalValue_BOTTOM_left(2-4, BL),
    getDiagonalValue_top_right(2-4, TR),
    getDiagonalValue_top_left(2-4, TL),
    append(BR, BL, Bottom),
    append(TR, TL, Top),
    append(Bottom, Top, CellsAttackedBishop),
    isAttacked([Row, Column], CellsAttackedBishop, BishopAttack),

    findall(X, rook(GameBoard, [3, 5], X), QueenVerticalHorizontal),
    getDiagonalValue_BOTTOM_right(3-5, BRQ),
    getDiagonalValue_BOTTOM_left(3-5, BLQ),
    getDiagonalValue_top_right(3-5, TRQ),
    getDiagonalValue_top_left(3-5, TLQ),
    append(BRQ, BLQ, BottomQ),
    append(TRQ, TLQ, TopQ),
    append(BottomQ, TopQ, DiagonalQueen),
    append(QueenVerticalHorizontal, DiagonalQueen, CellsAttackedQueen),
    isAttacked([Row, Column], CellsAttackedQueen, QueenAttack),
*/
    %write(PawnAttack), nl,
    %write(CellsAttackedPawn), nl,
  /*  write(KnightAttack), nl,
    write(CellsAttackedKnight), nl,
    write(KingAttack), nl,
    write(CellsAttackedKing), nl,
    write(RookAttack), nl,
    write(CellsAttackedRook), nl,
    write(BishopAttack), nl,
    write(CellsAttackedBishop), nl,
    write(QueenAttack), nl,
    write(CellsAttackedQueen), nl,
    TimesAtacked is PawnAttack + KnightAttack + KingAttack + RookAttack + BishopAttack + QueenAttack,
    TimesAtacked == Number.
*/

    % write('Para a cell ['), write(Row), write(', '), write(Column), write(']\n - VALORES: '), write(PawnX), write(PawnY), nl,
    %write(KnightX), write(KnightY), nl,
    %write(KingX), write(KingY), nl,

    /*write('PAWNATTACK: '), write(PawnAttack),
    write(' KNIGHTATTACK: '), write(KnightAttack),
    write(' KINGATTACK: '), write(KingAttack), nl,*/

    PawnAttack + QueenAttack #= Number.
    %PawnAttack + KnightAttack + KingAttack + RookAttack + BishopAttack + QueenAttack #= Number.

getDiagonalValue_BOTTOM_right(X-Y, [[X1, Y1] | R]) :-
    X1 is X + 1,
    Y1 is Y + 1,
    inside(X1),
    inside(Y1),
    getDiagonalValue_BOTTOM_right(X1-Y1, R), !.
getDiagonalValue_BOTTOM_right(_, []).

getDiagonalValue_BOTTOM_left(X-Y, [[X1, Y1] | R]) :-
    X1 is X + 1,
    Y1 is Y - 1,
    inside(X1),
    inside(Y1),
    getDiagonalValue_BOTTOM_left(X1-Y1, R), !.
getDiagonalValue_BOTTOM_left(_, []).

getDiagonalValue_top_right(X-Y, [[X1, Y1] | R]) :-
    X1 is X - 1,
    Y1 is Y + 1,
    inside(X1),
    inside(Y1),
    getDiagonalValue_top_right(X1-Y1, R), !.
getDiagonalValue_top_right(_, []).

getDiagonalValue_top_left(X-Y, [[X1, Y1] | R]) :-
    X1 is X - 1,
    Y1 is Y - 1,
    inside(X1),
    inside(Y1),
    getDiagonalValue_top_left(X1-Y1, R), !.
getDiagonalValue_top_left(_, []).
    
test :-
    getDiagonalValue_BOTTOM_right(4-4, BR),
    getDiagonalValue_BOTTOM_left(4-4, BL),
    getDiagonalValue_top_right(4-4, TR),
    getDiagonalValue_top_left(4-4, TL),
    append(BR, BL, Bottom),
    append(TR, TL, Top),
    append(Bottom, Top, Diagonal),
    write(Diagonal), nl.

/**************************************/ 

isAttacked(Cell, CellsAttacked, 1) :-
    member(Cell, CellsAttacked), !.
isAttacked(_, _, 0).

/**************************************/

/*pawn([X, Y], [X1, Y1]) :-
    pawn_attack(Distx, Disty),
    X1 #= X+Distx,
    Y1 #= Y+Disty,
    inside(X1), 
    inside(Y1).*/

pawn_attack(-1, 1).
pawn_attack(-1,-1).

pawn([X, Y], [X1, Y1], 1) :-
    pawn_attack(Distx, Disty),
    X1 #= X+Distx,
    Y1 #= Y+Disty,
    inside(X1),
    inside(Y1), 
    inside(X), 
    inside(Y).
pawn([X, Y], [X1, Y1], 0).

/**************************************/

knight_attack(2,1).
knight_attack(2,-1).
knight_attack(-2,-1).
knight_attack(-2,1).

knight_attack(1,2).
knight_attack(1,-2).
knight_attack(-1,2).
knight_attack(-1,-2).

knight([X ,Y], [X1, Y1], 1) :-  
    knight_attack(Distx, Disty),
    X1 #= X+Distx,
    Y1 #= Y+Disty,
    inside(X1),
    inside(Y1), 
    inside(X), 
    inside(Y).
knight([X ,Y], [X1, Y1], 0).

/**************************************/
rook(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    X1 #= X,
    nothing_blocking_tower_x(Positions, X-Y, X1-Y1),
    inside(X1),
    inside(Y1).
rook(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    Y1 #= Y,
    nothing_blocking_tower_y(Positions, X-Y, X1-Y1),
    inside(X1),
    inside(Y1).
rook(GameBoard, [X, Y], [X1, Y1], Positions, 0).

nothing_blocking_tower_x(Positions, X-Y, X1-Y1) :-
    Y #> Y1,    % torre à direita
    tower_cycle_x_left(Positions, X, Y, Y1).

nothing_blocking_tower_x(Positions, X-Y, X1-Y1) :-
    Y #< Y1,    % torre à esquerda
    tower_cycle_x_right(Positions, X, Y, Y1).

nothing_blocking_tower_y(Positions, X-Y, X1-Y1) :-
    X #> X1, % torre em cima
    tower_cycle_y_up(Positions, Y, X, X1).

nothing_blocking_tower_y(Positions, X-Y, X1-Y1) :-
    X #< X1, % torre em baixo
    tower_cycle_y_down(Positions, Y, X, X1).

tower_cycle_x_left(_, _, Y, Y).
tower_cycle_x_left(Positions, X, Y, Y1) :-
    check_no_piece(Positions, X, Y1),
    NY1 is Y1 + 1,
    tower_cycle_x_left(Positions, X, Y, NY1).

tower_cycle_x_right(_, _, Y, Y).
tower_cycle_x_right(Positions, X, Y, Y1) :-
    check_no_piece(Positions, X, Y1),
    NY1 is Y1 - 1,
    tower_cycle_x_right(Positions, X, Y, NY1).

tower_cycle_y_up(_, _, X, X).
tower_cycle_y_up(Positions, Y, X, X1) :-
    check_no_piece(Positions, X1, Y),
    NX1 is X1 + 1,
    tower_cycle_y_up(Positions, Y, X, NX1).

tower_cycle_y_down(_, _, X, X).
tower_cycle_y_down(Positions, Y, X, X1) :-
    check_no_piece(Positions, X1, Y),
    NX1 is X1 - 1,
    tower_cycle_y_down(Positions, Y, X, NX1).

check_no_piece([], _, _).
check_no_piece([PX, PY|Positions], X, Y) :-
    (PX #\= X #\/ PY #\= Y),
    check_no_piece(Positions, X, Y).

















nothing_blocking_tower(GameBoard, X-Y, _-Y1) :-
    Y #> Y1,
    nothing_between_row_other(GameBoard, X, Y, Y1).
nothing_blocking_tower(GameBoard, X-Y, _-Y1) :-
    Y1 #> Y,
    nothing_between_row(GameBoard, X, Y, Y1).
nothing_blocking_tower(GameBoard, X-Y, X1-_) :-
    X #> X1,
    nothing_between_column_other(GameBoard, Y, X, X1).
nothing_blocking_tower(GameBoard, X-Y, X1-_) :-
    X1 #> X,
    nothing_between_column(GameBoard, Y, X, X1).

nothing_between_row(_, _, Y, Y).
nothing_between_row(GameBoard, X, Y, Y1) :-
    get_value(X, Y, GameBoard, Value),
    var(Value),
    NewY is Y + 1,
    nothing_between_row(GameBoard, X, NewY, Y1).

nothing_between_row_other(_, _, Y, Y).
nothing_between_row_other(GameBoard, X, Y, Y1) :-
    get_value(X, Y, GameBoard, Value),
    var(Value),
    NewY is Y - 1,
    nothing_between_row_other(GameBoard, X, NewY, Y1).

nothing_between_column(_, _, X, X).
nothing_between_column(GameBoard, Y, X1, X) :-
    get_value(X1, Y, GameBoard, Value),
    var(Value),
    NewX1 is X1 + 1,
    nothing_between_column(GameBoard, Y, NewX1, X).

nothing_between_column_other(_, _, X, X).
nothing_between_column_other(GameBoard, Y, X, X1) :-
    get_value(X, Y, GameBoard, Value),
    var(Value),
    NewX is X - 1,
    nothing_between_column_other(GameBoard, Y, NewX, X1).

/**************************************/
constrain([]).
constrain([H | RCols]) :-
    safe(H, RCols, 1),
    constrain(RCols).

safe(_, [], _).
safe(X, [Y | T], K) :-
    noattack(X, Y, K),
    K1 is K + 1,
    safe(X, T, K1).

noattack(X, Y, K) :-
    X #\= Y,
    X + K #\= Y,
    X - K #\= Y.

diagonal(X-Y, X1-Y1) :-
    K in 1..8,
    X #= X1 - K,
    Y #= Y1 - K.
diagonal(X-Y, X1-Y1) :-
    K in 1..8,
    X #= X1 + K,
    Y #= Y1 + K.
diagonal(X-Y, X1-Y1) :-
    K in 1..8,
    X #= X1 + K,
    Y #= Y1 - K.
diagonal(X-Y, X1-Y1) :-
    K in 1..8,
    X #= X1 - K,
    Y #= Y1 + K.

bishop(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    %domain([X1, Y1], 1, 8),
    K in 1..8,
    diagonal(X-Y, X1-Y1),
    nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions),
    inside(X1),
    inside(Y1),
    inside(X),
    inside(Y).

bishop(GameBoard, [X, Y], [X1, Y1], Positions, 0).

nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions) :-
    X #> X1, Y #< Y1, % cima direita
    nothing_between_diagonal_right_top(Positions, X-Y, X1-Y1).
nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions) :-
    X #> X1, Y #> Y1, % cima esquerda
    nothing_between_diagonal_left_top(Positions, X-Y, X1-Y1).
nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions) :-
    X #< X1, Y #< Y1, % baixo direita
    nothing_between_diagonal_right_bot(Positions, X-Y, X1-Y1).
nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions) :-
    X #< X1, Y #> Y1, % baixo esquerda
    nothing_between_diagonal_left_bot(Positions, X-Y, X1-Y1).


nothing_between_diagonal_right_top(_, X-Y, X-Y).
nothing_between_diagonal_right_top(Positions, X-Y, X1-Y1) :-
    check_no_piece(Positions, X1, Y1),
    NewX1 #= X1 + 1,
    NewY1 #= Y1 - 1,
    inside(NewX1),
    inside(NewY1),
    nothing_between_diagonal_right_top(Positions, X-Y, NewX1-NewY1).

nothing_between_diagonal_left_top(_, X-Y, X-Y).
nothing_between_diagonal_left_top(Positions, X-Y, X1-Y1) :-
    check_no_piece(Positions, X1, Y1),
    NewX1 #= X1 + 1,
    NewY1 #= Y1 + 1,
    inside(NewX1),
    inside(NewY1),
    nothing_between_diagonal_left_top(Positions, X-Y, NewX1-NewY1).

nothing_between_diagonal_right_bot(_, X-Y, X-Y).
nothing_between_diagonal_right_bot(Positions, X-Y, X1-Y1) :-
    check_no_piece(Positions, X1, Y1),
    NewX1 #= X1 - 1,
    NewY1 #= Y1 - 1,
    inside(NewX1),
    inside(NewY1),
    nothing_between_diagonal_right_bot(Positions, X-Y, NewX1-NewY1).

nothing_between_diagonal_left_bot(_, X-Y, X-Y).
nothing_between_diagonal_left_bot(Positions, X-Y, X1-Y1) :-
    check_no_piece(Positions, X1, Y1),
    NewX1 #= X1 - 1,
    NewY1 #= Y1 + 1,
    inside(NewX1),
    inside(NewY1),
    nothing_between_diagonal_left_bot(Positions, X-Y, NewX1-NewY1).

/*
nothing_between_diagonal_left_top(_, X-Y, X-Y).
nothing_between_diagonal_left_top(GameBoard, X-Y, X1-Y1) :-
    write('[X1,Y1] = '), write(X1 - Y1), nl,
    write('VALUE 6'), nl,
    get_value(X1, Y1, GameBoard, Value),
    var(Value),
    NewX1 is X1 + 1, NewY1 is Y1 + 1,
    nothing_between_diagonal_left_top(GameBoard, X-Y, NewX1-NewY1).

/*
nothing_between_diagonal_left_bottom(_, X-Y, X-Y).
nothing_between_diagonal_left_bottom(GameBoard, X-Y, X1-Y1) :-
    get_value(X1, Y1, GameBoard, Value),
    var(Value),
    NewX1 is X1 - 1, NewY1 is Y1 + 1,
    nothing_between_diagonal_left_bottom(GameBoard, X-Y, NewX1-NewY1).

nothing_between_diagonal_right_top(_, X-Y, X-Y).
nothing_between_diagonal_right_top(GameBoard, X-Y, X1-Y1) :-
    get_value(X1, Y1, GameBoard, Value),
    var(Value),
    NewX1 is X1 + 1, NewY1 is Y1 - 1,
    nothing_between_diagonal_right_top(GameBoard, X-Y, NewX1-NewY1).

nothing_between_diagonal_right_bottom(_, X-Y, X-Y).
nothing_between_diagonal_right_bottom(GameBoard, X-Y, X1-Y1) :-
    get_value(X1, Y1, GameBoard, Value),
    var(Value),
    NewX1 is X1 - 1, NewY1 is Y1 - 1,
    nothing_between_diagonal_right_bottom(GameBoard, X-Y, NewX1-NewY1).
*/
/**************************************/
/* To Do */
% queen([X, Y], [X1, Y1]).
queen(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    X1 #= X,
    nothing_blocking_tower_x(Positions, X-Y, X1-Y1),
    inside(X1),
    inside(Y1).
queen(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    Y1 #= Y,
    nothing_blocking_tower_y(Positions, X-Y, X1-Y1),
    inside(X1),
    inside(Y1).
queen(GameBoard, [X, Y], [X1, Y1], Positions, 1) :-
    K in 1..8,
    diagonal(X-Y, X1-Y1),
    nothing_blocking_bishop(GameBoard, X-Y, X1-Y1, Positions),
    inside(X1),
    inside(Y1).
queen(GameBoard, [X, Y], [X1, Y1], _, 0).

/**************************************/
king_attack(-1, 1).
king_attack(0, 1).
king_attack(1, 1).
king_attack(1, 0).
king_attack(-1, 0).
king_attack(-1, -1).
king_attack(0, -1).
king_attack(1, -1).

king([X, Y], [X1, Y1], 1) :-
    king_attack(Distx, Disty), 
    X1 #= X+Distx, 
    Y1 #= Y+Disty, 
    inside(X1), 
    inside(Y1), 
    inside(X), 
    inside(Y).
king([X, Y], [X1, Y1], 0).

/**************************************/



/**************************************/