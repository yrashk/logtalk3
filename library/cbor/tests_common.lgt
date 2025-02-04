%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  SPDX-FileCopyrightText: 2021 Paulo Moura <pmoura@logtalk.org>
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


:- object(tests_common,
	extends(lgtunit)).

	:- info([
		version is 0:14:0,
		author is 'Paulo Moura',
		date is 2021-06-02,
		comment is 'Unit tests for the "cbor" library (common).'
	]).

	:- uses(cbor, [
		parse/2, generate/2
	]).

	:- uses(lgtunit, [
		op(700, xfx, '=~='), '=~='/2
	]).

	cover(cbor).
	cover(cbor(_)).

	condition :-
		current_prolog_flag(bounded, false).

	% test cases from the https://tools.ietf.org/html/rfc8949#appendix-A table
	% the test numbers are the table row numbers; all encoding tests that use
	% encoding indicators are ommitted as these are not currently supported
	%
	% the four tests that require backend Unicode support are found in the
	% tests_utf_8.lgt source file
	%
	% most tests for encoding floats use roundtrip testing instead of checking
	% for the expected encoding to avoid float precision representation issues
	% making the tests fail

	% parse/2 tests

	test(cbor_parse_2_01, true(Term == 0)) :-
		parse([0x00], Term).

	test(cbor_parse_2_02, true(Term == 1)) :-
		parse([0x01], Term).

	test(cbor_parse_2_03, true(Term == 10)) :-
		parse([0x0a], Term).

	test(cbor_parse_2_04, true(Term == 23)) :-
		parse([0x17], Term).

	test(cbor_parse_2_05, true(Term == 24)) :-
		parse([0x18, 0x18], Term).

	test(cbor_parse_2_06, true(Term == 25)) :-
		parse([0x18, 0x19], Term).

	test(cbor_parse_2_07, true(Term == 100)) :-
		parse([0x18, 0x64], Term).

	test(cbor_parse_2_08, true(Term == 1000)) :-
		parse([0x19, 0x03, 0xe8], Term).

	test(cbor_parse_2_09, true(Term == 1000000)) :-
		parse([0x1a, 0x00, 0x0f, 0x42, 0x40], Term).

	test(cbor_parse_2_10, true(Term == 1000000000000)) :-
		parse([0x1b, 0x00, 0x00, 0x00, 0xe8, 0xd4, 0xa5, 0x10, 0x00], Term).

	test(cbor_parse_2_11, true(Term == 18446744073709551615)) :-
		parse([0x1b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff], Term).

	test(cbor_parse_2_12, true(Term == 18446744073709551616)) :-
		parse([0xc2, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], Term).

	test(cbor_parse_2_13, true(Term == -18446744073709551616)) :-
		parse([0x3b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff], Term).

	test(cbor_parse_2_14, true(Term == -18446744073709551617)) :-
		parse([0xc3, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], Term).

	test(cbor_parse_2_15, true(Term == -1)) :-
		parse([0x20], Term).

	test(cbor_parse_2_16, true(Term == -10)) :-
		parse([0x29], Term).

	test(cbor_parse_2_17, true(Term == -100)) :-
		parse([0x38, 0x63], Term).

	test(cbor_parse_2_18, true(Term == -1000)) :-
		parse([0x39, 0x03, 0xe7], Term).

	test(cbor_parse_2_19, true(Term == 0.0)) :-
		parse([0xf9, 0x00, 0x00], Term).

	test(cbor_parse_2_20, true(Term == -0.0)) :-
		parse([0xf9, 0x80, 0x00], Term).

	test(cbor_parse_2_21a, true(Term =~= 1.0)) :-
		parse([0xf9, 0x3c, 0x00], Term).

	test(cbor_parse_2_21b, true(Term =~= 1.0)) :-
		% decimal fraction encoding
		parse([0xc4, 0x82, 0x20, 0x0a], Term).

	test(cbor_parse_2_22a, true(Term =~= 1.1)) :-
		parse([0xfb, 0x3f, 0xf1, 0x99, 0x99, 0x99, 0x99, 0x99, 0x9a], Term).

	test(cbor_parse_2_22b, true(Term =~= 1.1)) :-
		parse([0xc4, 0x82, 0x20, 0x0b], Term).

	test(cbor_parse_2_23a, true(Term =~= 1.5)) :-
		parse([0xf9, 0x3e, 0x00], Term).

	test(cbor_parse_2_23b, true(Term =~= 1.5)) :-
		% decimal fraction encoding
		parse([0xc4, 0x82, 0x20, 0x0f], Term).

	test(cbor_parse_2_24a, true(Term =~= 65504.0)) :-
		parse([0xf9, 0x7b, 0xff], Term).

	test(cbor_parse_2_24b, true(Term =~= 65504.0)) :-
		% decimal fraction encoding
		parse([0xc4, 0x82, 0x20, 0x1a, 0x00, 0x09, 0xfe, 0xc0], Term).

	test(cbor_parse_2_25a, true(Term =~= 100000.0)) :-
		parse([0xfa, 0x47, 0xc3, 0x50, 0x00], Term).

	test(cbor_parse_2_25b, true(Term =~= 100000.0)) :-
		% decimal fraction encoding
		parse([0xc4, 0x82, 0x20, 0x1a, 0x00, 0x0f, 0x42, 0x40], Term).

	test(cbor_parse_2_26, true(Term =~= 3.4028234663852886e+38)) :-
		parse([0xfa, 0x7f, 0x7f, 0xff, 0xff], Term).

	test(cbor_parse_2_27, true(Term =~= 1.0e+300)) :-
		parse([0xfb, 0x7e, 0x37, 0xe4, 0x3c, 0x88, 0x00, 0x75, 0x9c], Term).

	test(cbor_parse_2_28, true(Term =~= 5.960464477539063e-8)) :-
		parse([0xf9, 0x00, 0x01], Term).

	test(cbor_parse_2_29, true(Term =~= 0.00006103515625)) :-
		parse([0xf9, 0x04, 0x00], Term).

	test(cbor_parse_2_30, true(Term =~= -4.0)) :-
		parse([0xf9, 0xc4, 0x00], Term).

	test(cbor_parse_2_31, true(Term =~= -4.1)) :-
		parse([0xfb,0xc0, 0x10, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66], Term).

	test(cbor_parse_2_32, true(Term == @infinity)) :-
		parse([0xf9, 0x7c, 0x00], Term).

	test(cbor_parse_2_33, true(Term == @not_a_number)) :-
		parse([0xf9, 0x7e, 0x00], Term).

	test(cbor_parse_2_34, true(Term == @negative_infinity)) :-
		parse([0xf9, 0xfc, 0x00], Term).

	test(cbor_parse_2_35, true(Term == @infinity)) :-
		parse([0xfa, 0x7f, 0x80, 0x00, 0x00], Term).

	test(cbor_parse_2_36, true(Term == @not_a_number)) :-
		parse([0xfa, 0x7f, 0xc0, 0x00, 0x00], Term).

	test(cbor_parse_2_37, true(Term == @negative_infinity)) :-
		parse([0xfa, 0xff, 0x80, 0x00, 0x00], Term).

	test(cbor_parse_2_38, true(Term == @infinity)) :-
		parse([0xfb, 0x7f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], Term).

	test(cbor_parse_2_39, true(Term == @not_a_number)) :-
		parse([0xfb, 0x7f, 0xf8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], Term).

	test(cbor_parse_2_40, true(Term == @negative_infinity)) :-
		parse([0xfb, 0xff, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], Term).

	test(cbor_parse_2_41, true(Term == @false)) :-
		parse([0xf4], Term).

	test(cbor_parse_2_42, true(Term == @true)) :-
		parse([0xf5], Term).

	test(cbor_parse_2_43, true(Term == @null)) :-
		parse([0xf6], Term).

	test(cbor_parse_2_44, true(Term == @undefined)) :-
		parse([0xf7], Term).

	test(cbor_parse_2_45, true(Term == simple(16))) :-
		parse([0xf0], Term).

	test(cbor_parse_2_46, true(Term == simple(255))) :-
		parse([0xf8, 0xff], Term).

	test(cbor_parse_2_47, true(Term == tag(0,'2013-03-21T20:04:00Z'))) :-
		parse([0xc0, 0x74, 0x32, 0x30, 0x31, 0x33, 0x2d, 0x30, 0x33, 0x2d, 0x32, 0x31, 0x54, 0x32, 0x30, 0x3a, 0x30, 0x34, 0x3a, 0x30, 0x30, 0x5a], Term).

	test(cbor_parse_2_48, true(Term == tag(1, 1363896240))) :-
		parse([0xc1, 0x1a, 0x51, 0x4b, 0x67, 0xb0], Term).

	test(cbor_parse_2_49, true(Term == tag(1, 1363896240.5))) :-
		parse([0xc1, 0xfb, 0x41, 0xd4, 0x52, 0xd9, 0xec, 0x20, 0x00, 0x00], Term).

	test(cbor_parse_2_50, true(Term == tag(23, bytes([0x01, 0x02, 0x03, 0x04])))) :-
		parse([0xd7, 0x44, 0x01, 0x02, 0x03, 0x04], Term).

	test(cbor_parse_2_51, true(Term == tag(24, bytes([0x64, 0x49, 0x45, 0x54, 0x46])))) :-
		parse([0xd8, 0x18, 0x45, 0x64, 0x49, 0x45, 0x54, 0x46], Term).

	test(cbor_parse_2_52, true(Term == tag(32, 'http://www.example.com'))) :-
		parse([0xd8, 0x20, 0x76, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x77, 0x77, 0x77, 0x2e, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x2e, 0x63, 0x6f, 0x6d], Term).

	test(cbor_parse_2_53, true(Term == bytes([]))) :-
		parse([0x40], Term).

	test(cbor_parse_2_54, true(Term == bytes([0x01, 0x02, 0x03, 0x04]))) :-
		parse([0x44, 0x01, 0x02, 0x03, 0x04], Term).

	test(cbor_parse_2_55, true(Term == '')) :-
		parse([0x60], Term).

	test(cbor_parse_2_56, true(Term == 'a')) :-
		parse([0x61, 0x61], Term).

	test(cbor_parse_2_57, true(Term == 'IETF')) :-
		parse([0x64, 0x49, 0x45, 0x54, 0x46], Term).

	test(cbor_parse_2_58, true(Term == '\'\\')) :-
		parse([0x62, 0x27, 0x5c], Term).

	test(cbor_parse_2_62, true(Term == [])) :-
		parse([0x80], Term).

	test(cbor_parse_2_63, true(Term == [1, 2, 3])) :-
		parse([0x83, 0x01, 0x02, 0x03], Term).

	test(cbor_parse_2_64, true(Term == [1, [2, 3], [4, 5]])) :-
		parse([0x83, 0x01, 0x82, 0x02, 0x03, 0x82, 0x04, 0x05], Term).

	test(cbor_parse_2_65, true(Term == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25])) :-
		parse([0x98, 0x19, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x18, 0x18, 0x19], Term).

	test(cbor_parse_2_66, true(Term == {})) :-
		parse([0xa0], Term).

	test(cbor_parse_2_67, true(Term == {1-2, 3-4})) :-
		parse([0xa2, 0x01, 0x02, 0x03, 0x04], Term).

	test(cbor_parse_2_68, true(Term == {a-1, b-[2,3]})) :-
		parse([0xa2, 0x61, 0x61, 0x01, 0x61, 0x62, 0x82, 0x02, 0x03], Term).

	test(cbor_parse_2_69, true(Term == [a, {b-c}])) :-
		parse([0x82, 0x61, 0x61, 0xa1, 0x61, 0x62, 0x61, 0x63], Term).

	test(cbor_parse_2_70, true(Term == {a-'A', b-'B', c-'C', d-'D', e-'E'})) :-
		parse([0xa5, 0x61, 0x61, 0x61, 0x41, 0x61, 0x62, 0x61, 0x42, 0x61, 0x63, 0x61, 0x43, 0x61, 0x64, 0x61, 0x44, 0x61, 0x65, 0x61, 0x45], Term).

	% (_ h'0102', h'030405')
	test(cbor_parse_2_71, true(Term == bytes([1, 2, 3, 4, 5]))) :-
		parse([0x5f, 0x42, 0x01, 0x02, 0x43, 0x03, 0x04, 0x05, 0xff], Term).

	% (_ "strea", "ming")
	test(cbor_parse_2_72, true(Term == streaming)) :-
		parse([0x7f, 0x65, 0x73, 0x74, 0x72, 0x65, 0x61, 0x64, 0x6d, 0x69, 0x6e, 0x67, 0xff], Term).

	% [_ ]
	test(cbor_parse_2_73, true(Term == [])) :-
		parse([0x9f, 0xff], Term).

	% [_ 1, [2, 3], [_ 4, 5]]
	test(cbor_parse_2_74, true(Term == [1, [2,3], [4,5]])) :-
		parse([0x9f, 0x01, 0x82, 0x02, 0x03, 0x9f, 0x04, 0x05, 0xff, 0xff], Term).

	% [_ 1, [2, 3], [4, 5]]
	test(cbor_parse_2_75, true(Term == [1, [2,3], [4,5]])) :-
		parse([0x9f, 0x01, 0x82, 0x02, 0x03, 0x82, 0x04, 0x05, 0xff], Term).

	% [1, [2, 3], [_ 4, 5]]
	test(cbor_parse_2_76, true(Term == [1, [2,3], [4,5]])) :-
		parse([0x83, 0x01, 0x82, 0x02, 0x03, 0x9f, 0x04, 0x05, 0xff], Term).

	% [1, [_ 2, 3], [4, 5]]
	test(cbor_parse_2_77, true(Term == [1, [2,3], [4,5]])) :-
		parse([0x83, 0x01, 0x9f, 0x02, 0x03, 0xff, 0x82, 0x04, 0x05], Term).

	% [_ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
	test(cbor_parse_2_78, true(Term == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25])) :-
		parse([0x9f, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x18, 0x18, 0x19, 0xff], Term).

	% {_ "a": 1, "b": [_ 2, 3]}
	test(cbor_parse_2_79, true(Term == {a-1, b-[2,3]})) :-
		parse([0xbf, 0x61, 0x61, 0x01, 0x61, 0x62, 0x9f, 0x02, 0x03, 0xff, 0xff], Term).

	% ["a", {_ "b": "c"}]
	test(cbor_parse_2_80, true(Term == [a, {b-c}])) :-
		parse([0x82, 0x61, 0x61, 0xbf, 0x61, 0x62, 0x61, 0x63, 0xff], Term).

	% {_ "Fun": true, "Amt": -2}
	test(cbor_parse_2_81, true(Term == {'Fun'-(@true), 'Amt'-(-2)})) :-
		parse([0xbf, 0x63, 0x46, 0x75, 0x6e, 0xf5, 0x63, 0x41, 0x6d, 0x74, 0x21, 0xff], Term).

	% indefinite length encoding tests

	test(cbor_indefinite_length_byte_string_empty, true(Term == bytes([]))) :-
		parse([0x5f, 0xff], Term).

	test(cbor_indefinite_length_byte_string_non_empty, true(Term == bytes([0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x99]))) :-
		parse([0x5f, 0x44, 0xaa, 0xbb, 0xcc, 0xdd, 0x43, 0xee, 0xff, 0x99, 0xff], Term).

	test(cbor_indefinite_length_array_empty, true(Term == [])) :-
		parse([0x9f, 0xff], Term).

	test(cbor_indefinite_length_map_empty, true(Term == {})) :-
		parse([0xbf, 0xff], Term).

	% fixed length encoding tests

	test(cbor_fixed_length_text_string, true(Term == 'hello world')) :-
		parse([0x6b, 0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64], Term).

	test(cbor_fixed_length_map, true(Term == {a-1,b-2,c-3})) :-
		parse([0xa3, 0x61, 0x61, 0x01, 0x61, 0x62, 0x02, 0x61, 0x63, 0x03], Term).

	% text representation tests

	test(cbor_string_as_atom, true(Term == 'hello')) :-
		cbor(atom)::parse([0x65, 0x68, 0x65, 0x6c, 0x6c, 0x6f], Term).

	test(cbor_string_as_chars, true(Term == chars([h,e,l,l,o]))) :-
		cbor(chars)::parse([0x65, 0x68, 0x65, 0x6c, 0x6c, 0x6f], Term).

	test(cbor_string_as_codes, true(Term == codes([104, 101, 108, 108, 111]))) :-
		cbor(codes)::parse([0x65, 0x68, 0x65, 0x6c, 0x6c, 0x6f], Term).

	% generate/2 tests

	test(cbor_generate_2_01, true(Encoding == [0x00])) :-
		generate(0, Encoding).

	test(cbor_generate_2_02, true(Encoding == [0x01])) :-
		generate(1, Encoding).

	test(cbor_generate_2_03, true(Encoding == [0x0a])) :-
		generate(10, Encoding).

	test(cbor_generate_2_04, true(Encoding == [0x17])) :-
		generate(23, Encoding).

	test(cbor_generate_2_05, true(Encoding == [0x18, 0x18])) :-
		generate(24, Encoding).

	test(cbor_generate_2_06, true(Encoding == [0x18, 0x19])) :-
		generate(25, Encoding).

	test(cbor_generate_2_07, true(Encoding == [0x18, 0x64])) :-
		generate(100, Encoding).

	test(cbor_generate_2_08, true(Encoding == [0x19, 0x03, 0xe8])) :-
		generate(1000, Encoding).

	test(cbor_generate_2_09, true(Encoding == [0x1a, 0x00, 0x0f, 0x42, 0x40])) :-
		generate(1000000, Encoding).

	test(cbor_generate_2_10, true(Encoding == [0x1b, 0x00, 0x00, 0x00, 0xe8, 0xd4, 0xa5, 0x10, 0x00])) :-
		generate(1000000000000, Encoding).

	test(cbor_generate_2_11, true(Encoding == [0x1b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])) :-
		generate(18446744073709551615, Encoding).

	test(cbor_generate_2_12, true(Encoding == [0xc2, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])) :-
		generate(18446744073709551616, Encoding).

	test(cbor_generate_2_13, true(Encoding == [0x3b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])) :-
		generate(-18446744073709551616, Encoding).

	test(cbor_generate_2_14, true(Encoding == [0xc3, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])) :-
		generate(-18446744073709551617, Encoding).

	test(cbor_generate_2_15, true(Encoding == [0x20])) :-
		generate(-1, Encoding).

	test(cbor_generate_2_16, true(Encoding == [0x29])) :-
		generate(-10, Encoding).

	test(cbor_generate_2_17, true(Encoding == [0x38, 0x63])) :-
		generate(-100, Encoding).

	test(cbor_generate_2_18, true(Encoding == [0x39, 0x03, 0xe7])) :-
		generate(-1000, Encoding).

	test(cbor_generate_2_19, true(Encoding == [0xf9, 0x00, 0x00])) :-
		generate(0.0, Encoding).

	test(cbor_generate_2_20, true(Encoding == [0xf9, 0x80, 0x00]), [condition(-0.0 \== 0.0)]) :-
		generate(-0.0, Encoding).

	- test(cbor_generate_2_21a, true(Encoding == [0xf9, 0x3c, 0x00])) :-
		generate(1.0, Encoding).

	test(cbor_generate_2_21b, true(Encoding == [0xc4, 0x82, 0x20, 0x0a])) :-
		% decimal fraction encoding
		generate(1.0, Encoding).

	- test(cbor_generate_2_22a, true(Encoding == [0xfb, 0x3f, 0xf1, 0x99, 0x99, 0x99, 0x99, 0x99, 0x9a])) :-
		generate(1.1, Encoding).

	- test(cbor_generate_2_22b, true(Encoding == [0xc4, 0x82, 0x20, 0x0b])) :-
		% decimal fraction encoding
		generate(1.1, Encoding).

	test(cbor_generate_2_22c, true(Float =~= 1.1)) :-
		generate(1.1, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_23a, true(Encoding == [0xf9, 0x3e, 0x00])) :-
		generate(1.5, Encoding).

	- test(cbor_generate_2_23b, true(Encoding == [0xc4, 0x82, 0x20, 0x0f])) :-
		% decimal fraction encoding
		generate(1.5, Encoding).

	test(cbor_generate_2_23c, true(Float =~= 1.5)) :-
		generate(1.5, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_24a, true(Encoding == [0xf9, 0x7b, 0xff])) :-
		generate(65504.0, Encoding).

	test(cbor_generate_2_24b, true(Encoding == [0xc4, 0x82, 0x20, 0x1a, 0x00, 0x09, 0xfe, 0xc0])) :-
		% decimal fraction encoding
		generate(65504.0, Encoding).

	- test(cbor_generate_2_25a, true(Encoding == [0xfa, 0x47, 0xc3, 0x50, 0x00])) :-
		generate(100000.0, Encoding).

	test(cbor_generate_2_25b, true((Encoding == [0xc4, 0x82, 0x20, 0x1a, 0x00, 0x0f, 0x42, 0x40]; Encoding == [196,130,4,10]))) :-
		% decimal fraction encoding
		generate(100000.0, Encoding).

	- test(cbor_generate_2_26a, true(Encoding == [0xfa, 0x7f, 0x7f, 0xff, 0xff])) :-
		generate(3.4028234663852886e+38, Encoding).

	- test(cbor_generate_2_26b, true(Encoding == [0xc4, 0x82, 0x16, 0x1b, 0x00, 0x78, 0xe4, 0x7f, 0xc7, 0x78, 0xfb, 0x56])) :-
		% decimal fraction encoding
		generate(3.4028234663852886e+38, Encoding).

	test(cbor_generate_2_26c, true(Float =~= 3.4028234663852886e+38)) :-
		generate(3.4028234663852886e+38, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_27a, true(Encoding == [0xfb, 0x7e, 0x37, 0xe4, 0x3c, 0x88, 0x00, 0x75, 0x9c])) :-
		generate(1.0e+300, Encoding).

	- test(cbor_generate_2_27b, true(Encoding == [0xc4, 0x82, 0x19, 0x01, 0x2b, 0x0a])) :-
		% decimal fraction encoding
		generate(1.0e+300, Encoding).

	test(cbor_generate_2_27c, true(Float =~= 1.0e+300)) :-
		generate(1.0e+300, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_28a, true(Encoding == [0xf9, 0x00, 0x01])) :-
		generate(5.960464477539063e-8, Encoding).

	- test(cbor_generate_2_28b, true(Encoding == [0xc4, 0x82, 0x36, 0x1b, 0x00, 0x15, 0x2d, 0x02, 0xc7, 0xe1, 0x4a, 0xf7])) :-
		% decimal fraction encoding
		generate(5.960464477539063e-8, Encoding).

	test(cbor_generate_2_28c, true(Float =~= 5.960464477539063e-8)) :-
		generate(5.960464477539063e-8, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_29a, true(Encoding == [0xf9, 0x04, 0x00])) :-
		generate(0.00006103515625, Encoding).

	- test(cbor_generate_2_29b, true(Encoding == [0xc4, 0x82, 0x2d, 0x1b, 0x00, 0x00, 0x00, 0x01, 0x6b, 0xcc, 0x41, 0xe9])) :-
		% decimal fraction encoding
		generate(0.00006103515625, Encoding).

	test(cbor_generate_2_29c, true(Float =~= 0.00006103515625)) :-
		generate(0.00006103515625, Encoding),
		parse(Encoding, Float).

	- test(cbor_generate_2_30a, true(Encoding == [0xf9, 0xc4, 0x00])) :-
		generate(-4.0, Encoding).

	test(cbor_generate_2_30b, true(Encoding == [0xc4, 0x82, 0x20, 0x38, 0x27])) :-
		% decimal fraction encoding
		generate(-4.0, Encoding).

	- test(cbor_generate_2_31a, true(Encoding == [0xfb, 0xc0, 0x10, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66])) :-
		generate(-4.1, Encoding).

	- test(cbor_generate_2_31b, true(Encoding == [0xc4, 0x82, 0x20, 0x38, 0x28])) :-
		% decimal fraction encoding
		generate(-4.1, Encoding).

	test(cbor_generate_2_31c, true(Float =~= -4.1)) :-
		generate(-4.1, Encoding),
		parse(Encoding, Float).

	test(cbor_generate_2_32, true(Encoding == [0xf9, 0x7c, 0x00])) :-
		generate(@infinity, Encoding).

	test(cbor_generate_2_33, true(Encoding == [0xf9, 0x7e, 0x00])) :-
		generate(@not_a_number, Encoding).

	test(cbor_generate_2_34, true(Encoding == [0xf9, 0xfc, 0x00])) :-
		generate(@negative_infinity, Encoding).

	- test(cbor_generate_2_35, true(Encoding == [0xfa, 0x7f, 0x80, 0x00, 0x00])) :-
		generate(@infinity, Encoding).

	- test(cbor_generate_2_36, true(Encoding == [0xfa, 0x7f, 0xc0, 0x00, 0x00])) :-
		generate(@not_a_number, Encoding).

	- test(cbor_generate_2_37, true(Encoding == [0xfa, 0xff, 0x80, 0x00, 0x00])) :-
		generate(@negative_infinity, Encoding).

	- test(cbor_generate_2_38, true(Encoding == [0xfb, 0x7f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])) :-
		generate(@infinity, Encoding).

	- test(cbor_generate_2_39, true(Encoding == [0xfb, 0x7f, 0xf8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])) :-
		generate(@not_a_number, Encoding).

	- test(cbor_generate_2_40, true(Encoding == [0xfb, 0xff, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])) :-
		generate(@negative_infinity, Encoding).

	test(cbor_generate_2_41, true(Encoding == [0xf4])) :-
		generate(@false, Encoding).

	test(cbor_generate_2_42, true(Encoding == [0xf5])) :-
		generate(@true, Encoding).

	test(cbor_generate_2_43, true(Encoding == [0xf6])) :-
		generate(@null, Encoding).

	test(cbor_generate_2_44, true(Encoding == [0xf7])) :-
		generate(@undefined, Encoding).

	test(cbor_generate_2_45, true(Encoding == [0xf0])) :-
		generate(simple(16), Encoding).

	test(cbor_generate_2_46, true(Encoding == [0xf8, 0xff])) :-
		generate(simple(255), Encoding).

	test(cbor_generate_2_47, true(Encoding == [0xc0, 0x74, 0x32, 0x30, 0x31, 0x33, 0x2d, 0x30, 0x33, 0x2d, 0x32, 0x31, 0x54, 0x32, 0x30, 0x3a, 0x30, 0x34, 0x3a, 0x30, 0x30, 0x5a])) :-
		generate(tag(0, '2013-03-21T20:04:00Z'), Encoding).

	test(cbor_generate_2_48, true(Encoding == [0xc1, 0x1a, 0x51, 0x4b, 0x67, 0xb0])) :-
		generate(tag(1, 1363896240), Encoding).

	- test(cbor_generate_2_49a, true(Encoding == [0xc1, 0xfb, 0x41, 0xd4, 0x52, 0xd9, 0xec, 0x20, 0x00, 0x00])) :-
		generate(tag(1, 1363896240.5), Encoding).

	test(cbor_generate_2_49b, true(Encoding == [0xc1, 0xc4, 0x82, 0x20, 0x1b, 0x00, 0x00, 0x00, 0x03, 0x2c, 0xf2, 0x0c, 0xe5])) :-
		% decimal fraction encoding
		generate(tag(1, 1363896240.5), Encoding).

	test(cbor_generate_2_50, true(Encoding == [0xd7, 0x44, 0x01, 0x02, 0x03, 0x04])) :-
		generate(tag(23, bytes([0x01, 0x02, 0x03, 0x04])), Encoding).

	test(cbor_generate_2_51, true(Encoding == [0xd8, 0x18, 0x45, 0x64, 0x49, 0x45, 0x54, 0x46])) :-
		generate(tag(24, bytes([0x64, 0x49, 0x45, 0x54, 0x46])), Encoding).

	test(cbor_generate_2_52, true(Encoding == [0xd8, 0x20, 0x76, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x77, 0x77, 0x77, 0x2e, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x2e, 0x63, 0x6f, 0x6d])) :-
		generate(tag(32, 'http://www.example.com'), Encoding).

	test(cbor_generate_2_53, true(Encoding == [0x40])) :-
		generate(bytes([]), Encoding).

	test(cbor_generate_2_54, true(Encoding == [0x44, 0x01, 0x02, 0x03, 0x04])) :-
		generate(bytes([0x01, 0x02, 0x03, 0x04]), Encoding).

	test(cbor_generate_2_55, true(Encoding == [0x60])) :-
		generate('', Encoding).

	test(cbor_generate_2_56, true(Encoding == [0x61, 0x61])) :-
		generate('a', Encoding).

	test(cbor_generate_2_57, true(Encoding == [0x64, 0x49, 0x45, 0x54, 0x46])) :-
		generate('IETF', Encoding).

	test(cbor_generate_2_58, true(Encoding == [0x62, 0x27, 0x5c])) :-
		generate('\'\\', Encoding).

	test(cbor_generate_2_62, true(Encoding == [0x80])) :-
		generate([], Encoding).

	test(cbor_generate_2_63, true(Encoding == [0x9f, 0x01, 0x02, 0x03, 0xff])) :-
		generate([1, 2, 3], Encoding).

	test(cbor_generate_2_64, true(Encoding == [0x9f, 0x01, 0x9f, 0x02, 0x03, 0xff, 0x9f, 0x04, 0x05, 0xff, 0xff])) :-
		generate([1, [2, 3], [4, 5]], Encoding).

	test(cbor_generate_2_65, true(Encoding == [0x9f, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x18, 0x18, 0x19, 0xff])) :-
		generate([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], Encoding).

	test(cbor_generate_2_66, true(Encoding == [0xa0])) :-
		generate({}, Encoding).

	- test(cbor_generate_2_67a, true(Encoding == [0xa2, 0x01, 0x02, 0x03, 0x04])) :-
		generate({1-2, 3-4}, Encoding).

	test(cbor_generate_2_67b, true(Encoding == [0xbf, 0x01, 0x02, 0x03, 0x04, 0xff])) :-
		generate({1-2, 3-4}, Encoding).

	test(cbor_generate_2_68, true(Encoding == [0xbf, 0x61, 0x61, 0x01, 0x61, 0x62, 0x9f, 0x02, 0x03, 0xff, 0xff])) :-
		generate({a-1, b-[2, 3]}, Encoding).

	test(cbor_generate_2_69, true(Encoding == [0x9f, 0x61, 0x61, 0xbf, 0x61, 0x62, 0x61, 0x63, 0xff, 0xff])) :-
		generate([a, {b-c}], Encoding).

	- test(cbor_generate_2_70a, true(Encoding == [0xa5, 0x61, 0x61, 0x61, 0x41, 0x61, 0x62, 0x61, 0x42, 0x61, 0x63, 0x61, 0x43, 0x61, 0x64, 0x61, 0x44, 0x61, 0x65, 0x61, 0x45])) :-
		generate({a-'A', b-'B', c-'C', d-'D', e-'E'}, Encoding).

	test(cbor_generate_2_70b, true(Encoding == [0xbf, 0x61, 0x61, 0x61, 0x41, 0x61, 0x62, 0x61, 0x42, 0x61, 0x63, 0x61, 0x43, 0x61, 0x64, 0x61, 0x44, 0x61, 0x65, 0x61, 0x45, 0xff])) :-
		generate({a-'A', b-'B', c-'C', d-'D', e-'E'}, Encoding).

	% text representation

	test(cbor_generate_2_atom, true(Encoding == [0x63, 0x61, 0x62, 0x63])) :-
		generate(abc, Encoding).

	test(cbor_generate_2_chars, true(Encoding == [0x63, 0x61, 0x62, 0x63])) :-
		generate(chars([a,b,c]), Encoding).

	test(cbor_generate_2_codes, true(Encoding == [0x63, 0x61, 0x62, 0x63])) :-
		generate(codes([97,98,99]), Encoding).

:- end_object.
