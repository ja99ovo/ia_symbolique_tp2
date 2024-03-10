:-module(mylogic,[calculer_action_croyances/4]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).

:- use_module(wumpus_position).
:- use_module(pit_position2).
%:- use_module(go).

%计算前进后的位置
next_pos(c{x:X,y:Y}, north, _{x:X,y:Y1}) :- Y1 #= Y + 1.
next_pos(c{x:X,y:Y}, south, _{x:X,y:Y1}) :- Y1 #= Y - 1.
next_pos(c{x:X,y:Y}, east, _{x:X1,y:Y}) :- X1 #= X + 1.
next_pos(c{x:X,y:Y}, west, _{x:X1,y:Y}) :- X1 #= X - 1.

%右转后的方向(未测试)
turn_right(north,HunterBeliefs,NewBeliefs):- 
    New_certain_fluents=_{}.put(dir,east).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).

turn_right(east,HunterBeliefs,NewBeliefs):- 
    New_certain_fluents=_{}.put(dir,south).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).
turn_right(south,HunterBeliefs,NewBeliefs):- 
    New_certain_fluents=_{}.put(dir,west).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).
turn_right(west,HunterBeliefs,NewBeliefs):-
    New_certain_fluents=_{}.put(dir,north).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).

turn_left(north,HunterBeliefs,NewBeliefs):-
    New_certain_fluents=_{}.put(dir,west).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).
turn_left(east,HunterBeliefs,NewBeliefs):-
    New_certain_fluents=_{}.put(dir,north).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).
turn_left(south,HunterBeliefs,NewBeliefs):-
    New_certain_fluents=_{}.put(dir,east).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).
turn_left(west,HunterBeliefs,NewBeliefs):-
    New_certain_fluents=_{}.put(dir,south).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).


%从HunterBeliefs获取目前朝向Dir
get_dir(HunterBeliefs,Dir):-
    HunterBeliefs.certain_fluents.dir = [_{d:Dir, h:_}|_].
get_dir(HunterBeliefs,Dir):-
    HunterBeliefs.certain_fluents.dir = Dir.
%以列表返回visited，有啥用忘了
get_visited(HunterBeliefs,Visited):-
    VisitedList = HunterBeliefs.certain_fluents.visited,
    (VisitedList = [] -> Visited = []; Visited = VisitedList).

safe_positions(_{x:X,y:Y}, HunterBeliefs, Final_Safe) :-
    findall(
        _{x:XAdj, y:YAdj},
        (
            % 计算上下左右坐标
            (XAdj #= X+1, YAdj = Y;  % 右
             XAdj #= X-1, YAdj = Y;  % 左
             XAdj = X, YAdj is Y+1;  % 上
             XAdj = X, YAdj is Y-1), % 下
            % 检查坐标是否不在walls列表中
            \+ member(_{c:_{x:XAdj, y:YAdj},w:_}, HunterBeliefs.certain_eternals.eat_walls),
            \+ member(_{x:XAdj, y:YAdj}, HunterBeliefs.certain_fluents.fat_gold),
            \+ member(_{from:_{x:XAdj, y:YAdj},to:_},HunterBeliefs.certain_fluents.visited)
        ),
        Safe%Safe应该被存储在fat_gold里
    ),
    append(Safe,HunterBeliefs.certain_fluents.fat_gold,Final_Safe).

