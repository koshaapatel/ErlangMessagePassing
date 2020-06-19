%% @author kay
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([callingaction/0]).

%exchange:start().

%% ====================================================================
%% Internal functions
%% ====================================================================
callingaction() ->
	receive 
		{[SenderName], [ReceiverList], MasterId, Flag}
			when Flag==0 ->
			timer:sleep(rand:uniform(200)),
			%SenderId = spawn(calling, callingaction, []),
			%SenderName ! {SenderName++ReceiverName},
			
			io:fwrite("calling's receieved: ~w ~w\n\n", [SenderName,MasterId]),
			MasterId ! {SenderName},
			
			callingaction()
	after 2000 -> true 
	end.

	receive 
		{[SenderName], [ReceiverList], MasterId, Flag}
			when Flag==0 ->
			timer:sleep(rand:uniform(200)),
			%SenderId = spawn(calling, callingaction, []),
			%SenderName ! {SenderName++ReceiverName},
			
			io:fwrite("calling's receieved: ~w ~w\n\n", [SenderName,MasterId]),
			MasterId ! {SenderName},
			
			callingaction()
	after 2000 -> true 
	end.
