%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  SPDX-FileCopyrightText: 1998-2023 Paulo Moura <pmoura@logtalk.org>
%  SPDX-License-Identifier: Apache-2.0
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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:4:3,
		author is 'Paulo Moura',
		date is 2021-07-26,
		comment is 'Unit tests for the "hailstone" example.'
	]).

	cover(hailstone).

	test(hailstone_1, true(Sequence == [10, 5, 16, 8, 4, 2, 1])) :-
		hailstone::generate_sequence(10, Sequence).

	:- if((
		os::operating_system_type(windows),
		\+ current_logtalk_flag(prolog_dialect, b),
		\+ current_logtalk_flag(prolog_dialect, gnu),
		\+ current_logtalk_flag(prolog_dialect, ji),
		\+ current_logtalk_flag(prolog_dialect, sicstus),
		\+ current_logtalk_flag(prolog_dialect, swi),
		\+ current_logtalk_flag(prolog_dialect, xsb)
	)).

	test(hailstone_2, true(Assertion)) :-
		^^set_text_output(''),
		hailstone::write_sequence(10),
		^^text_output_assertion('10 5 16 8 4 2 1\r\n', Assertion).

	:- else.

	test(hailstone_2, true(Assertion)) :-
		^^set_text_output(''),
		hailstone::write_sequence(10),
		^^text_output_assertion('10 5 16 8 4 2 1\n', Assertion).

	:- endif.

	test(hailstone_3, true(Length == 112)) :-
		hailstone::sequence_length(27, Length).

	test(hailstone_4, true(N-Length == 871-179)) :-
		hailstone::longest_sequence(1, 1000, N, Length).

:- end_object.
