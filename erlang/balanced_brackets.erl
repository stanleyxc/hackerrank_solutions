
% is A left brace?
is_left(A) ->
  case A of
    ${ -> { yes, $} };
    $( -> { yes, $) };
    $[ -> { yes, $] };
    _  -> { no, A }
  end.

% is A right brace?
is_right(A) ->
  case A of
    $} -> { yes, ${ };
    $) -> { yes, $( };
    $] -> { yes, $[ };
    _  -> { no, A }
  end.

% right: find right brace
% right brace is the first character
right([H|T], H) ->  {ok, T};
% never find the right brace
right([], _) -> { nok, [] };

right([H|T], C) ->
  case is_right(H) of
    { no, _ } ->
      case is_left(H) of
        { no, _ } -> right(T, C);             % either left nor right brace, keep looking
        { yes, C2 } ->                        % another left brace - start another round of looking for closing brace
          case right(T, C2) of
            {ok, T1 }      -> right(T1, C);   % inner round matched; look for outter closing brace
            {nok, T1 }     -> { nok, T1 }     % inner match failed.
          end
      end;
    { yes, _ } -> {nok, T }                   % although H is closing brace, it's not the one we're looking for.
  end.


braces([H|T]) ->
  case is_right(H) of
    { no, _ } ->
      case is_left(H) of
        { no, _ }  -> braces(T);              % neither  left nor right, keep looking
        { yes, C } -> case right(T, C) of     % initiate closing brace match
          { ok, T1 } -> braces(T1);           % matched, move to next set
          { nok, _ } -> "NO"
          end
      end;
    { yes, _ } -> "NO"                        % got right brace off the bat.
  end;

braces([]) -> "YES".



main() ->

    { ok, [T]} = io:fread("", "~d"),
    T_list = lists:seq(1,T),
    lists:foreach( fun(T0) ->
            { ok, [S]} = io:fread("", "~s"),

             io:format("~s~n", [braces(S)] )

    end,T_list),
    true.
