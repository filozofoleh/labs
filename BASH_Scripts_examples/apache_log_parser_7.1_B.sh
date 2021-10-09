#!/bin/bash

# Field constants
IP=1
HTTP_CODE=9
BYTES=10

function showHelp() {
		cat << EOF
       

    apache.sh log parser usage

    ************************************************************************************

    [-n N] [-e <blacklist>] (-c|-s|-r|-f|-t|-m|-w|-k) <filename>
    -n: Limit the number of results to N.
    -c: IP addresses that makes the most number of connection attempts.
    -s: IP addresses that makes the most number of successful connection attempts.
    -w: Top requested pages.
    -m: Date when site get the most requests.
    -f: What are the most common result codes that indicate failure (no auth, not found etc) and where do they come from.
    -k: Display search bot (UA + IP).
    -e: Apply a DNS blacklist for the results.
    -r: Most common results codes and where do they come from.
    -t: Which IP number get the most bytes sent.
    <filename> refers to the logfile. If ’-’ is given as a filename, or no filename is given, then standard input should be read.




EOF
}


# $1 File
function getFileData() {
		cat $1
}

# $1 Fields wanted
function filterOutData() {
		cut -d' ' -f$1
}


# $1 The blacklist file
# $2 The column where the IP is
function filterBlacklist() {
		if [ $1 != "/dev/null" ]; then
				# This create an associative array
				declare -A blacklistLookup

				# Cache lookup between sessions
				# This exists as the 'dig' command is slow. (Unless you have a local DNS caching service)
				sessionFile="session-$(echo $1 | sha1sum | awk '{ print $1 }').cache"
				if [ -f "$sessionFile" ]; then
						source "$sessionFile"
				fi

				# Create a grep query to easier see if a DNS domain exist inside the blacklist.
				blackListCheckQuery=$(cat $1 | awk '{ printf "%s\\|", $1 }' | sed 's/\\|$//')
				while read line; do
						ip=$(echo $line | cut -d' ' "-f$2")

						# Get the value into the cache if it was not already in it!
						if [[ -z "${blacklistLookup[$ip]}" ]]; then
								dnsName=$(dig "+short" -x "$ip" | sed 's/\.$//')
								if [ "$dnsName" ]; then
										blacklistLookup[$ip]=$(echo $dnsName | grep $blackListCheckQuery >/dev/null && echo true || echo false)
								else
										blacklistLookup[$ip]="false"
								fi
						fi

						if [ ${blacklistLookup[$ip]} == "false" ]; then
							 echo $line
						fi
				done

				# Save DNS lookup between sessions
				declare -p blacklistLookup > "$sessionFile"
		else
				cat
		fi
}

# $1 Rows wanted
function limitOutput() {
		if [ $1 == -1 ]; then
				cat
		else
				head -n$1
		fi
}

file="-"
mode=help
resultLimit=-1
blacklist="/dev/null"

# Process the arguments
while getopts n:e:csrftwmk arg; do
		case $arg in
				n)
						resultLimit="$OPTARG"
				;;
				e)
						blacklist="$OPTARG"
				;;
				c) mode="c"	;;
				2) mode="s"	;;
				r) mode="r"	;;
				F) mode="f"	;;
				t) mode="t"	;;
                w) mode="w" ;;
                m) mode="m" ;;
                k) mode="k" ;;
				?)
				showHelp
				exit -2;;
		 esac
done

# Remove the processed arguments
shift $(($OPTIND - 1))

# Get the filename, incase it exist
if [ $1 ]; then
		file=$1
		shift 1
fi

