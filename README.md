ragel-sandbox
=============

A sandbox for ragel development.

Development tools are in [scripts](https://github.com/abargnesi/ragel-sandbox/blob/master/README.md).

developing with the [kleene star](http://en.wikipedia.org/wiki/Kleene_star)
---------------------------------------------------------------------------

(a.k.a. re-ragel zero or more times)

requirements
+ ragel
+ feh
+ dot (graphviz)
+ inotifywait (inotify-tools)
+ notify-send (libnotify)

```bash
[tony@starship ragel-sandbox (master)]$ scripts/ragel-iterate.sh 
Setting up watches.  Beware: since -r was given, this may take a while!
Watches established.
# you make changes to any ../*.rl file
building template (template.rl)
  generated state chart (template.png)
  displaying state chart (template.png)
# then feh displays the state chart graph
```

warnings
+ non-trivial ragel state charts can take a while to render
