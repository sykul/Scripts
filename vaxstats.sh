datafile=$(ls -l --time-style=+"%Y-%m-%d" /tmp/ | grep "$(date --iso-8601)" | grep "data?areaType=overview&metric=cumPeopleVaccinatedCompleteByPublishDate&metric=cumPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedCompleteByPublishDate&format=csv" | cut -d " " -f "15")

today="$(date +"%m/%d")"
yesterday="$(date +"%m/%d" -d "1 day ago")"
daybeforeyesterday="$(date +"%m/%d" -d "2 days ago")"
threedaysago="$(date +"%m/%d" -d "3 days ago")"

# Checks whether today's data file exists in your /tmp directory. If not, downloads it to /tmp.
if [ -z "$datafile" ]
then
	notify-send "Downloading vaccination data." "Please hold."
	wget -q -P /tmp/ "https://api.coronavirus.data.gov.uk/v2/data?areaType=overview&metric=cumPeopleVaccinatedCompleteByPublishDate&metric=cumPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedCompleteByPublishDate&format=csv"
	datafile=$(ls -l --time-style=+"%Y-%m-%d" /tmp/ | grep "$(date --iso-8601)" | grep "data?areaType=overview&metric=cumPeopleVaccinatedCompleteByPublishDate&metric=cumPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedCompleteByPublishDate&format=csv" | cut -d " " -f "15")
fi

# Sets variables extracted from the data file. I might move these to the if loop later.
todaycumcomplete=$(grep -e "$(date --iso-8601)" "/tmp/$datafile" | cut -d "," -f "5")
yesterdaycumcomplete=$(grep -e "$(date --iso-8601 -d "1 day ago")" "/tmp/$datafile" | cut -d "," -f "5")
daybeforeyesterdaycumcomplete=$(grep -e "$(date --iso-8601 -d "2 days ago")" "/tmp/$datafile" | cut -d "," -f "5")
threedaysagocumcomplete=$(grep -e "$(date --iso-8601 -d "3 days ago")" "/tmp/$datafile" | cut -d "," -f "5")

todaycumfirstdose=$(grep -e "$(date --iso-8601)" "/tmp/$datafile" | cut -d "," -f "6")
yesterdaycumfirstdose=$(grep -e "$(date --iso-8601 -d "1 day ago")" "/tmp/$datafile" | cut -d "," -f "6")
daybeforeyesterdaycumfirstdose=$(grep -e "$(date --iso-8601 -d "2 days ago")" "/tmp/$datafile" | cut -d "," -f "6")
threedaysagocumfirstdose=$(grep -e "$(date --iso-8601 -d "3 days ago")" "/tmp/$datafile" | cut -d "," -f "6")

todaynewcomplete=$(grep -e "$(date --iso-8601)" "/tmp/$datafile" | cut -d "," -f "7")
yesterdaynewcomplete=$(grep -e "$(date --iso-8601 -d "1 day ago")" "/tmp/$datafile" | cut -d "," -f "7")
daybeforeyesterdaynewcomplete=$(grep -e "$(date --iso-8601 -d "2 days ago")" "/tmp/$datafile" | cut -d "," -f "7")
threedaysagonewcomplete=$(grep -e "$(date --iso-8601 -d "3 days ago")" "/tmp/$datafile" | cut -d "," -f "7")

todaynewfirstdose=$(grep -e "$(date --iso-8601)" "/tmp/$datafile" | cut -d "," -f "8")
yesterdaynewfirstdose=$(grep -e "$(date --iso-8601 -d "1 day ago")" "/tmp/$datafile" | cut -d "," -f "8")
daybeforeyesterdaynewfirstdose=$(grep -e "$(date --iso-8601 -d "2 days ago")" "/tmp/$datafile" | cut -d "," -f "8")
threedaysagonewfirstdose=$(grep -e "$(date --iso-8601 -d "3 days ago")" "/tmp/$datafile" | cut -d "," -f "8")

# Calculates and outputs percentages. Attempts to get the most recent data available.
if [ -n "$todaycumcomplete" ] 
then
	todaypercentcumcomplete=$(echo "$todaycumcomplete/68171922*100" | bc -l | cut -c -5)
	todaypercentcumfirstdose=$(echo "$todaycumfirstdose/68171922*100" | bc -l | cut -c -5)
	todaypercentnewcomplete=$(echo "$todaynewcomplete/68171922*100" | bc -l | cut -c -5)
	todaypercentnewfirstdose=$(echo "$todaynewfirstdose/68171922*100" | bc -l | cut -c -5)
        echo "$todaypercentcumfirstdose% with at least one dose, $todaypercentcumcomplete% fully vaccinated. That's an increase of $todaypercentnewfirstdose% first doses and $todaypercentnewcomplete% second doses since the day before. Data last updated $today"
	notify-send "$todaypercentcumfirstdose% with at least one dose, $todaypercentcumcomplete% fully vaccinated. That's an increase of $todaypercentnewfirstdose% first doses and $todaypercentnewcomplete% second doses since the day before. Data last updated $today"
	break
