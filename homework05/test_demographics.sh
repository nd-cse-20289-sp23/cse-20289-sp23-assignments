#!/bin/bash

# Configuration

SCRIPT=demographics.py
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

# Functions

error() {
    echo "$@"
    [ -r $WORKSPACE/log ] && cat $WORKSPACE/log
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

default_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023    2024    2025
================================================================================================================
   M      49      44      58      60      65     101      96      92      89     124     114     120     105
   F      14      12      16      19      26      45      54      43      46      41      52      57      39
----------------------------------------------------------------------------------------------------------------
   B       3       2       4       1       5       3       3       4       6       4       2       4       7
   C      43      43      47      53      60     107      96      92      87     106      98     110      82
   N       1       1       1       7       5       5      13      14      13      14      16      11      12
   O       7       5       9       9      12      10      13       7       8      14      11      22      13
   S       7       4      10       9       3      13      10      10      11      17      26      19      18
   T       2       1       1       0       6       8      15       7       9       8      11       7       8
   U       0       0       2       0       0       0       0       1       1       1       2       4       4
----------------------------------------------------------------------------------------------------------------
EOF
}

default_y2013_output() {
    cat <<EOF
        2013
================
   M      49
   F      14
----------------
   B       3
   C      43
   N       1
   O       7
   S       7
   T       2
   U       0
----------------
EOF
}

default_y2025_output() {
    cat <<EOF
        2025
================
   M     105
   F      39
----------------
   B       7
   C      82
   N      12
   O      13
   S      18
   T       8
   U       4
----------------
EOF
}

default_y2019_2021_2023_2025_output() {
    cat <<EOF
        2019    2021    2023    2025
========================================
   M      96      89     114     105
   F      54      46      52      39
----------------------------------------
   B       3       6       2       7
   C      96      87      98      82
   N      13      13      16      12
   O      13       8      11      13
   S      10      11      26      18
   T      15       9      11       8
   U       0       1       2       4
----------------------------------------
EOF
}

default_p_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023    2024    2025
================================================================================================================
   M   77.8%   78.6%   78.4%   75.9%   71.4%   69.2%   64.0%   68.1%   65.9%   75.2%   68.7%   67.8%   72.9%
   F   22.2%   21.4%   21.6%   24.1%   28.6%   30.8%   36.0%   31.9%   34.1%   24.8%   31.3%   32.2%   27.1%
----------------------------------------------------------------------------------------------------------------
   B    4.8%    3.6%    5.4%    1.3%    5.5%    2.1%    2.0%    3.0%    4.4%    2.4%    1.2%    2.3%    4.9%
   C   68.3%   76.8%   63.5%   67.1%   65.9%   73.3%   64.0%   68.1%   64.4%   64.2%   59.0%   62.1%   56.9%
   N    1.6%    1.8%    1.4%    8.9%    5.5%    3.4%    8.7%   10.4%    9.6%    8.5%    9.6%    6.2%    8.3%
   O   11.1%    8.9%   12.2%   11.4%   13.2%    6.8%    8.7%    5.2%    5.9%    8.5%    6.6%   12.4%    9.0%
   S   11.1%    7.1%   13.5%   11.4%    3.3%    8.9%    6.7%    7.4%    8.1%   10.3%   15.7%   10.7%   12.5%
   T    3.2%    1.8%    1.4%    0.0%    6.6%    5.5%   10.0%    5.2%    6.7%    4.8%    6.6%    4.0%    5.6%
   U    0.0%    0.0%    2.7%    0.0%    0.0%    0.0%    0.0%    0.7%    0.7%    0.6%    1.2%    2.3%    2.8%
----------------------------------------------------------------------------------------------------------------
EOF
}

default_G_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023    2024    2025
================================================================================================================
   B       3       2       4       1       5       3       3       4       6       4       2       4       7
   C      43      43      47      53      60     107      96      92      87     106      98     110      82
   N       1       1       1       7       5       5      13      14      13      14      16      11      12
   O       7       5       9       9      12      10      13       7       8      14      11      22      13
   S       7       4      10       9       3      13      10      10      11      17      26      19      18
   T       2       1       1       0       6       8      15       7       9       8      11       7       8
   U       0       0       2       0       0       0       0       1       1       1       2       4       4
