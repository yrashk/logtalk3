#!/usr/bin/env bash

#############################################################################
## 
##   Set CLASSPATH environment variable for YAP
##   Last updated on March 16, 2023
## 
##   This file is part of Logtalk <https://logtalk.org/>  
##   SPDX-FileCopyrightText: 1998-2023 Paulo Moura <pmoura@logtalk.org>
##   
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##   
##       http://www.apache.org/licenses/LICENSE-2.0
##   
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
## 
#############################################################################


eval $(yap -dump-runtime-variables)
CLASSPATH="$YAP_ROOTDIR/share/Yap/jpl.jar"
NEO4J="$(neo4j --verbose status | grep 'basedir' | sed 's/.*-Dbasedir=\(.*\)].*/\1/')"

for jar in "$NEO4J"/lib/*.jar; do
	CLASSPATH="$jar":$CLASSPATH
done

export CLASSPATH
