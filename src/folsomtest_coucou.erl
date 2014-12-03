-module(folsomtest_coucou).

-export([start_link/0, coucou/0]).

-behavior(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(DELAY_BETWEEN_LOOKUPS, 2000).

-record(state, {timer}).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{debug, [trace]}]). 

coucou() -> gen_server:call(?MODULE, coucou).

init([]) ->
    folsom_metrics:new_counter(coucou1),
    folsom_metrics:new_counter(coucou2),
    folsom_metrics:new_counter(coucou3),

    Timer = erlang:send_after(?DELAY_BETWEEN_LOOKUPS, self(), timer_ticked),
    {ok, #state{timer=Timer}}.

handle_info(timer_ticked, #state{timer=OldTimer}=State) ->
    erlang:cancel_timer(OldTimer),

    folsom_metrics:notify({coucou1, {inc, 1}}),
    folsom_metrics:notify({coucou2, {inc, 2}}),
    folsom_metrics:notify({coucou3, {inc, 42}}),

    Timer = erlang:send_after(?DELAY_BETWEEN_LOOKUPS, self(), timer_ticked),
    {noreply, State#state{timer=Timer}}.

handle_call(_Call, _From, State) -> {noreply, State}.

handle_cast(_Cast, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
