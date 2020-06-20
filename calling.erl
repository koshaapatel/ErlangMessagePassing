%% @author kay
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([callingaction/0, childprocesses/0]).

%exchange:start().

%% ====================================================================
%% Internal functions
%% ====================================================================
callingaction() ->
	receive 
		{[SenderName], [ReceiverList], MasterId, Flag}
			when Flag==0 ->
			timer:sleep(rand:uniform(200)),
			
			lists:map( fun(Receiver)-> 
				%io:fwrite("Receiver: ~w\n",[Tuple]),
				% io:fwrite("calling's receieved: ~w ~w\n", [SenderName,MasterId]),
				% MasterId ! {SenderName}
				SenderId = spawn(calling, childprocesses, []),
				SenderId ! {[SenderName],[Receiver],MasterId,self(),[element(2,erlang:now())],0 }			   
			end, ReceiverList),
			callingaction()
	
	after 2000 -> true 
	end.

childprocesses() ->
	receive
		{[SenderName], [Receiver], MasterrId, SenderId, MyStamp, Flag}
			when Flag==0 ->
			% io:fwrite("~w	~w    ~w   ~w   ~w   ~w\n",[SenderName,Receiver,MasterrId, SenderId, MyStamp, Flag]),
			MasterrId ! {[Receiver], [SenderName], MyStamp, Flag},
			ReceiverId = spawn(calling, childprocesses, []),
			ReceiverId ! {[SenderName], [Receiver], MyStamp, MasterrId, 1, 1},
			childprocesses();
		
		{[SenderNamee], [Receiverr], MyStampp, MasterrrId, Flagg, Flaggg}
			when Flagg==1 ->
			MasterrrId ! {[SenderNamee], [Receiverr], MyStampp, Flagg, Flaggg},
			childprocesses()
		
	after 2000 -> true 
	end.