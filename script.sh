#!/bin/bash

# timer function
timer() {
    seconds=0
    while true; do
        printf "\r Time: %02d:%02d" $((seconds/60)) $((seconds%60))
        sleep 1
        ((seconds++))
    done
}

# input
echo "Enter difficulty level (800, 900, 1000):"
read diff

# input validation
if [[ "$diff" != "800" && "$diff" != "900" && "$diff" != "1000" ]]; then
    echo " Invalid input. Please enter 800, 900, or 1000."
    exit 1
fi

# random question
question=$(grep "^$diff;" questions.txt | sort -R | head -n 1 | cut -d';' -f2)

if [ -z "$question" ]; then
    echo "No question found for difficulty $diff"
    exit 1
fi

echo ""
echo " Your problem:"
echo "$question"
open "$question"

echo ""
echo "Start typing your answer "
echo "(Press ENTER on empty line to finish)"
echo ""

# start timer
start_time=$(date +%s)

timer &
TIMER_PID=$!

# nput
answer=""
while true; do
    read line
    if [ -z "$line" ]; then
        break
    fi
    answer="$answer $line"
done

# stop timer
kill $TIMER_PID 2>/dev/null
echo ""

# time csalc
end_time=$(date +%s)
time_taken=$((end_time - start_time))

# word count
word_count=$(echo "$answer" | wc -w)

#wpm
if [ "$time_taken" -gt 0 ]; then
    wpm=$((word_count * 60 / time_taken))
else
    wpm=0
fi

# output
echo ""
echo " Stats:"
echo "Time taken: $time_taken seconds"
echo "Total words: $word_count"
echo "Words per minute: $wpm"