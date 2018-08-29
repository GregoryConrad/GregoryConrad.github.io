#!/bin/bash
#Multiplication Table Generator

#################
# By: Flare Cat #
#################

#This is open-source, but I would appreciate credit for it if you plan to distribute it. All this code is original.

#Functions:
function howManyDigits #Checks to see how many digits the given number has.
{
tempAmountOfDigits=1
input=$1
while [ $input -ge 10 ]
do
let "input=$input/10"
let "tempAmountOfDigits=$tempAmountOfDigits+1"
done
}
function numberAndFillerGenerator
{
let "currentNumber=$1*$2"
howManyDigits $currentNumber
let "amountOfFiller=$totalDigits-$tempAmountOfDigits"
}
function dividerLineGenerator #Generates the lines to divide the numbers.
{
lengthOfCurrentRow=1
while [ $lengthOfCurrentRow -lt $totalWidth ]
do
echo -n "+"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
dividerCounter=0
while [ $dividerCounter -lt $totalDigits ]
do
echo -n "-"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
let "dividerCounter=$dividerCounter+1"
done
done
echo "+"
lengthOfCurrentRow=0
}
function startOfLineGenerator #Generates the start of each line, otherwise, bugs would occur.
{
echo -n "|"
echo -n $y
howManyDigits $y
let "amountOfFiller=$totalDigits-$tempAmountOfDigits"
fillerPrinter #Calls the function.
tempCounter=0
let "lengthOfCurrentRow=2+$totalDigits"
echo -n "|"
}
function fillerPrinter #Prints out the filler in a segment.
{
tempCounter=0
while [ $amountOfFiller -gt $tempCounter ]
do
echo -n " "
let "tempCounter=$tempCounter+1"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
done
}
function numberCheck #Checks to see if entered values are numbers.
{
check="$(echo $1 | sed -e 's/[^0123456789]//g')"
if [ "$check" != "$1" ]
then
return 1
else
return 0
fi
}
function heightPrompt
{
echo -n "Please enter height: "
read height
if ! numberCheck "$height"
then
echo "Invalid height input. Please only enter in a positive number."
heightAgain=1
else heightAgain=0
fi
}
function widthPrompt
{
echo -n "Please enter width: "
read width
if ! numberCheck "$width"
then
echo "Invalid width input. Please only enter in a positive number."
widthAgain=1
else widthAgain=0
fi
}
function nonTerminalStart
{
echo "Multiplication Table Generator"
echo "By: Flare Cat"
echo "Please note that height and width have to be at least 0."
heightPrompt #Calls the function
while [ $heightAgain -gt 0 ] #Asks again for input if entered value is invalid.
do
heightPrompt #Calls the function
done
widthPrompt #Calls the function
while [ $widthAgain -gt 0 ] #Asks again for input if entered value is invalid.
do
widthPrompt #Calls the function
done
}

#Checks the method of start: (Has not been bug checked extensively. You might encounter an error in starting the new way.)
if numberCheck $1
then
if numberCheck $2
then
height=$1
width=$2
fi
fi
check="$(echo $1 | sed 's/[^]//g')"
if [ "$check" == "$1" ]
then
clear
nonTerminalStart
fi

#Start of the main script:
clear
let "total=$height*$width"
howManyDigits $total
totalDigits=$tempAmountOfDigits
let "totalWidth=3+2*$totalDigits+$width*($totalDigits+1)"
let "totalHeight=$height*2+5"
#Part of main script, this next part generates the first 2 lines, because there is the space of "nothing" in the first line of numbers.
dividerLineGenerator #Calls the function.
echo -n "|"
tempCounter=0
while [ $tempCounter -lt $totalDigits ]
do
echo -n " "
let "tempCounter=$tempCounter+1"
done
echo -n "|"
let "lengthOfCurrentRow=$lengthOfCurrentRow+2+totalDigits"
x=0
while [ $totalWidth -gt $lengthOfCurrentRow ]
do
echo -n $x
tempCounter=0
howManyDigits $x
let "lengthOfCurrentRow=$lengthOfCurrentRow+$tempAmountOfDigits"
let "amountOfFiller=$totalDigits-$tempAmountOfDigits"
while [ $amountOfFiller -gt $tempCounter ]
do
echo -n " "
let "tempCounter=$tempCounter+1"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
done
echo -n "|"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
let "x=$x+1"
done
echo ""
amountOfRows=2
whichRow=0
y=0
while [ $amountOfRows -lt $totalHeight ] #This is the second part of line printing
do
if [ $whichRow -eq 0 ]
then
dividerLineGenerator #Calls the function.
whichRow=1 #Makes it so that the next type of row will be printed out
else
startOfLineGenerator #Calls the function
x=0
while [ $lengthOfCurrentRow -lt $totalWidth ]
do
let "currentNumber=$x*$y" #This generates the number printed in the segments
howManyDigits $currentNumber #Calls the function, to figure out how many digits the current number has
let "amountOfFiller=$totalDigits-$tempAmountOfDigits"
echo -n $currentNumber
tempCounter=0
while [ $tempCounter -lt $amountOfFiller ]
do
echo -n " "
let "tempCounter=$tempCounter+1"
done
let "lengthOfCurrentRow=$lengthOfCurrentRow+$totalDigits"
echo -n "|"
let "lengthOfCurrentRow=$lengthOfCurrentRow+1"
let "x=$x+1"
done
let "y=$y+1"
whichRow=0 #Makes it so that the next type of row will be printed out
echo ""
fi
let "amountOfRows=$amountOfRows+1"
done