%%---------------------------------------------------------------------
{{deploy_name,"this_host_not_same_pod"},
 {cluster_name,"test_cluster"},
 {num_instances,2},
  {host,{[this_host],["c100"]}},
  {pod,not_same_pod},
  {services,
   [
       {"test_add","1.0.0"},
       {"test_divi","1.0.0"},
       {"test_sub","1.0.0"}]
  }
}.
%%---------------------------------------------------------------------
{{deploy_name,"any_same_host_same_pod"},
 {cluster_name,"test_cluster"},
 {num_instances,2},
 {host,{[any_host,same_host],["c100","c200","c201"]}},
 {pod,same_pod},
 {services,
  [
      {"test_add","1.0.0"},
      {"test_divi","1.0.0"},
      {"test_sub","1.0.0"}
  ]
 }
}.

%%---------------------------------------------------------------------

{{deploy_name,"any_same_host_not_same_pod"},
 {cluster_name,"test_cluster"},
 {num_instances,2},
 {host,{[any_host,same_host],["c100","c200","c201"]}},
 {pod,not_same_pod},
 {services,
  [
      {"test_add","1.0.0"},
      {"test_divi","1.0.0"},
      {"test_sub","1.0.0"}
  ]
 }
}.

%%---------------------------------------------------------------------
{{deploy_name,"any_not_same_hosts_not_same_pods"},
 {cluster_name,"test_cluster"},
 {num_instances,2},
 {host,{[any_host,not_same_host],["c100","c200","c201"]}},
 {pod,not_same_pod},
 {services,
  [
      {"test_add","1.0.0"},
      {"test_divi","1.0.0"},
      {"test_sub","1.0.0"}
  ]
 }
}.


%%---------------------------------------------------------------------