----------------------------------------------------------------------------------------------------------------
EOF
}

default_E_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023    2024    2025
================================================================================================================
   M      49      44      58      60      65     101      96      92      89     124     114     120     105
   F      14      12      16      19      26      45      54      43      46      41      52      57      39
----------------------------------------------------------------------------------------------------------------
EOF
}

equality_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019
================================================================
   M       1       1       1       1       1       1       1
   F       1       1       1       1       1       1       1
----------------------------------------------------------------
   B       2       0       0       0       0       0       0
   C       0       2       0       0       0       0       0
   N       0       0       2       0       0       0       0
   O       0       0       0       2       0       0       0
   S       0       0       0       0       2       0       0
   T       0       0       0       0       0       2       0
   U       0       0       0       0       0       0       2
----------------------------------------------------------------
EOF
}

equality_y2016_p_output() {
    cat <<EOF
        2016
================
   M   50.0%
   F   50.0%
----------------
   B    0.0%
   C    0.0%
   N    0.0%
   O  100.0%
   S    0.0%
   T    0.0%
   U    0.0%
----------------
EOF
}

equality_y2016_p_E_output() {
    cat <<EOF
        2016
================
   M   50.0%
   F   50.0%
----------------
EOF
}

equality_y2016_p_E_G_output() {
    cat <<EOF
        2016
================
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Doctests"
grep -q '>>> load_demo_data' $SCRIPT
if [ $? -ne 0 ]; then
    UNITS=0
    echo "MISSING"
else
    python3 -m doctest -v $SCRIPT 2> /dev/null > $WORKSPACE/test
    TOTAL=$(grep 'tests.*items' $WORKSPACE/test | awk '{print $1}')
    PASSED=$(grep 'passed.*failed' $WORKSPACE/test | awk '{print $1}')
    UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 1.0" | bc)
    echo "$UNITS / 1.00"
fi

printf "   %-40s ... " "Bad arguments"
./$SCRIPT -bad &> /dev/null
if [ $? -eq 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "-h"
./$SCRIPT -h 2>&1 | grep -i usage &> /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "No arguments"
diff -W 220 -y <(./$SCRIPT) <(default_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad"
diff -W 220 -y <(./$SCRIPT https://yld.me/raw/e2Ad) <(default_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -y 2013"
diff -W 220 -y <(./$SCRIPT -y 2013) <(default_y2013_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -y 2025"
diff -W 220 -y <(./$SCRIPT -y 2025) <(default_y2025_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -y 2019,2023,2021,2025"
diff -W 220 -y <(./$SCRIPT -y 2019,2023,2021,2025) <(default_y2019_2021_2023_2025_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -p"
diff -W 220 -y <(./$SCRIPT -p) <(default_p_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -G"
diff -W 220 -y <(./$SCRIPT -G) <(default_G_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "e2Ad -E"
diff -W 220 -y <(./$SCRIPT -E) <(default_E_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG"
diff -W 220 -y <(./$SCRIPT https://yld.me/raw/ilG) <(equality_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p"
diff -W 220 -y <(./$SCRIPT -y 2016 -p https://yld.me/raw/ilG) <(equality_y2016_p_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p -E"
diff -W 220 -y <(./$SCRIPT -y 2016 -p -E https://yld.me/raw/ilG) <(equality_y2016_p_E_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p -E -G"
diff -W 220 -y <(./$SCRIPT -y 2016 -p -E -G https://yld.me/raw/ilG) <(equality_y2016_p_E_G_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

TESTS=$(($(grep -c Success $0) - 2))

echo
echo "   Score $(echo "scale=4; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 5.0" | bc | awk '{printf "%0.2f\n", $1}') / 6.00"
printf "  Status "

if [ $UNITS != "1.00" -o $FAILURES -gt 0 ]; then
    FAILURES=1
    echo "Failure"
else
    echo "Success"
fi
echo
