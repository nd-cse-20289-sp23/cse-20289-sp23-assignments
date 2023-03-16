#!/bin/bash

SCRIPT=${1:-hulk.py}
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

error() {
    echo "$@"
    [ -s $WORKSPACE/test ] && (echo ; cat $WORKSPACE/test; echo; rm $WORKSPACE/test)
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Unit Tests"
./hulk_test.py -v &> $WORKSPACE/test
TOTAL=$(grep 'Ran.*tests' $WORKSPACE/test | awk '{print $2}')
PASSED=$(grep -c '... ok' $WORKSPACE/test)
UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 2.0" | bc)
echo "$UNITS / 2.00"

printf "   %-40s ... " "Usage"
if ! ./hulk.py -h 2>&1 | grep -q -i usage > /dev/null; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 25 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (ALPHABET: abc)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -a abc > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 3 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 92 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (ALPHABET: pbui)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -a pbui > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 4 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 572 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (ALPHABET: abc)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -a abc > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 7 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4"
timeout 5 ./$SCRIPT -s hashes.txt -l 4 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 1027 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4 (ALPHABET: kfriday)"
timeout 5 ./$SCRIPT -s hashes.txt -l 4 -a kfriday > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 16 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (CORES: 2)"
timeout 1 strace -e clone ./$SCRIPT -s hashes.txt -l 2 -c 2 &> $WORKSPACE/test
if [ $? -ne 0 -o $(grep -Ec CLONE_CHILD $WORKSPACE/test) -lt 2 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (CORES: 3)"
timeout 1 strace -e clone ./$SCRIPT -s hashes.txt -l 3 -c 3 &> $WORKSPACE/test
if [ $? -ne 0 -o $(grep -Ec CLONE_CHILD $WORKSPACE/test) -lt 3 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4 (CORES: 4)"
timeout 1 strace -e clone ./$SCRIPT -s hashes.txt -l 4 -c 4 &> $WORKSPACE/test
if [ $? -ne 0 -o $(grep -Ec CLONE_CHILD $WORKSPACE/test) -lt 4 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 5 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (PREFIX: a, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 5 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 53 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (PREFIX: a, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 53 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 75 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (PREFIX: a, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 75 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 2))

echo
echo "   Score $(echo "scale=4; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 8.0" | bc | awk '{printf "%0.2f\n", $1}') / 10.00"
printf "  Status "
if [ $UNITS != "2.00" -o $FAILURES -gt 0 ]; then
    FAILURES=1
    echo "Failure"
else
    echo "Success"
fi
echo
