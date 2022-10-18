%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(ops_node).
  
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports

%% node
-export([
	 new_cluster/1,
	 delete_cluster/1,

	 create_cluster_node/2,
	 delete_cluster_node/2,
	 is_cluster_node_present/2,
	 cluster_names/0,
	 cluster_intent/0,
	 cluster_intent/1
	]).

%% Cluster
-export([
	 create_cluster_node/2,
	 delete_cluster_node/2,
	 is_cluster_node_present/2,
	 cluster_names/0,
	 cluster_intent/0,
	 cluster_intent/1
	]).

%% Pods
-export([
	 create_pod_node/3,
	 delete_pod_node/3,
	 is_pod_node_present/3,
	 pod_name_dir_list/2,
	 pod_intent/0,
	 pod_intent/1,
	 pod_candidates/1
	]).

%% Services
-export([
	 git_load_service/4,
	 load_service/4,
	 start_service/4,
	 stop_service/4,
	 unload_service/4,
	 is_service_running/4,
	 is_service_loaded/4,
	 service_intent/1
	]).


-export([
	 start/0,
	 stop/0,
	 appl_start/1,
	 ping/0
	]).


%% gen_server callbacks



-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-------------------------------------------------------------------
-record(state, {
		all_spec,
		application_spec,
		cluster_spec,
		deployment_spec,
		host_spec,
		spec_dir
	       }).

%% ====================================================================
%% External functions
%% ====================================================================

appl_start([])->
    application:start(?MODULE).
%% --------------------------------------------------------------------
new_cluster(ClusterName)->
    gen_server:call(?MODULE,{new_cluster,ClusterName},infinity). 
delete_cluster(ClusterName)->
    gen_server:call(?MODULE,{delete_cluster,ClusterName},infinity). 


%% --------------------------------------------------------------------
create_cluster_node(HostName,ClusterName)->
    gen_server:call(?MODULE,{create_cluster_node,HostName,ClusterName},infinity).   
delete_cluster_node(HostName,ClusterName)->
    gen_server:call(?MODULE,{delete_cluster_node,HostName,ClusterName},infinity).
is_cluster_node_present(HostName,ClusterName)->
    gen_server:call(?MODULE,{is_cluster_node_present,HostName,ClusterName},infinity).    
cluster_names()->
    gen_server:call(?MODULE,{cluster_names},infinity).   
cluster_intent()->
    gen_server:call(?MODULE,{cluster_intent},infinity). 
cluster_intent(ClusterName)->
    gen_server:call(?MODULE,{cluster_intent,ClusterName},infinity).   

%% --------------------------------------------------------------------

create_pod_node(HostName,ClusterName,PodName)->
    gen_server:call(?MODULE,{create_pod_node,HostName,ClusterName,PodName},infinity).   
delete_pod_node(HostName,ClusterName,PodName)->
    gen_server:call(?MODULE,{delete_pod_node,HostName,ClusterName,PodName},infinity).
is_pod_node_present(HostName,ClusterName,PodName)->
    gen_server:call(?MODULE,{is_pod_node_present,HostName,ClusterName,PodName},infinity).    
pod_name_dir_list(HostName,ClusterName)->
    gen_server:call(?MODULE,{pod_name_dir_list,HostName,ClusterName},infinity).   
pod_intent()->
    gen_server:call(?MODULE,{pod_intent},infinity). 
pod_intent(ClusterName)->
    gen_server:call(?MODULE,{pod_intent,ClusterName},infinity).  
pod_candidates(Constraints)->
    gen_server:call(?MODULE,{pod_candidates,Constraints},infinity).  

 

%% --------------------------------------------------------------------

git_load_service(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{git_load_service,HostName,ClusterName,PodName,Service},infinity). 
load_service(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{load_service,HostName,ClusterName,PodName,Service},infinity). 
start_service(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{start_service,HostName,ClusterName,PodName,Service},infinity). 
stop_service(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{stop_service,HostName,ClusterName,PodName,Service},infinity). 
unload_service(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{unload_service,HostName,ClusterName,PodName,Service},infinity). 
is_service_loaded(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{is_service_loaded,HostName,ClusterName,PodName,Service},infinity). 
is_service_running(HostName,ClusterName,PodName,Service)->
    gen_server:call(?MODULE,{is_service_running,HostName,ClusterName,PodName,Service},infinity). 

service_intent(ClusterName)->
    gen_server:call(?MODULE,{service_intent,ClusterName},infinity). 


  
	    
%% call
start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).

ping()->
    gen_server:call(?MODULE,{ping},infinity).

