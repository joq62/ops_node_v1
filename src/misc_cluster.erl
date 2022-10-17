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
	 create_cluster_node/2,
	 delete_cluster_node/2,
	 is_cluster_node_present/3,
	 cluster_names/1,
	 cluster_intent/1,
	 cluster_intent/2

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

%%

%%
pod_candidates(Constraints,ClusterSpec)->
    
    {not_implmented,Constraints,ClusterSpec}.





%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
git_load_service(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:git_load(HostName,ClusterName,PodName,Service,ClusterSpec).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
load_service(_HostName,_ClusterName,_PodName,_Service,_ClusterSpec)->
    not_implemented.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
start_service(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:start(HostName,ClusterName,PodName,Service,ClusterSpec).
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
stop_service(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:stop(HostName,ClusterName,PodName,Service,ClusterSpec).
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% ------------------------------------------------------------------- 
unload_service(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:unload(HostName,ClusterName,PodName,Service,ClusterSpec).
    

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
is_service_running(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:is_running(HostName,ClusterName,PodName,Service,ClusterSpec).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
is_service_loaded(HostName,ClusterName,PodName,Service,ClusterSpec)->
    service_lib:is_loaded(HostName,ClusterName,PodName,Service,ClusterSpec).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
pod_intent(ClusterSpec)->
    pod_lib:intent(ClusterSpec).

pod_intent(WantedClusterName,ClusterSpec)->
    pod_lib:intent(WantedClusterName,ClusterSpec).
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
pod_name_dir_list(HostName,ClusterName,ClusterSpec)->
    pod_data:name_dir_list(HostName,ClusterName,ClusterSpec).
    
%%--------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

create_pod_node(HostName,ClusterName,PodName,ClusterSpec)->
    pod_lib:start_node(HostName,ClusterName,PodName,ClusterSpec).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
delete_pod_node(HostName,ClusterName,PodName,ClusterSpec)->
    cluster_lib:stop_node(HostName,ClusterName,PodName,ClusterSpec).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
is_pod_node_present(HostName,ClusterName,PodName,ClusterSpec)->
    pod_lib:is_node_present(HostName,ClusterName,PodName,ClusterSpec).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
cluster_intent(ClusterSpec)->
    cluster_lib:intent(ClusterSpec).

cluster_intent(WantedClusterName,ClusterSpec)->
    cluster_lib:intent(WantedClusterName,ClusterSpec).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
cluster_names(ClusterSpec)->
    HostClusterNameList=cluster_data:all_names(ClusterSpec),
    HostClusterNameList.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

create_cluster_node(HostName,ClusterName)->
    NodeName=ClusterName,
    Cookie=config_node:cluster_cookie(ClusterName),    
    ClusterDir=config_node:cluster_dir(ClusterName),
    PaArgs=" ",
    EnvArgs=" -detached ",

    Result=case dist_lib:stop_node(HostName,NodeName,Cookie) of
	       false->
		    {error,[couldnt_kill_vm,list_to_atom(NodeName++"@"++HostName)]};
	       true->
		   case dist_lib:start_node(HostName,NodeName,Cookie,EnvArgs) of
		       {error,Reason}->
			   {error,Reason};
		       {ok,ClusterNode}->
			   dist_lib:rmdir_r(ClusterNode,Cookie,ClusterDir),
			   timer:sleep(3000),
			   case dist_lib:mkdir(ClusterNode,Cookie,ClusterDir) of
			       {error,Reason}->
				   {error,Reason};
			       ok->
				   case start_cluster_node_services(?ClusterNodeServices,ClusterNode,Cookie,ClusterDir) of
				       {error,Reason}->
					   {error,Reason};
				       StartList-> 
					   {ok,ClusterNode,ClusterDir,StartList}
				   end;
			       UnMatched ->
				   io:format("UnMatched ~p~n",[{UnMatched,?MODULE,?LINE,?FUNCTION_NAME}]),
				   {error,[unmatched,UnMatched]}
			   end
		   end
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------

start_cluster_node_services(ClusterNodeServices,ClusterNode,Cookie,ClusterDir)->
    start_cluster_node_services(ClusterNodeServices,ClusterNode,Cookie,ClusterDir,[]).

start_cluster_node_services([],_,_,_,Acc)->
    Acc;
start_cluster_node_services([Service|T],ClusterNode,Cookie,ClusterDir,Acc)->
    DirToClone=filename:join(ClusterDir,Service),
    dist_lib:rmdir_r(ClusterNode,Cookie,DirToClone),
    Result=case dist_lib:mkdir(ClusterNode,Cookie,DirToClone) of
	       {error,Reason}->
		   {error,Reason};
	       ok->
		   GitPath=config_node:application_gitpath(Service),
		   case dist_lib:cmd(node(),Cookie,service,git_clone_to_dir,[ClusterNode,GitPath,DirToClone],5000) of
		       {error,Reason}->
			   {error,Reason};
		       {ok,_}->
			   Ebin=[filename:join(DirToClone,"ebin")],  % git_clone_dirs is a list!!
			   ServiceApp=config_node:application_app(Service),
			   case dist_lib:cmd(node(),Cookie,service,load,[ClusterNode,ServiceApp,Ebin],5000) of
			       {error,Reason}->
				   {error,Reason};
			       ok->
				   case dist_lib:cmd(node(),Cookie,service,start,[ClusterNode,ServiceApp],5000) of
				       {error,Reason}->
					   {error,Reason};
				       ok->
					   {ok,ServiceApp,DirToClone}
				   end
			   end
		   end
	   end,
    start_cluster_node_services(T,ClusterNode,Cookie,ClusterDir,[Result|Acc]).


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
delete_cluster_node(HostName,ClusterName)->
    NodeName=ClusterName,
    ClusterNode=list_to_atom(NodeName++"@"++HostName),
    Cookie=config_node:cluster_cookie(ClusterName),   
    ClusterDir=config_node:cluster_dir(ClusterName),
    
    dist_lib:rmdir_r(ClusterNode,Cookie,ClusterDir),

    Result= case dist_lib:cmd(ClusterNode,Cookie,filelib,is_dir,[ClusterDir],5000) of
		true->
		    {error,[couldnt_delete_dir,ClusterDir]};
		{badrpc,Reason}->
		    {error,[badrpc,Reason,ClusterDir]};
		false->
		    case dist_lib:stop_node(HostName,NodeName,Cookie) of
			false->
			    {error,[couldnt_kill_vm,list_to_atom(NodeName++"@"++HostName)]};
			true->
			    ok
		    end
	    end,
    Result.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
is_cluster_node_present(HostName,ClusterName,ClusterSpec)->
    cluster_lib:is_node_present(HostName,ClusterName,ClusterSpec).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
