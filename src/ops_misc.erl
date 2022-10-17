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
-module(ops_misc).   
 
-export([
	 create_cluster_node/3,
	 delete_cluster_node/3,
	 is_cluster_node_present/3,
	 cluster_names/1,
	 cluster_intent/1,
	 cluster_intent/2

	]).
-export([
	 create_pod_node/4,
	 delete_pod_node/4,
	 is_pod_node_present/4,
	 pod_name_dir_list/3,
	 pod_intent/1,
	 pod_intent/2,
	 pod_candidates/2


	]).

-export([
	 git_load_service/5,
	 load_service/5,
	 start_service/5,
	 stop_service/5,
	 unload_service/5,
	 is_service_running/5,
	 is_service_loaded/5
	]).



%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

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

create_cluster_node(HostName,ClusterName,ClusterSpec)->
    cluster_lib:start_node(HostName,ClusterName,ClusterSpec).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% -------------------------------------------------------------------
delete_cluster_node(HostName,ClusterName,ClusterSpec)->
    cluster_lib:stop_node(HostName,ClusterName,ClusterSpec).


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
