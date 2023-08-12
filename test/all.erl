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
-module(all).      
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-define(TestHost,"c202").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    ok=hw_conbee_test(),
    
    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(2000),
   % init:stop(),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
hw_conbee_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    
    AllSensors=hw_conbee:get_all_device_info("sensors"),
    io:format("AllSensors ~p~n",[{AllSensors,?MODULE,?FUNCTION_NAME}]),
    AllLights=hw_conbee:get_all_device_info("lights"),
    io:format("AllLights ~p~n",[{AllLights,?MODULE,?FUNCTION_NAME}]),
    
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    application:load(hw_conbee),
    application:set_env([{hw_conbee,[{test_host,?TestHost}]}]),
    ok=application:start(varmdo_conbee_provider),
    pong=varmdo_conbee_provider:ping(),
    pong=etcd:ping(),
    pong=hw_conbee:ping(),
    pong=log:ping(),

    {ok,[{conbee,ConbeeConfig}]}=etcd_host:get_appl_config(?TestHost),
    {conbee_addr,ConbeeAddr}=lists:keyfind(conbee_addr,1,ConbeeConfig),
    {conbee_port,ConbeePort}=lists:keyfind(conbee_port,1,ConbeeConfig),
    {conbee_key,ConbeeKey}=lists:keyfind(conbee_key,1,ConbeeConfig),
    "172.17.0.2"=ConbeeAddr,
    80=ConbeePort,
    "24E285605D"=ConbeeKey,
   

    ok.
