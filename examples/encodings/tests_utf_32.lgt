:- encoding('UTF-32').
% the encoding/1 directive, when present, must be the
% first term, in the first line, of a source file


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2020 Paulo Moura <pmoura@logtalk.org>
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(tests_utf_32,
	extends(lgtunit)).

	:- info([
		version is 1:1:0,
		author is 'Parker Jones and Paulo Moura',
		date is 2012/08/06,
		comment is 'Unit tests for the "encodings" example.'
	]).

	cover(mythology).

	test(encodings_utf_32_1) :-
		findall(Greek-English, mythology::divinity(English, Greek), Solutions),
		Solutions == ['Ηρα'-hera, 'Καλυψω'-kalypso, 'Μορφευς'-morpheus, 'Ποσειδων'-poseidon, 'Ζευς'-zeus].

:- end_object.
