%% @author kosha
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
   SendData = element(2,Data), 
	
   io:fwrite("** Calls to be made **\n"),
	lists:map( fun(Receiver)-> 
		{Sender,ReceiverList} = Receiver,
		io:fwrite("~w: ",[Sender]),
		io:fwrite("~w\n",[ReceiverList])
		end, SendData),
	exchangeaction(SendData).

exchangeaction(SendData) ->
	io:fwrite("\n"),
	lists:map( fun(Receiver)-> 
		{Sender,ReceiverList} = Receiver,
		MasterId = spawn(calling, callingaction, [Sender,self()]),
		MasterId ! {[Sender], [ReceiverList], self(), 0}
		end, SendData), 
	exchangereceive().

exchangereceive() ->
	receive
		{Message} -> 
			io:fwrite("\nProcess ~w has received no calls for 5 seconds, ending...\n", [Message]),
		    exchangereceive();
	
		{[Receiver], [SenderName], MyStamp, 0} ->
			io:fwrite("~w received intro message from ~w [~w]\n",[Receiver,SenderName,MyStamp]),
			exchangereceive();
		
		{[Receiver], [SenderName], MyStamp, 1} ->
			io:fwrite("~w received reply message from ~w [~w]\n",[Receiver,SenderName,MyStamp]),
			exchangereceive()
			
	after 10000 -> io:fwrite("\nMaster has received no replies for 10 seconds, ending...\n") 
	end.