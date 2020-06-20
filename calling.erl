%% @author kay
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([callingaction/2, childprocesses/0]).

%exchange:start().

%% ====================================================================
%% Internal functions
%% ====================================================================
callingaction(Sender,MasterId) ->
	receive 
		{[SenderName], [ReceiverList], MasterId, Flag}
			when Flag==0 ->
			timer:sleep(rand:uniform(200)),
			
			lists:map( fun(Receiver)-> 
				%io:fwrite("Receiver: ~w\n",[Tuple]),
				% io:fwrite("calling's receieved: ~w ~w\n", [SenderName,MasterId]),
				% MasterId ! {SenderName}
				SenderId = spawn(calling, childprocesses, []),
				SenderId ! {[SenderName],[Receiver],MasterId,self(),element(3,now()),0 }
			end, ReceiverList),
			callingaction(Sender,MasterId)
	
	after 2000 -> MasterId!{Sender}

	%io:fwrite("child provess ~w is ended \n",[Sender])
	end.

childprocesses() ->
	receive
		{[SenderName], [Receiver], MasterrId, SenderId, MyStamp, 0} ->
			% io:fwrite("~w	~w    ~w   ~w   ~w   ~w\n",[SenderName,Receiver,MasterrId, SenderId, MyStamp, Flag]),
			MasterrId ! {[Receiver], [SenderName], MyStamp, 0},
			ReceiverId = spawn(calling, childprocesses, []),
			ReceiverId ! {[SenderName], [Receiver], MyStamp, MasterrId, 1},
			childprocesses();
		
		{[SenderNamee], [Receiverr], MyStampp, MasterrrId, 1} ->
			MasterrrId ! {[SenderNamee], [Receiverr], MyStampp, 1},
			childprocesses()
		
	after 1000 -> true
	end.