# Setup Tempest Script

* Create the script folder with:

```
% cd /usr/local
% sudo mkdir tempest
% sudo chown `whoami` tempest
% cd tempest
```

* Copy `update.rb` and `update.sh` to `/usr/local/tempest`.

* Test that script works: a file named `tempest.rtf` should be created:

```
% ./update.sh
```

* Edit `cron` tasks:

```
% crontab -e
```

* Add the following to the end of the file and save:

```
*/15 * * * * /usr/local/tempest/update.sh
```

* In iPulse Settings, go to the Other panel and "Set User Information File…" to `/usr/local/weather/tempest.rtf`.

* Hover over the left-right corner of the round window and the text should appear.