%% @author kosha
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
			
			lists:map( fun(Receiver)-> 
				SenderId = spawn(calling, childprocesses, []),
				SenderId ! {[SenderName],[Receiver],MasterId,self(),element(3,now()),0 }
			end, ReceiverList),
			callingaction(Sender,MasterId)
	
	after 5000 -> MasterId!{Sender} 
	end.

childprocesses() ->
	receive
		{[SenderName], [Receiver], MasterId, SenderId, MyStamp, 0} ->
			timer:sleep(rand:uniform(100)),
			MasterId ! {[Receiver], [SenderName], MyStamp, 0},
			ReceiverId = spawn(calling, childprocesses, []),
			ReceiverId ! {[SenderName], [Receiver], MyStamp, MasterId, 1},
			childprocesses();
		
		{[SenderName], [Receiver], MyStamp, MasterId, 1} ->
			timer:sleep(rand:uniform(100)),
			MasterId ! {[SenderName], [Receiver], MyStamp, 1},
			childprocesses()
		
	after 1000 -> true
	end.