%% cast

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    AllSpec=application:get_all_env(?MODULE),
    {application_spec,ApplicationSpec}=lists:keyfind(application_spec,1,AllSpec),
    {cluster_spec,ClusterSpec}=lists:keyfind(cluster_spec,1,AllSpec),
    {deployment_spec,DeploymentSpec}=lists:keyfind(deployment_spec,1,AllSpec),
    {host_spec,HostSpec}=lists:keyfind(host_spec,1,AllSpec),
    {spec_dir,SpecDir}=lists:keyfind(spec_dir,1,AllSpec),

    
    ConfigNodeEnv=[{config_node,[{deployment_spec,DeploymentSpec},
				 {cluster_spec,ClusterSpec},
				 {host_spec,HostSpec},
				 {application_spec,ApplicationSpec},
				 {spec_dir,SpecDir}]}],
    ok=application:set_env(ConfigNodeEnv),
    ok=application:start(config_node),
    pong=config_node:ping(),
    
    {ok, #state{
	    all_spec=AllSpec,
	    application_spec=ApplicationSpec,
	    cluster_spec=ClusterSpec,
	    deployment_spec=DeploymentSpec,
	    host_spec=HostSpec,
	    spec_dir=SpecDir}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_call({new_cluster,ClusterName},_From, State) ->
    Reply=rpc:call(node(),misc_cluster,new,[ClusterName],5*5000),
    {reply, Reply, State};

handle_call({delete_cluster,ClusterName},_From, State) ->
    Reply=rpc:call(node(),misc_cluster,delete,[ClusterName],5*5000),
    {reply, Reply, State};



handle_call({git_load_service,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:git_load_service(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({load_service,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:load_service(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({start_service,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:start_service(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({stop_service,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:stop_service(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({unload_service,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:unload_service(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({is_service_running,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:is_service_running(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({is_service_loaded,HostName,ClusterName,PodName,Service},_From, State) ->
    Reply=ops_misc:is_service_loaded(HostName,ClusterName,PodName,Service,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({service_intent,ClusterName},_From, State) ->
    Reply=ops_misc:service_intent(ClusterName,State#state.cluster_spec),
    {reply, Reply, State};


  
%% --------------------------------------------------------------------


handle_call({cluster_intent},_From, State) ->
    Reply=ops_misc:cluster_intent(State#state.cluster_spec),
    {reply, Reply, State};

handle_call({cluster_intent,ClusterName},_From, State) ->
    Reply=ops_misc:cluster_intent(ClusterName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({cluster_names},_From, State) ->
    Reply=ops_misc:cluster_names(State#state.cluster_spec),
    {reply, Reply, State};

handle_call({create_cluster_node,HostName,ClusterName},_From, State) ->
    Reply=ops_misc:create_cluster_node(HostName,ClusterName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({delete_cluster_node,HostName,ClusterName},_From, State) ->
    Reply=ops_misc:delete_cluster_node(HostName,ClusterName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({is_cluster_node_present,HostName,ClusterName},_From, State) ->
    Reply=ops_misc:is_cluster_node_present(HostName,ClusterName,State#state.cluster_spec),
    {reply, Reply, State};


handle_call({cluster_spec},_From, State) ->
    Reply=cluster_data:cluster_all_names(State#state.cluster_spec),
    {reply, Reply, State};

handle_call({deployment_spec},_From, State) ->
    Reply=cluster_data:deployment_all_names(State#state.deployment_spec),
    {reply, Reply, State};

 
%% --------------------------------------------------------------------

handle_call({pod_candidates,Constraints},_From, State) ->
    Reply=ops_misc:pod_candidates(Constraints,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({pod_intent},_From, State) ->
    Reply=ops_misc:pod_intent(State#state.cluster_spec),
    {reply, Reply, State};

handle_call({pod_intent,ClusterName},_From, State) ->
    Reply=ops_misc:pod_intent(ClusterName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({pod_name_dir_list,HostName,ClusterName},_From, State) ->
    Reply=ops_misc:pod_name_dir_list(HostName,ClusterName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({create_pod_node,HostName,ClusterName,PodName},_From, State) ->
    Reply=ops_misc:create_pod_node(HostName,ClusterName,PodName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({delete_pod_node,HostName,ClusterName,PodName},_From, State) ->
    Reply=ops_misc:delete_pod_node(HostName,ClusterName,PodName,State#state.cluster_spec),
    {reply, Reply, State};

handle_call({is_pod_node_present,HostName,ClusterName,PodName},_From, State) ->
    Reply=ops_misc:is_pod_node_present(HostName,ClusterName,PodName,State#state.cluster_spec),
    {reply, Reply, State};


handle_call({ping},_From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{Msg,?MODULE,?LINE}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info({ssh_cm,_,_}, State) ->
   
    {noreply, State};

handle_info(Info, State) ->
    io:format("unmatched match~p~n",[{Info,?MODULE,?LINE}]), 
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
