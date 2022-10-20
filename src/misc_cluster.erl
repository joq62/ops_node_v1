%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(misc_cluster).   
 
-export([

	 create_connect_nodes/2,
	 create_cluster_node/2


	]).



%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ClusterNodeServices,["sd","nodelog","cluster_node"]).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
%% [part_of, not_part_of,present,not_present]
%%
%% any_host,same_host,not_same_host,this_host
%% same_pod,not_same_pod
%% num_instances
%% Services must not be loaded on the pod (conflict)
%% 
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
create_connect_nodes(ClusterName,TimeOut)->
    Cookie=config_node:cluster_cookie(ClusterName),
    NodeName=config_node:cluster_connect_name(ClusterName),
    HostNameList=config_node:cluster_hostnames(ClusterName),
    PaArgs="  ",
    EnvArgs=" -detached ",
    
    {StartResult,Ping}=connect_node(HostNameList,ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut),
    {StartResult,Ping}.
    
connect_node(HostNameList,ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut)->
    connect_node(HostNameList,ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut,[]).

connect_node([],_ClusterName,Cookie,_NodeName,_PaArgs,_EnvArgs,_TimeOut,Acc)->
    Ping=[{ok,Node1,Node2}||{ok,_,_,Node1}<-Acc,
			    {ok,_,_,Node2}<-Acc,
			    Node1<Node2,
			    pong=:=dist_lib:ping(Node1,Cookie,[Node2])],
    {Acc,Ping};
connect_node([HostName|T],ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut,Acc)->
 %   io:format(" ~p~n",[{?MODULE,?LINE,?FUNCTION_NAME,HostName,ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut}]), 
    Result=case ssh_vm:create(HostName,NodeName,Cookie,PaArgs,EnvArgs,TimeOut) of
	       {error,Reason}->
		   {error,Reason};
	       {ok,Node}->
		   {ok,HostName,ClusterName,Node}
	   end,
    io:format("Result ~p~n",[{?MODULE,?LINE,?FUNCTION_NAME,Result,HostName,NodeName}]), 
    connect_node(T,ClusterName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut,[Result|Acc]).
    


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
create_cluster_node(_HostName,_ClusterName)->


    glurk.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
