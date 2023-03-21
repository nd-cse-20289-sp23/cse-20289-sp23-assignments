#!/bin/bash

WORKSPACE=/tmp/str.$(id -u)
FAILURES=0

input() {
    cat <<EOF

 
Through the woods
 Blank Space
Out of Style
I need a hero
 You Got A Friend in Me!!! 
Hello, World!
EOF
}

error() {
    echo "$@"
    [ -r $WORKSPACE/test ] && (echo; cat $WORKSPACE/test; echo)
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

export LD_LIBRARY_PATH=$LD_LIBRRARY_PATH:.

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

echo
echo "Testing str utility..."

printf " %-40s ... " "str -h"
if ! ./str-static -h |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -h (valgrind)"
valgrind --leak-check=full ./str-dynamic -h &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str"
input | ./str-static | diff -y - <(input) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str (valgrind)"
input | valgrind --leak-check=full ./str-dynamic &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str aeio 4310"
input | ./str-static aeio 4310 | diff -y - <(input | tr aeio 4310) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -s swift snake"
input | ./str-static -s swift snake | diff -y - <(input | tr swift snake | sed -E -e 's/^\s+//' -e 's/\s+$//') &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -s swift snake (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -s swift snake &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r blue gold"
input | ./str-static -r blue gold | diff -y - <(input | tr blue gold | rev) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r blue gold (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -r blue gold &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l aeio 4310"
input | ./str-static -l aeio 4310 | diff -y - <(input | tr aeio 4310 | tr A-Z a-z) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -l aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -u aeio 4310"
input | ./str-static -u aeio 4310 | diff -y - <(input | tr aeio 4310 | tr a-z A-Z) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -u aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -u aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -t aeio 4310"
input | ./str-static -t aeio 4310 | diff -y - <(input | tr aeio 4310 | python3 -c 'import sys;[print(line[:-1].title()) for line in sys.stdin]') &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -t aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -t aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -d aeio"
input | ./str-static -d aeio | diff -y - <(input | tr -d aeio) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -d aeio (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -d aeio &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -u aeio 4310"
input | ./str-static -l -u aeio 4310 | diff -y - <(input | tr aeio 4310 | tr a-z A-Z) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -u aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -l -u aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -s aeio 4310"
input | ./str-static -l -s aeio 4310 | diff -y - <(input | tr aeio 4310 | tr A-Z a-z | sed -E -e 's/^\s+//' -e 's/\s+$//') &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -s aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -l -s aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r -u aeio 4310"
input | ./str-static -r -u aeio 4310 | diff -y - <(input | tr aeio 4310 | tr a-z A-Z | rev) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -d gdbye"
input | ./str-static -l -d gdbye | diff -y - <(input | tr -d gdbye | tr A-Z a-z) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -l -d gdbye (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -l -d gdbye &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r -s -t aeio 4310"
input | ./str-static -r -s -t aeio 4310 | diff -y - <(input | tr aeio 4310 | python3 -c 'import sys;[print(line.strip()[::-1].title()) for line in sys.stdin]') &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r -s -t aeio 4310 (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -r -s -t aeio 4310 &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r -u -d mtan"
input | ./str-static -r -u -d mtan | diff -y - <(input | tr -d mtan | tr a-z A-Z | rev) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str -r -u -d mtan (valgrind)"
input | valgrind --leak-check=full ./str-dynamic -r -u -d mtan &> $WORKSPACE/test
if [ $? -ne 0 ] || [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 2))

echo
echo "   Score $(echo "scale=4; ($TESTS - $FAILURES) / $TESTS.0 * 3.0" | bc | awk '{printf "%0.2f\n", $1}') / 3.00"
printf "  Status "
if [ $FAILURES -gt 0 ]; then
    echo "Failure"
else
    echo "Success"
fi
echo
