/* ***** BEGIN LICENSE BLOCK *****
 * Distributed under the BSD license:
 *
 * Copyright (c) 2012, Ajax.org B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Ajax.org B.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***** END LICENSE BLOCK ***** */

/* THIS FILE WAS AUTOGENERATED FROM Logtalk.tmLanguage (UUID: C11FA1F2-6EDB-11D9-8798-000A95DAA580) */
/****************************************************************
 * IT MIGHT NOT BE PERFECT, PARTICULARLY:                       *
 * IN DECIDING STATES TO TRANSITION TO,                         *
 * IGNORING WHITESPACE,                                         *
 * IGNORING GROUPS WITH ?:,                                     *
 * EXTENDING EXISTING MODES,                                    *
 * GATHERING KEYWORDS, OR                                       *
 * DECIDING WHEN TO USE PUSH.                                   *
 * ...But it's a good start from an existing *.tmlanguage file. *
 ****************************************************************/

define(function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;

var LogtalkHighlightRules = function() {
    // regexp must not have capturing parentheses. Use (?:) instead.
    // regexps are ordered -> the first match is used

    this.$rules = { start: 
       [ { token: 'punctuation.definition.comment.logtalk',
           regex: '/\\*',
           push: 
            [ { token: 'punctuation.definition.comment.logtalk',
                regex: '\\*/',
                next: 'pop' },
              { defaultToken: 'comment.block.logtalk' } ] },
         { todo: 'fix grouping',
           token: 
            [ 'comment.line.percentage.logtalk',
              'punctuation.definition.comment.logtalk' ],
           regex: '%.*$\\n?' },
         { todo: 'fix grouping',
           token: 
            [ 'storage.type.opening.logtalk',
              'punctuation.definition.storage.type.logtalk' ],
           regex: ':-\\s(?:object|protocol|category|module)(?=[(])' },
         { todo: 'fix grouping',
           token: 
            [ 'storage.type.closing.logtalk',
              'punctuation.definition.storage.type.logtalk' ],
           regex: ':-\\send_(?:object|protocol|category)(?=[.])' },
         { caseInsensitive: false,
           token: 'storage.type.relations.logtalk',
           regex: '\\b(?:complements|extends|i(?:nstantiates|mp(?:orts|lements))|specializes)(?=[(])' },
         { caseInsensitive: false,
           todo: 'fix grouping',
           token: 
            [ 'storage.modifier.others.logtalk',
              'punctuation.definition.storage.modifier.logtalk' ],
           regex: ':-\\s(?:e(?:lse|ndif)|built_in|dynamic|synchronized|threaded)(?=[.])' },
         { caseInsensitive: false,
           todo: 'fix grouping',
           token: 
            [ 'storage.modifier.others.logtalk',
              'punctuation.definition.storage.modifier.logtalk' ],
           regex: ':-\\s(?:c(?:alls|oinductive)|e(?:lif|n(?:coding|sure_loaded)|xport)|i(?:f|n(?:clude|itialization|fo))|reexport|set_(?:logtalk|prolog)_flag|uses)(?=[(])' },
         { caseInsensitive: false,
           todo: 'fix grouping',
           token: 
            [ 'storage.modifier.others.logtalk',
              'punctuation.definition.storage.modifier.logtalk' ],
           regex: ':-\\s(?:alias|info|d(?:ynamic|iscontiguous)|m(?:eta_(?:non_terminal|predicate)|ode|ultifile)|p(?:ublic|r(?:otected|ivate))|op|use(?:s|_module)|synchronized)(?=[(])' },
         { token: 'keyword.operator.message-sending.logtalk',
           regex: '(:|::|\\^\\^)' },
         { token: 'keyword.operator.external-call.logtalk',
           regex: '([{}])' },
         { token: 'keyword.operator.mode.logtalk', regex: '(\\?|@)' },
         { token: 'keyword.operator.comparison.term.logtalk',
           regex: '(@=<|@<|@>|@>=|==|\\\\==)' },
         { token: 'keyword.operator.comparison.arithmetic.logtalk',
           regex: '(=<|<|>|>=|=:=|=\\\\=)' },
         { token: 'keyword.operator.bitwise.logtalk',
           regex: '(<<|>>|/\\\\|\\\\/|\\\\)' },
         { token: 'keyword.operator.evaluable.logtalk',
           regex: '\\b(?:e|pi|div|mod|rem)\\b(?![-!(^~])' },
         { token: 'keyword.operator.evaluable.logtalk',
           regex: '(\\*\\*|\\+|-|\\*|/|//)' },
         { token: 'keyword.operator.misc.logtalk',
           regex: '(:-|!|\\\\+|,|;|-->|->|=|\\=|\\.|=\\.\\.|\\^|\\bas\\b|\\bis\\b)' },
         { caseInsensitive: false,
           token: 'support.function.evaluable.logtalk',
           regex: '\\b(a(bs|cos|sin|tan|tan2)|c(eiling|os)|div|exp|flo(at(_(integer|fractional)_part)?|or)|log|m(ax|in|od)|r(em|ound)|s(i(n|gn)|qrt)|t(an|runcate)|xor)(?=[(])' },
         { token: 'support.function.control.logtalk',
           regex: '\\b(?:true|fa(?:il|lse)|repeat)\\b(?![-!(^~])' },
         { token: 'support.function.control.logtalk',
           regex: '\\b(?:ca(?:ll|tch)|ignore|throw|once)(?=[(])' },
         { token: 'support.function.chars-and-bytes-io.logtalk',
           regex: '\\b(?:(?:get|p(?:eek|ut))_(c(?:har|ode)|byte)|nl)(?=[(])' },
         { token: 'support.function.chars-and-bytes-io.logtalk',
           regex: '\\bnl\\b' },
         { token: 'support.function.atom-term-processing.logtalk',
           regex: '\\b(?:atom_(?:length|c(?:hars|o(?:ncat|des)))|sub_atom|char_code|number_c(?:har|ode)s)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.term-testing.logtalk',
           regex: '\\b(?:var|atom(ic)?|integer|float|c(?:allable|ompound)|n(?:onvar|umber)|ground|acyclic_term)(?=[(])' },
         { token: 'support.function.term-comparison.logtalk',
           regex: '\\b(compare)(?=[(])' },
         { token: 'support.function.term-io.logtalk',
           regex: '\\b(?:read(_term)?|write(?:q|_(?:canonical|term))?|(current_)?(?:char_conversion|op))(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.term-creation-and-decomposition.logtalk',
           regex: '\\b(arg|copy_term|functor|numbervars|term_variables)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.term-unification.logtalk',
           regex: '\\b(subsumes_term|unify_with_occurs_check)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.stream-selection-and-control.logtalk',
           regex: '\\b(?:(?:se|curren)t_(?:in|out)put|open|close|flush_output|stream_property|at_end_of_stream|set_stream_position)(?=[(])' },
         { token: 'support.function.stream-selection-and-control.logtalk',
           regex: '\\b(?:flush_output|at_end_of_stream)\\b' },
         { token: 'support.function.prolog-flags.logtalk',
           regex: '\\b((?:se|curren)t_prolog_flag)(?=[(])' },
         { token: 'support.function.compiling-and-loading.logtalk',
           regex: '\\b(logtalk_(?:compile|l(?:ibrary_path|oad|oad_context)|make))(?=[(])' },
         { token: 'support.function.compiling-and-loading.logtalk',
           regex: '\\b(logtalk_make)\\b' },
         { caseInsensitive: false,
           token: 'support.function.event-handling.logtalk',
           regex: '\\b(?:(?:abolish|define)_events|current_event)(?=[(])' },
         { token: 'support.function.implementation-defined-hooks.logtalk',
           regex: '\\b(?:(?:create|current|set)_logtalk_flag|halt)(?=[(])' },
         { token: 'support.function.implementation-defined-hooks.logtalk',
           regex: '\\b(halt)\\b' },
         { token: 'support.function.sorting.logtalk',
           regex: '\\b((key)?(sort))(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.entity-creation-and-abolishing.logtalk',
           regex: '\\b((c(?:reate|urrent)|abolish)_(?:object|protocol|category))(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.reflection.logtalk',
           regex: '\\b((object|protocol|category)_property|co(mplements_object|nforms_to_protocol)|extends_(object|protocol|category)|imp(orts_category|lements_protocol)|(instantiat|specializ)es_class)(?=[(])' },
         { token: 'support.function.logtalk',
           regex: '\\b((?:for|retract)all)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.execution-context.logtalk',
           regex: '\\b(?:parameter|se(?:lf|nder)|this)(?=[(])' },
         { token: 'support.function.database.logtalk',
           regex: '\\b(?:a(?:bolish|ssert(?:a|z))|clause|retract(all)?)(?=[(])' },
         { token: 'support.function.all-solutions.logtalk',
           regex: '\\b((?:bag|set)of|f(?:ind|or)all)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.multi-threading.logtalk',
           regex: '\\b(threaded(_(call|once|ignore|exit|peek|wait|notify))?)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.engines.logtalk',
           regex: '\\b(threaded_engine(_(create|destroy|self|next|yield|post|fetch))?)(?=[(])' },
         { caseInsensitive: false,
           token: 'support.function.reflection.logtalk',
           regex: '\\b(?:current_predicate|predicate_property)(?=[(])' },
         { token: 'support.function.event-handler.logtalk',
           regex: '\\b(?:before|after)(?=[(])' },
         { token: 'support.function.message-forwarding-handler.logtalk',
           regex: '\\b(forward)(?=[(])' },
         { token: 'support.function.grammar-rule.logtalk',
           regex: '\\b(?:expand_(?:goal|term)|(?:goal|term)_expansion|phrase)(?=[(])' },
         { token: 'punctuation.definition.string.begin.logtalk',
           regex: '\'',
           push: 
            [ { token: 'constant.character.escape.logtalk',
                regex: '\\\\([\\\\abfnrtv"\']|(x[a-fA-F0-9]+|[0-7]+)\\\\)' },
              { token: 'punctuation.definition.string.end.logtalk',
                regex: '\'',
                next: 'pop' },
              { defaultToken: 'string.quoted.single.logtalk' } ] },
         { token: 'punctuation.definition.string.begin.logtalk',
           regex: '"',
           push: 
            [ { token: 'constant.character.escape.logtalk', regex: '\\\\.' },
              { token: 'punctuation.definition.string.end.logtalk',
                regex: '"',
                next: 'pop' },
              { defaultToken: 'string.quoted.double.logtalk' } ] },
         { token: 'constant.numeric.logtalk',
           regex: '\\b(0b[0-1]+|0o[0-7]+|0x\\h+)\\b' },
         { token: 'constant.numeric.logtalk',
           regex: '\\b(0\'.|0\'\'|0\'")' },
         { token: 'constant.numeric.logtalk',
           regex: '\\b(\\d+\\.?\\d*((e|E)(\\+|-)?\\d+)?)\\b' },
         { token: 'variable.other.logtalk',
           regex: '\\b([A-Z_][A-Za-z0-9_]*)\\b' } ] }
    
    this.normalizeRules();
};

oop.inherits(LogtalkHighlightRules, TextHighlightRules);

exports.LogtalkHighlightRules = LogtalkHighlightRules;
});