turn(HunterBeliefs, north,NewBeliefs, Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,
    next_pos(c{x:X,y:Y}, north, _{x:X_north,y:Y_north}),
    (member(_{x:X_north,y:Y_north},HunterBeliefs.certain_fluents.fat_gold)
    ->Action=move,
    effect_move(HunterBeliefs,NewBeliefs)
        
    ;Action=right,
    turn_right(north,HunterBeliefs,NewBeliefs)
    ).
   

turn(HunterBeliefs, east,NewBeliefs, Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,

    next_pos(c{x:X,y:Y}, east, _{x:X_east,y:Y_east}),
    next_pos(c{x:X,y:Y}, north, _{x:X_north,y:Y_north}),
    (\+member(_{x:X_north,y:Y_north},HunterBeliefs.uncertain_eternals.eat_pit),
    \+member(_{x:X_north,y:Y_north},HunterBeliefs.uncertain_eternals.eat_wumpus),
    \+member(_{c:_{x:X_north,y:Y_north},w:_},HunterBeliefs.certain_eternals.eat_walls)
    ->turn_left(east,HunterBeliefs,NewBeliefs),
    Action=left
    ;member(_{x:X_north,y:Y_north},HunterBeliefs.certain_fluents.fat_gold)
    ->turn_left(east,HunterBeliefs,NewBeliefs),
    Action=left
    ;member(_{x:X_east,y:Y_east},HunterBeliefs.certain_fluents.fat_gold)
    ->effect_move(HunterBeliefs,NewBeliefs),
    Action=move
    ;turn_right(east,HunterBeliefs,NewBeliefs),
    Action=right
    ).


turn(HunterBeliefs, south,NewBeliefs, Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,
    next_pos(c{x:X,y:Y}, east, _{x:X_east,y:Y_east}),
    next_pos(c{x:X,y:Y}, south, _{x:X_south,y:Y_south}),
    (member(_{x:X_east,y:Y_east},HunterBeliefs.certain_fluents.fat_gold)
    ->Action=left,
    turn_left(south,HunterBeliefs,NewBeliefs)
    ;Action=move,
    effect_move(HunterBeliefs,NewBeliefs)
    ).




%只要发现金子就立刻捡起来
calculer_action_croyances(HunterBeliefs, Percepts,  NewBeliefs, grab) :-
    member(glitter,Percepts),
    New_certain_fluents=_{}.put(dir,HunterBeliefs.certain_fluents.dir).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited).put(has_gold,yesyesyes),
    NewBeliefs=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).


calculer_action_croyances(HunterBeliefs, Percepts, NewBeliefs, Action) :-
    get_dir(HunterBeliefs,Dir),
    Safe=HunterBeliefs.certain_fluents.fat_gold,
    
 
    %只有臭味没有风
    ( member(stench,Percepts), \+member(breeze, Percepts)
    %判断是否在eat_pit或afat_gold里添加格子
    ->wumpus_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Wumpus, Safe,Final_New_Safe,Percepts),
    New_certain_fluents=_{}.put(dir,Dir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    New_uncertain_eternals=_{}.put(eat_pit,HunterBeliefs.uncertain_eternals.eat_pit).put(eat_wumpus,Final_New_Eat_Wumpus),
    NewBeliefs1=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,New_uncertain_eternals),
    %Action=right%需按照NewBeliefs判断行动
    turn(NewBeliefs1,Dir,NewBeliefs,Action)
    %只有风没有臭味
    ;member(breeze, Percepts), \+member(stench,Percepts)
    ->  pit_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Pits, Safe,Final_New_Safe,Percepts),
    New_certain_fluents=_{}.put(dir,Dir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    New_uncertain_eternals=_{}.put(eat_wumpus,HunterBeliefs.uncertain_eternals.eat_wumpus).put(eat_pit,Final_New_Eat_Pits),
    NewBeliefs1=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,New_uncertain_eternals),
    %Action=right
    turn(NewBeliefs1,Dir,NewBeliefs,Action)
    %既有风又有臭味，没想好怎么处理
    ;member(breeze, Percepts), member(stench,Percepts)
    ->  pit_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Pits, Safe,Final_New_Safe1,Percepts),
    wumpus_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Wumpus, Final_New_Safe1,Final_New_Safe2,Percepts),
    New_certain_fluents=_{}.put(dir,Dir).put(fat_gold,Final_New_Safe2).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    New_uncertain_eternals=_{}.put(eat_pit,Final_New_Eat_Pits).put(eat_wumpus,Final_New_Eat_Wumpus),
    NewBeliefs2=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,New_uncertain_eternals),
    turn(NewBeliefs2,Dir,NewBeliefs,Action)


    %没有风也没有臭味，前进。但没有检测前面有没有墙
    ;\+member(breeze, Percepts), \+member(stench,Percepts)
    ->  
    safe_positions(HunterBeliefs.certain_fluents.fat_hunter.c,HunterBeliefs,Final_New_Safe),
    Newdir=[_{d:Dir,h:_{}}],
    New_certain_fluents=_{}.put(dir,Newdir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    NewBeliefs1=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals),
    
    move(NewBeliefs1,Dir,NewBeliefs,Action)
    
    ).

move(HunterBeliefs,north,NewBeliefs,Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,
    next_pos(c{x:X,y:Y}, north, _{x:X,y:Y1}),
    (member(_{c:_{x:X,y:Y1},w:_},HunterBeliefs.certain_eternals.eat_walls)
    -> turn_right(north,HunterBeliefs,NewBeliefs),
    Action=right
    ;Action=move,
    effect_move(HunterBeliefs,NewBeliefs)
    ).

move(HunterBeliefs,south,NewBeliefs,Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,
    next_pos(c{x:X,y:Y}, east, _{x:X_east,y:Y_east}),
    (member(_{x:X_east,y:Y_east},HunterBeliefs.certain_fluents.fat_gold)
    -> turn_left(south,HunterBeliefs,NewBeliefs),
    Action=left
    ;Action=move,
    effect_move(HunterBeliefs,NewBeliefs)
    ).

move(HunterBeliefs,east,NewBeliefs,Action):-
    _{x:X,y:Y}=HunterBeliefs.certain_fluents.fat_hunter.c,
    next_pos(c{x:X,y:Y}, east, _{x:X_east,y:Y_east}),
    (member(_{x:X_east,y:Y_east},HunterBeliefs.certain_fluents.fat_gold)
    -> Action=move,
    effect_move(HunterBeliefs,NewBeliefs)
    ;turn_left(east,HunterBeliefs,NewBeliefs),
    Action=right
    ).

%前进要做的事，将自身位置按前进方向+1，将此路径以_{from:_{x:_,y:_},to:_{x:_,y:_}}加入visited列表
effect_move(HunterBeliefs, NewBeliefs):-
    get_dir(HunterBeliefs,Dir),
    get_visited(HunterBeliefs,Visited),

    Newdir=[_{d:Dir,h:_{}}],
    next_pos(HunterBeliefs.certain_fluents.fat_hunter.c,Dir,New_Position),

    Final_Position=_{}.put(c,New_Position).put(h,_{}),
    New_Visited=_{}.put(from,HunterBeliefs.certain_fluents.fat_hunter.c).put(to,New_Position),
    append(Visited,[New_Visited],Final_Visited),

    put_dict(certain_eternals, _{}, HunterBeliefs.certain_eternals, NewBeliefs1),
    Certain_fluents=_{}.put(dir,Newdir).put(fat_hunter,Final_Position).put(visited,Final_Visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
	NewBeliefs=NewBeliefs1.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,Certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).

