#!/bin/sh

# add this to your crontab to update the quote at midnight:
# 	0 0 * * * /usr/local/quote/update.sh

cd /usr/local/quote
/usr/bin/ruby update.rb > quote.txt

