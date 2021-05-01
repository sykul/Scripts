today="$(date +"%m/%d")"
yesterday="$(date +"%m/%d" -d "1 day ago")"
daybeforeyesterday="$(date +"%m/%d" -d "2 days ago")"
threedaysago="$(date +"%m/%d" -d "3 days ago")"

todaydata=$(grep -e "$(date --iso-8601)" owid-covid-data.csv | grep -e "United Kingdom" | cut -d "," -f "41")
yesterdaydata=$(grep -e "$(date --iso-8601 -d "1 day ago")" owid-covid-data.csv | grep -e "United Kingdom" | cut -d "," -f "41")
daybeforeyesterdaydata=$(grep -e "$(date --iso-8601 -d "2 days ago")" owid-covid-data.csv | grep -e "United Kingdom" | cut -d "," -f "41")
threedaysagodata=$(grep -e "$(date --iso-8601 -d "3 days ago")" owid-covid-data.csv | grep -e "United Kingdom" | cut -d "," -f "41")

if [ -n "$todaydata" ] 
then
        echo "$todaydata% as of $today"
        break
else
        if [ -n "$yesterdaydata" ]
	then
		echo "$yesterdaydata% as of $yesterday"
		break
	else
		if [ -n "$daybeforeyesterdaydata" ]
		then
			echo "$daybeforeyesterdaydata% as of $daybeforeyesterday"
			break
		else
			if [ -n "$threedaysagodata" ]
			then
				echo "$threedaysagodata% as of $threedaysago"
				break
			fi
		fi
	fi
fi
