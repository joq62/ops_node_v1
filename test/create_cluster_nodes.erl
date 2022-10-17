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
-module(create_cluster_nodes).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-define(Id_c1,"c1").

-define(SourceDir,"./test/specs").
-define(DestDir,".").
-define(SpecFiles,["spec.deployment","spec.cluster","spec.host","spec.application"]).

-define(SourceDepFile,"./test/specs/spec.deployment").
-define(DepFile,"spec.deployment").
-define(SourceClusterFile,"./test/specs/spec.cluster").
-define(ClusterFile,"spec.cluster").
-define(SourceHostFile,"./test/specs/spec.host").
-define(HostFile,"spec.host").
-define(SourceApplicationFile,"./test/specs/spec.application").
-define(ApplicationFile,"spec.application").

		 

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(HostNames,["c100","c300","c200","c201"]).
-define(HostName,"c100").
-define(ClusterName,"test_cluster").
-define(DeplName,"any_not_same_hosts_not_same_pods").

start()->
   
    ok=setup(),

    ok=create_node(),
    ok=copy_spec_files(),

    ok=delete_spec_files(),
    ok=delete_node(),
 %   ok=pod_candidates(),
  
    io:format("Test OK !!! ~p~n",[?MODULE]),
    init:stop(),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
copy_spec_files()->

    io:format("Start ~p~n",[?FUNCTION_NAME]),

    Cookie=config_node:cluster_cookie(?ClusterName),    
    Node=list_to_atom(?ClusterName++"@"++?HostName),
    
    R1=[{FileName,dist_lib:rm_file(Node,Cookie,?DestDir,FileName)}||FileName<-?SpecFiles],
    io:format("R1 ~p~n",[R1]),
    R2=[{FileName,dist_lib:cp_file(Node,Cookie,?SourceDir,FileName,?DestDir)}||FileName<-?SpecFiles],
    io:format("R2 ~p~n",[R2]),


    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),
    ok.
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
create_node()->
    io:format("Start ~p~n",[?FUNCTION_NAME]),
    
    Cookie=config_node:cluster_cookie(?ClusterName),    
    Node=list_to_atom(?ClusterName++"@"++?HostName),

    {ok,Node,ClusterDir,StartList}=misc_cluster:create_cluster_node(?HostName,?ClusterName),
   % io:format(",Node,ClusterDir,StartList ~p~n",[{Node,ClusterDir,StartList}]),
    pong=dist_lib:cmd(Node,Cookie,net_adm,ping,[Node],5000),
    true=dist_lib:cmd(Node,Cookie,filelib,is_dir,[ClusterDir],5000),
    PingTest=[{Service,dist_lib:cmd(Node,Cookie,Service,ping,[],5000)}||{ok,Service,_Dir}<-StartList],
    [{cluster_node,pong},
     {nodelog,pong},
     {sd,pong}
    ]=lists:sort(PingTest),
    
    [{'test_cluster@c100',"c100",
      [{cluster_node,"An OTP application","0.1.0"},
       {nodelog,"An OTP application","0.1.0"},
       {sd,"An OTP application","0.1.0"},
       {stdlib,"ERTS  CXC 138 10","3.11.2"},
       {kernel,"ERTS  CXC 138 10","6.5.1"}]}
    ]=lists:sort(dist_lib:cmd(Node,Cookie,sd,all,[],5000)),
    
    

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
 
    ok=application:start(common),
    pong=common:ping(),
    ok=application:start(config_node),
    pong=config_node:ping(),
    ok=application:start(ops_node),
    pong=ops_node:ping(),

    misc_cluster:delete_cluster_node(?HostName,?ClusterName),
    

    io:format("Stop OK !!! ~p~n",[?FUNCTION_NAME]),

    ok.