else
        if [ -n "$yesterdaycumcomplete" ]
	then
		yesterdaypercentcumcomplete=$(echo "$yesterdaycumcomplete/68171922*100" | bc -l | cut -c -5)
		yesterdaypercentcumfirstdose=$(echo "$yesterdaycumfirstdose/68171922*100" | bc -l | cut -c -5)
		yesterdaypercentnewcomplete=$(echo "$yesterdaynewcomplete/68171922*100" | bc -l | cut -c -5)
		yesterdaypercentnewfirstdose=$(echo "$yesterdaynewfirstdose/68171922*100" | bc -l | cut -c -5)
        	echo "$yesterdaypercentcumfirstdose% with at least one dose, $yesterdaypercentcumcomplete% fully vaccinated. That's an increase of $yesterdaypercentnewfirstdose% first doses and $yesterdaypercentnewcomplete% second doses since the day before. Data last updated $yesterday"
		notify-send "$yesterdaypercentcumfirstdose% with at least one dose, $yesterdaypercentcumcomplete% fully vaccinated. That's an increase of $yesterdaypercentnewfirstdose% first doses and $yesterdaypercentnewcomplete% second doses since the day before. Data last updated $yesterday"
		break
	else
		if [ -n "$daybeforeyesterdaycumcomplete" ]
		then
			daybeforeyesterdaypercentcumcomplete=$(echo "$daybeforeyesterdaycumcomplete/68171922*100" | bc -l | cut -c -5)
			daybeforeyesterdaypercentcumfirstdose=$(echo "$daybeforeyesterdaycumfirstdose/68171922*100" | bc -l | cut -c -5)
			daybeforeyesterdaypercentnewcomplete=$(echo "$daybeforeyesterdaynewcomplete/68171922*100" | bc -l | cut -c -5)
			daybeforeyesterdaypercentnewfirstdose=$(echo "$daybeforeyesterdaynewfirstdose/68171922*100" | bc -l | cut -c -5)
        		echo "$daybeforeyesterdaypercentcumfirstdose% with at least one dose, $daybeforeyesterdaypercentcumcomplete% fully vaccinated. That's an increase of $daybeforeyesterdaypercentnewfirstdose% first doses and $daybeforeyesterdaypercentnewcomplete% second doses since the day before. Data last updated $daybeforeyesterday"
			notify-send "$daybeforeyesterdaypercentcumfirstdose% with at least one dose, $daybeforeyesterdaypercentcumcomplete% fully vaccinated. That's an increase of $daybeforeyesterdaypercentnewfirstdose% first doses and $daybeforeyesterdaypercentnewcomplete% second doses since the day before. Data last updated $daybeforeyesterday"
			break
		else
			if [ -n "$threedaysagocumcomplete" ]
			then
				threedaysagopercentcumcomplete=$(echo "$threedaysagocumcomplete/68171922*100" | bc -l | cut -c -5)
				threedaysagopercentcumfirstdose=$(echo "$threedaysagocumfirstdose/68171922*100" | bc -l | cut -c -5)
				threedaysagopercentnewcomplete=$(echo "$threedaysagonewcomplete/68171922*100" | bc -l | cut -c -5)
				threedaysagopercentnewfirstdose=$(echo "$threedaysagonewfirstdose/68171922*100" | bc -l | cut -c -5)
        			echo "$threedaysagopercentcumfirstdose% with at least one dose, $threedaysagopercentcumcomplete% fully vaccinated. That's an increase of $threedaysagopercentnewfirstdose% first doses and $threedaysagopercentnewcomplete% second doses since the day before. Data last updated $threedaysago"
				notify-send "$threedaysagopercentcumfirstdose% with at least one dose, $threedaysagopercentcumcomplete% fully vaccinated. That's an increase of $threedaysagopercentnewfirstdose% first doses and $threedaysagopercentnewcomplete% second doses since the day before. Data last updated $threedaysago"
				break
			fi
		fi
	fi
fi
