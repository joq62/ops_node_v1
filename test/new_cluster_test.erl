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
-module(new_cluster_test).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-define(Id_c1,"c1").

-define(SourceDir,"./test/specs").
-define(DestDir,".").
-define(SpecFiles,["spec.deployment","spec.cluster","spec.host","spec.application"]).
	 

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(HostNames,["c100","c300","c200","c201"]).
-define(HostName,"c100").
-define(ClusterName,"test_cluster").
-define(Cookie,"test_cluster_cookie").
-define(DeplName,"any_not_same_hosts_not_same_pods").

-define(SourceDepFile,"./test/specs/spec.deployment").
-define(DepFile,"spec.deployment").
-define(SourceClusterFile,"./test/specs/spec.cluster").
-define(ClusterFile,"spec.cluster").
-define(SourceHostFile,"./test/specs/spec.host").
-define(HostFile,"spec.host").
-define(SourceApplicationFile,"./test/specs/spec.application").
-define(ApplicationFile,"spec.application").
-define(LogDir,"logs").

start()->
   
    ok=setup(),

    ok=new(),
    ok=delete(),
    
    
    

    io:format("Test OK !!! ~p~n",[?MODULE]),
    init:stop(),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
new()->
     io:format("Start ~p~n",[?FUNCTION_NAME]),

    [
     {pong,test_cluster@c100,test_cluster@c200,"test_cluster.dir"},
     {pong,test_cluster@c100,test_cluster@c201,"test_cluster.dir"},
     {pong,test_cluster@c200,test_cluster@c201,"test_cluster.dir"}
    ]=lists:sort(ops_node:new_cluster(?ClusterName)),
    
    Node=list_to_atom(?ClusterName++"@"++?HostName),
    [
     test_cluster@c100,
     test_cluster@c200,
     test_cluster@c201
    ]=lists:sort([dist_lib:cmd(Node,?Cookie,erlang,node,[],4000)|dist_lib:cmd(Node,?Cookie,erlang,nodes,[],4000)]),
    
   % io:format("X ~p~n",[{X,?MODULE,?FUNCTION_NAME}]),
    
    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
delete()->
     io:format("Start ~p~n",[?FUNCTION_NAME]),

    [
     {ok,"c100","test_cluster"},
     {ok,"c200","test_cluster"},
     {ok,"c201","test_cluster"}
    ]=lists:sort(ops_node:delete_cluster(?ClusterName)),

    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    

    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

delete_spec_files()->
    io:format("Start ~p~n",[?FUNCTION_NAME]),
    
    Cookie=config_node:cluster_cookie(?ClusterName),    
    Node=list_to_atom(?ClusterName++"@"++?HostName),
    ClusterDir=config_node:cluster_dir(?ClusterName),
    
    R1=[{FileName,dist_lib:rm_file(Node,Cookie,?DestDir,FileName)}||FileName<-?SpecFiles],
    io:format("Delete R1 ~p~n",[R1]),      
    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
delete_node()->
    io:format("Start ~p~n",[?FUNCTION_NAME]),
    
    Cookie=config_node:cluster_cookie(?ClusterName),    
    Node=list_to_atom(?ClusterName++"@"++?HostName),
    ClusterDir=config_node:cluster_dir(?ClusterName),
    
    R1=[{FileName,dist_lib:rm_file(Node,Cookie,?DestDir,FileName)}||FileName<-?SpecFiles],

    ok=misc_cluster:delete_cluster_node(?HostName,?ClusterName),
 
       
    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
 	 

setup()->
    io:format("Start ~p~n",[?FUNCTION_NAME]),

    file:delete(?ClusterFile),
    {ok,ClusterBin}=file:read_file(?SourceClusterFile),
    ok=file:write_file(?ClusterFile,ClusterBin),
    
    file:delete(?DepFile),
    {ok,DepBin}=file:read_file(?SourceDepFile),
    ok=file:write_file(?DepFile,DepBin),

    file:delete(?HostFile),
    {ok,HostBin}=file:read_file(?SourceHostFile),
    ok=file:write_file(?HostFile,HostBin),

    file:delete(?ApplicationFile),
    {ok,ApplBin}=file:read_file(?SourceApplicationFile),
    ok=file:write_file(?ApplicationFile,ApplBin),

    OpsNodeEnv=[{ops_node,[{deployment_spec,?DepFile},
				 {cluster_spec,?ClusterFile},
				 {host_spec,?HostFile},
				 {application_spec,?ApplicationFile},
				 {spec_dir,"."}]}],
   
    ok=application:set_env(OpsNodeEnv),
 
    ok=application:start(common),
    pong=common:ping(),
    
    ok=application:start(ops_node),
    pong=ops_node:ping(),

    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),

    ok.
