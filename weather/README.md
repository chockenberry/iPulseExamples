# Setup Weather Script

* Create the script folder with:

```
% cd /usr/local
% sudo mkdir weather
% sudo chown `whoami` weather
% cd weather
```

* Copy `update.rb` and `update.sh` to `/usr/local/weather`.

* Test that script works: a file named `weather.rtf` should be created:

```
% ./update.sh
```

* Edit `cron` tasks:

```
% crontab -e
```

* Add the following to the end of the file and save:

```
*/15 * * * * /usr/local/weather/update.sh
```

* In iPulse Settings, go to the Other panel and "Set User Information File…" to `/usr/local/weather/weather.txt`.

* Hover over the left-right corner of the round window and the text should appear.