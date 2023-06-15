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


:- if((
	current_logtalk_flag(prolog_dialect, Dialect),
	(Dialect == eclipse; Dialect == gnu; Dialect == scryer; Dialect == sicstus; Dialect == swi; Dialect == tau; Dialect == trealla; Dialect == yap)
)).

	:- if(current_logtalk_flag(prolog_dialect, eclipse)).
		:- use_module(library(lists)).
	:- elif(current_logtalk_flag(prolog_dialect, scryer)).
		:- use_module(library(lists)).
	:- elif(current_logtalk_flag(prolog_dialect, sicstus)).
		:- use_module(library(lists)).
	:- elif(current_logtalk_flag(prolog_dialect, swi)).
		:- use_module(library(apply), []).
	:- elif(current_logtalk_flag(prolog_dialect, tau)).
		:- use_module(library(lists)).
	:- elif(current_logtalk_flag(prolog_dialect, trealla)).
		:- use_module(library(apply)).
	:- elif(current_logtalk_flag(prolog_dialect, yap)).
		:- use_module(library(maplist), []).
	:- endif.

	:- initialization((
		logtalk_load(basic_types(loader)),
		logtalk_load(symbiosis)
	)).

:- else.

	:- initialization((
		write('(not applicable)'), nl
	)).

:- endif.
