datafile=$(ls -l --time-style=+"%Y-%m-%d" /tmp/ | grep "$(date --iso-8601)" | grep "data?areaType=overview&metric=cumPeopleVaccinatedFirstDoseByPublishDate&format=csv" | cut -d " " -f "15")

today="$(date +"%m/%d")"
yesterday="$(date +"%m/%d" -d "1 day ago")"
daybeforeyesterday="$(date +"%m/%d" -d "2 days ago")"
threedaysago="$(date +"%m/%d" -d "3 days ago")"

if [ -z "$datafile" ]
then
        notify-send "Downloading vaccination data." "Please hold."
        wget -q -P /tmp/ "https://api.coronavirus.data.gov.uk/v2/data?areaType=overview&metric=cumPeopleVaccinatedCompleteByPublishDate&metric=cumPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedFirstDoseByPublishDate&metric=newPeopleVaccinatedCompleteByPublishDate&format=csv"
        datafile=$(ls -l --time-style=+"%Y-%m-%d" /tmp/ | grep "$(date --iso-8601)" | grep "data?areaType=overview&metric=cumPeopleVaccinatedFirstDoseByPublishDate&format=csv" | cut -d " " -f "15")
fi

todaydata=$(grep -e "$(date --iso-8601)" "/tmp/$datafile" | cut -d "," -f "5")
yesterdaydata=$(grep -e "$(date --iso-8601 -d "1 day ago")" "/tmp/$datafile" | cut -d "," -f "5")
daybeforeyesterdaydata=$(grep -e "$(date --iso-8601 -d "2 days ago")" "/tmp/$datafile" | cut -d "," -f "5")
threedaysagodata=$(grep -e "$(date --iso-8601 -d "3 days ago")" "/tmp/$datafile" | cut -d "," -f "5")

if [ -n "$todaydata" ] 
then
        todaypercent=$(echo "$todaydata/68171922*100" | bc -l | cut -c -5)
        echo "$todaypercent% as of $today"
        notify-send "Vaccinated:" "$todaypercent% as of $today"
        break
else
        if [ -n "$yesterdaydata" ]
        then
                yesterdaypercent=$(echo "$yesterdaydata/68171922*100" | bc -l | cut -c -5)
                echo "$yesterdaypercent% as of $yesterday"
                notify-send "Vaccinated" "$yesterdaypercent% as of $yesterday"
                break
        else
                if [ -n "$daybeforeyesterdaydata" ]
                then
                        daybeforeyesterdaypercent=$(echo "$daybeforeyesterdaydata/68171922*100" | bc -l | cut -c -5)
                        echo "$daybeforeyesterdaypercent% as of $daybeforeyesterday"
                        notify-send "Vaccinated" "$daybeforeyesterdaypercent% as of $daybeforeyesterday"
                        break
                else
                        if [ -n "$threedaysagodata" ]
                        then
                                threedaysagopercent=$(echo "$threedaysagodata/68171922*100" | bc -l | cut -c -5)
                                echo "$threedaysagopercent% as of $threedaysago"
                                notify-send "$threedaysagopercent% as of $threedaysago"
                                break
                        fi
                fi
        fi
fi
