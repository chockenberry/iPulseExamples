#!/bin/sh

# add this to your crontab to update the weather every 15 minutes:
# 	*/15 * * * * /usr/local/weather/update.sh

cd /usr/local/weather
/usr/bin/ruby update.rb > weather.rtf

