ragel-sandbox
=============

A sandbox for ragel development.

Development tools are in [scripts](https://github.com/abargnesi/ragel-sandbox/blob/master/README.md).

developing with the [kleene star](http://en.wikipedia.org/wiki/Kleene_star)
---------------------------------------------------------------------------

requirements
+ ragel
+ feh
+ dot (graphviz)
+ inotifywait (inotify-tools)
+ notify-send (libnotify)

```bash
[tony@starship ragel-sandbox (master #)]$ scripts/ragel-iterate.sh 
Setting up watches.  Beware: since -r was given, this may take a while!
Watches established.
# make changes to any ../*.rl file
building template (template.rl)
  generated state chart (template.png)
  displaying state chart (template.png)
# feh opens or reloads
```

warnings
+ non-trivial ragel state charts can take a while to render
