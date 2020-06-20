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
   SendData = element(2,Data), %	io:fwrite("~w:",[SendData]),
	
   io:fwrite("** Calls to be made **\n"),
	lists:map( fun(Receiver)-> 
		{Sender,ReceiverList} = Receiver,
		io:fwrite("~w:	",[Sender]),
		io:fwrite("~w\n",[ReceiverList])
		end, SendData),
	exchangeaction(SendData).

exchangeaction(SendData) ->

	lists:map( fun(Receiver)-> 
		{Sender,ReceiverList} = Receiver,
		MasterId = spawn(calling, callingaction, []),
		%register(Sender,)
		% io:fwrite("~w: ~w\n",[MasterId, ReceiverList]),
		MasterId ! {[Sender], [ReceiverList], self(), 0}
		
		end, SendData), %io:fwrite("parent ID: ~w\n\n", [self()]),

	exchangereceive().

exchangereceive() ->
	receive
		{Msg} -> 
			io:fwrite("Msg in get_feedback2 ~s \n\n", [Msg]),
			timer:sleep(rand:uniform(200)),
		    exchangereceive();
	
		{[Receiver], [SenderName], MyStamp, Flag} 
			when Flag==0 ->
				io:fwrite("~w received intro message from ~w ~w\n",[Receiver,SenderName,MyStamp]),
				exchangereceive();
		
		{[Receiver], [SenderName], MyStampp, Flagg, Flaggg}
		  	when Flagg==1 ->
				io:fwrite("~w received content message from ~w ~w\n",[Receiver,SenderName,MyStampp]),
				exchangereceive()
			
	after 2000 -> io:fwrite("master is ended\n") %master's gonna end
	end.