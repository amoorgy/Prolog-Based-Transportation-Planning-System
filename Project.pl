:- [transport_kb, slots_kb].

% Documentation: 
% group_days(Group, Day_Timings) holds if Day_Timings is the list of day_timing(Week, Day) on which students belonging to Group have at least one slot on.
group_days(Group, Day_Timings) :-
    findall(day_timing(Week, Day), scheduled_slot(Week, Day, _, _, Group), Day_Timings).

% Documentation:
% day_slots(Group, Week, Day, Slots) holds if Slots is the list of all slots for Group on Day of week Week.
day_slots(Group, Week, Day, Slots) :-
    findall(Slot, scheduled_slot(Week, Day, Slot, _, Group), Slots).

% Documentation:
% earliest_slot(Group, Week, Day, Slot) holds if Slot is the earliest slot for Group on Day of week Week.
earliest_slot(Group, Week, Day, Slot) :-
    day_slots(Group, Week, Day, Slots),
    min_list(Slots, Slot).

% Documentation:
% proper_connection(Station_A, Station_B, Duration, Line) holds if Station_A and Station_B are connected on Line, and the time to go between them is Duration.
% All while taking into consideration the bidirectionality or lack thereof of Line.
proper_connection(Station_A, Station_B, Duration, Line) :-
    connection(Station_A, Station_B, Duration, Line).
proper_connection(Station_A, Station_B, Duration, Line) :-
    connection(Station_B, Station_A, Duration, Line),
    \+ unidirectional(Line).

% Documentation:
% append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes) holds if Routes is the result of appending a connection 
% from Conn_Source to Conn_Destination on Conn_Line which takes Conn_Duration minutes, to Routes_So_Far.
append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, [route(Conn_Line, Conn_Source, Conn_Destination, Conn_Duration)|Routes_So_Far]).

% Documentation:
% connected(Source, Destination, Week, Day, Max_Duration, Max_Routes, Duration, Routes) holds if it is possible by following a sequence of Routes 
% to reach Destination from Source on Day of Week, where the combined Duration of Routes does not exceed Max_Duration, and the number of Routes does not exceed Max_Routes.
connected(Source, Destination, Week, Day, Max_Duration, Max_Routes, Duration, Routes) :-
    connected(Source, Destination, Week, Day, Max_Duration, Max_Routes, Duration, [Source], [], Routes).

connected(Source, Destination, _Week, _Day, Max_Duration, Max_Routes, Duration, Prev_Stations, Routes_So_Far, Routes) :-
    proper_connection(Source, Destination, Duration, Line),
    \+ member(Destination, Prev_Stations),
    append_connection(Source, Destination, Duration, Line, Routes_So_Far, Routes),
    Duration =< Max_Duration,
    length(Routes, L),
    L =< Max_Routes.

connected(Source, Destination, Week, Day, Max_Duration, Max_Routes, Duration, Prev_Stations, Routes_So_Far, Routes) :-
    proper_connection(Source, Next_Station, D1, Line),
    \+ member(Next_Station, Prev_Stations),
    New_Duration is D1 + Duration,
    New_Duration =< Max_Duration,
    append_connection(Source, Next_Station, D1, Line, Routes_So_Far, New_Routes),
    length(New_Routes, L),
    L =< Max_Routes,
    connected(Next_Station, Destination, Week, Day, Max_Duration, Max_Routes, New_Duration, [Next_Station|Prev_Stations], New_Routes, Routes).

% Documentation:
% mins_to_twentyfour_hr(Minutes, TwentyFour_Hours, TwentyFour_Mins) holds if TwentyFour_Hours:TwentyFour_Mins is the twenty-four hour representation of Minutes since midnight.
mins_to_twentyfour_hr(Minutes, Hours, Min) :-
    Hours is Minutes // 60,
    Min is Minutes mod 60.

% Documentation:
% twentyfour_hr_to_mins(TwentyFour_Hours, TwentyFour_Mins, Minutes) holds if Minutes since midnight is equivalent to the twenty-four hour formatted TwentyFour_Hours:TwentyFour_Mins.
twentyfour_hr_to_mins(Hours, Mins, Minutes) :-
    Minutes is Hours * 60 + Mins.

% Documentation:
% slot_to_mins(Slot_Num, Minutes) holds if Minutes since midnight is equivalent to the start time of a slot whose number is Slot_Num.
slot_to_mins(Slot_Num, Minutes) :-
    slot(Slot_Num, Hours, Mins),
    twentyfour_hr_to_mins(Hours, Mins, Minutes).

% Documentation:
% travel_plan(Home_Stations, Group, Max_Duration, Max_Routes, Journeys) holds if Journeys is a valid plan as described in section 1.
travel_plan(Home_Stations, Group, Max_Duration, Max_Routes, Journeys) :-
    group_days(Group, Day_Timings),
    findall(Journey, (
        member(day_timing(Week, Day), Day_Timings),
        earliest_slot(Group, Week, Day, Slot),
        slot_to_mins(Slot, Slot_Start),
        findall(Route, (
            member(Home, Home_Stations),
            campus_reachable(Campus),
            connected(Home, Campus, Week, Day, Max_Duration, Max_Routes, Duration, Route),
            Duration =< Max_Duration,
            Route = route(Line, Start_Station, End_Station, Duration)
        ), Routes),
        min_list(Routes, route(Line, Start_Station, End_Station, Duration)),
        Slot_Start_Time is Slot_Start - Duration,
        mins_to_twentyfour_hr(Slot_Start_Time, Start_Hour, Start_Minute),
        Journey = journey(Week, Day, Start_Hour, Start_Minute, Duration, Routes)
    ), Journeys),
    Journeys \= [].
