_this = _this select 3;
_art  = _this select 0;
_moneh = [player, 'money'] call INV_GetItemAmount;

chief_elections_term = 20; //number of minutes between elections
server setVariable ["next_chief_election", -1, true];

if (_art == "serverloop") then {	
	_currentchief = -1;
	_iteration_delay = 30;
	_iterations = (chief_elections_term * 60) / _iteration_delay;
	_iterations = round _iterations;
	
	//player groupChat format["ITER: %1", _iterations];
	
	while {true} do {
		server setVariable ["next_chief_election", -1, true];
		private["_i"];
		for [{_i=0}, {_i < _iterations}, {_i=_i+1}] do {
			sleep _iteration_delay;
		
			//calculate time for end of goverment term
			
			_time_left = round(((chief_elections_term * 60) - (_i * 30))/60);
			//player groupChat format["updating time left: %1", _time_left];
			server setVariable ["next_chief_election", _time_left, true];
			private["_k"];
			for [{_k=0}, {_k < count(WahlArrayc)}, {_k=_k+1}] do {
				private["_player_variable_name", "_player_variable"];
				_player_variable_name = PlayerStringArray select _k;
				_player_variable = missionNamespace getVariable _player_variable_name;
				if(!isNil "_player_variable") then {
				if (not([_player_variable] call player_exists)) then { 
					WahlArrayc SET [_k, [] ];
				};	
				};
			};
		};

		private["_MaxStimmen", "_MaxPos"];
		_MaxStimmen = 0;
		_MaxPos = -1;
		private["_x"];
		for [{_x=0}, {_x < count(WahlArrayc)}, {_x=_x+1}] do {
			private["_player_variable", "_player_variable_name"];
			_player_variable_name = (PlayerStringArray select _x);
			_player_variable = missionNamespace getVariable _player_variable_name;
			
			if(!isNil "_player_variable") then {
			if ( ((count (WahlArrayc select _x)) > _MaxStimmen) and ([_player_variable] call player_exists)) then {	
				_MaxStimmen = (count (WahlArrayc select _x));
				_MaxPos = _x;
			};};
		};	

		if (_MaxPos == -1) then {
			"hint localize ""STRS_chief_nomajor"";" call broadcast;_currentchief = -1;
		} 
		else { if (_currentchief == _MaxPos) then {
			"hint localize ""STRS_chief_majorstays"";" call broadcast;
		} 
		else {
			_currentchief = _MaxPos;
			_chiefString  = (PlayerStringArray select _currentchief);
			format["hint format[localize ""STRS_chief_new"", ""%3"", %2]; if ((rolenumber-1) == %1) then {ischief = true;} else {ischief = false;};", _MaxPos, _MaxStimmen, _chiefString] call broadcast;	
		};};
		
		chiefNumber = _currentchief;
		publicVariable "chiefNumber";
	};
};
