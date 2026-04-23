# Setup Quote Script

* Create the script folder with:

```
% cd /usr/local
% sudo mkdir quote
% sudo chown `whoami` quote
% cd quote
```

* Copy `update.rb` and `update.sh` to `/usr/local/quote`.

* Test that script works: a file named `quote.txt` should be created:

```
% ./update.sh
```

* Edit `cron` tasks:

```
% crontab -e
```

* Add the following to the end of the file and save:

```
0 0 * * * /usr/local/quote/update.sh
```

* In iPulse Settings, go to the Other panel and "Set User Information File…" to `/usr/local/quote/quote.txt`.

* Hover over the left-right corner of the round window and the text should appear.