# Too many arguments
if [ -z $# ]; then
		echo "TOO MANY ARGS $#: $*"
		#showHelp
		exit -1
fi

if [ $mode == "help" ]; then
		showHelp
		exit 0

elif [ $mode == "w" ]; then
		# What is the top 10 requested page?
printf "%-15s  %8s\n" "Requests" "Pages"
cat access.log |
awk -F\" ' { print $4 } ' | 
grep -v '-' |  
sort | uniq -c | # Count the repeated IPs
sort -rn | # Biggest number first
limitOutput $resultLimit  # Limit the output according to -n <number>
exit=1


elif [ $mode == "m" ]; then
		# time?
printf "%-15s  %8s\n" "Requests" "Date"
cat access.log |
awk ' { print $4 } ' | 
sort | uniq -c | # Count the repeated IPs
sort -rn | # Biggest number first
limitOutput $resultLimit  # Limit the output according to -n <number>
exit=1

elif [ $mode == "k" ]; then
		# Display search bots
printf "%-15s  %8s\n" "UA" "IP"
cat access.log |
grep 'bot' |
awk ' { print $14, $1 } ' | 
sort | uniq -c | # Count the repeated IPs
sort -rn | # Biggest number first
limitOutput $resultLimit  # Limit the output according to -n <number>
exit=1




elif [ $mode == "c" ]; then
		# From which ip were the most requests?
		# Output: xxx.xxx.xxx.xxx yyy, where yyy is the number of connection attempts

		printf "%-15s  %8s\n" "IP" "Attempts"
		getFileData $file | filterOutData "$IP" | # Get only IP
				sort | uniq -c | # Count the repeated IPs
				filterBlacklist $blacklist 2 | # Filter out entries base on the blacklist
				sort -nr | # Biggest number first
				limitOutput $resultLimit | # Limit the output according to -n <number>
				awk '{ printf "%-15s  %8s\n", $2, $1}' # Format the output
                exit=1
elif [ $mode == "s" ]; then
		# Task: Which address makes the most number of successful attempts?
		# Output: xxx.xxx.xxx.xxx yyy, where yyy is the number of successful attempts

		printf "%-15s  %8s\n" "IP" "Attempts"
		getFileData $file | filterOutData "$IP,$HTTP_CODE" | # Get both IP and http code
				grep " [123][0-9]\{2\}" | # Get only http status codes that are inside of 1xx, 2xx and 3xx
				cut -d' ' -f1 | # Remove the http code
				sort | uniq -c | # Count the repeated IPs
				filterBlacklist $blacklist 2 | # Filter out entries base on the blacklist
				sort -nr | # Biggest number first
				limitOutput $resultLimit | # Limit the output according to -n <number>
				awk '{ printf "%-15s  %8s\n", $2, $1 }' # Format the output
                exit=1
elif [ $mode == "r" ]; then
		# Task: What are the most common results codes and where do they come from?
		#   You are allowed to output multiple lines with the same result code or count, but groups must be sorted
		#   There should still only be one ip address per line.
		# Output: yyyy xxx.xxx.xxx.xxx, where yyy is the result code, one ip per line

		printf "%4s  %-15s  %5s\n" "Code" "IP" "Count"
		getFileData $file | filterOutData "$IP,$HTTP_CODE" | # Get both IP and http code
				awk '{ print $2, $1 }' | # Flip IP and HTTP Code location
				sort | uniq -c -f 1 | # Count and uniq by IPs
				filterBlacklist $blacklist 3 | # Filter out entries base on the blacklist
				sort -k2,2n -k1,1rn | # Sort by http code and then by count
				limitOutput $resultLimit | # Limit the output according to -n <number>
				awk '{ printf "%4s  %-15s  %5s\n", $2, $3, $1 }' # Format the output
                exit=1
elif [ $mode == "f" ]; then
		# Task: What are the most common result codes that indicate failure (no auth, not found etc) and where do they come from?
		# Output: yyyy xxx.xxx.xxx.xxx, where yyy is the result code indicating failure, one ip per line
        # What non-existent pages were clients referred to?

		printf "%4s  %-15s  %5s\n" "Code" "IP" "Count"
		getFileData $file | filterOutData "$IP,$HTTP_CODE" | # Get both IP and http code
				grep " [45][0-9]\{2\}" | # Get only entries that have status code 4xx or 5xx
				awk '{ print $2, $1 }' | # Flip IP and HTTP Code location
				sort | uniq -c -f 1 | # Count and uniq by IPs
				filterBlacklist $blacklist 3 | # Filter out entries base on the blacklist
				sort -k2,2n -k1,1rn | # Sort by http code and then by count
				limitOutput $resultLimit | # Limit the output according to -n <number>
				awk '{ printf "%4s  %-15s  %5s\n", $2, $3, $1 }' # Format the output
                exit=1
elif [ $mode == "t" ]; then
		# Task: Which IP number get the most bytes sent to them?
		# Output: xxx.xxx.xxx.xxx yyy, where yyy is the number of bytes sent from the server

		printf "%-15s  %10s\n" "IP" "Bytes"
		getFileData $file | filterOutData "$IP,$BYTES" | # Get both IP and totaly bytes sent
				grep -v -- - | # Remove log entries that don't have a size (where size is '-')
				filterBlacklist $blacklist 1 | # Filter out entries base on the blacklist
				awk '
						{
								byteSum[$1] += $2
						}
						END {
								for (ip in byteSum)
										printf "%-15s  %10s\n", ip, byteSum[ip]
						}' |
				# The first awk block will add the bytes sent to the map entry for that IP
				# The END awk block will pretty print each entry inside the map
				# I hope this does not count as "Major processing"
				sort -k2,2rn | # Sort by the bytes sent
				limitOutput $resultLimit # Limit the output according to -n <number>
else
		showHelp
		exit -1
fi
