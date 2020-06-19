%% @author kay
%% @doc @todo Add description to exchange.


-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0 ,exchangeaction/1, exchangereceive/0]).

%exchange:start().

%% ====================================================================
%% Internal functions
%% ====================================================================

start() -> 
   Data = file:consult("calls.txt"),
	exchangeaction(Data).

exchangeaction(FetchedData) ->
	SendData = element(2,FetchedData),
	% CusttData=[tuple_to_list(CustData)],
%% 	lists:foreach( fun(Tuple)->
%%     	{Sender,ReceiverList} = Tuple,
%%     	io:format("~w: ~w ~n",[Sender,ReceiverList])
%% 		%io:format("~w~n",[Sender]),
%%    		end,SendData).

	lists:map( fun(Tuple)-> 
		{Sender,ReceiverList} = Tuple,
		MasterId = spawn(calling, callingaction, []),
		MasterId ! {[Sender], [ReceiverList], self(), 0}
		
		end, SendData),
	
	exchangereceive().

exchangereceive() ->
	receive
		{Msg} -> 
			io:fwrite("Msg in get_feedback2 ~s \n\n", [Msg]),
			timer:sleep(rand:uniform(200)),
		    exchangereceive()
	after 2000 -> true %master's gonna end
	end.


	
	