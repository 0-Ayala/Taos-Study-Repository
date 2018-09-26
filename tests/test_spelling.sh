#! /bin/bash
#!/usr/bin/env make -f

# OPENSOURCE FORK FROM:
# BASH Repo Template
# ..................................
# Copyright (c) 2017-2018, Kendrick Walls
# ..................................
# Licensed under MIT (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# ..........................................
# http://www.github.com/kendrick-walls-work/bash-repo/LICENSE.md
# ..........................................
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###################################
# Version 2018/09/19 TAOS EDIT
###################################

# exit fast if command is missing
test -x /usr/bin/spellintian || ( echo "SKIPPING TEST: Spellcheck: Missing spellintian" && exit 0 ) ;

THE_TEMP_FILE="/tmp/swapfile_spellcheck_${RANDOM}.tmp.txt" ;
( (spellintian "${@:-./**/*}" 2>/dev/null | grep -F -v "(duplicate word)" | grep -F " -> ") & (spellintian "${@:-./*}" 2>/dev/null | grep -F -v "(duplicate word)" | grep -F " -> ") & (spellintian "${@:-./**/**/*}"  2>/dev/null | grep -F -v "(duplicate word)" | grep -F " -> ") ) | sort -h | uniq | tee -a ${THE_TEMP_FILE:-/dev/null} ;
wait ;
THECOUNT=$( (wc -l ${THE_TEMP_FILE} 2>/dev/null || echo 0) | cut -d\  -f 1 ) ;
EXIT_CODE=${THECOUNT} ;
if [[ ("${THECOUNT}" -le 1) ]] ; then
	EXIT_CODE=0 ;
	echo "OK: Found no detected spelling errors." ;
else
	echo "FAIL: Found ${THECOUNT:-many} spelling errors." ;
fi
rm -f ${THE_TEMP_FILE} 2>/dev/null >> /dev/null || true ;
wait ;
exit ${EXIT_CODE:255} ;
