#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
cd "${DIR}" || exit 1

# must have RAGEL_OPTS set
if [ -z "$RAGEL_OPTS" ]; then
    echo "RAGEL_OPTS not set.  Not sure how to build." 1>&2
    exit 1
fi

# loop compile + state chart
inotifywait -r -m -e modify . | while read line; do
    RET=($line)
    FILE="${RET[@]:2}"
    case "$FILE" in
        *.rl)
            NAME="${FILE%.rl}"
            echo "building '$NAME' ($FILE); RAGEL_OPTS = $RAGEL_OPTS"

            COMPILE_OUT=$(ragel $RAGEL_OPTS "$FILE" 2>&1)
            if [ "$?" != 0 ]; then
                notify-send -t 5000 "$COMPILE_OUT"
                echo -e "  ragel failure:\n$COMPILE_OUT"
                continue
            fi

            ragel -p -R "$FILE" -V | dot -Tpng -o "$NAME.png"
            echo "  generated state chart ($NAME.png)"
            if [ "$?" == 0 ]; then
                HAS_FEH=$(ps aux | grep "feh.*$NAME.png" | grep -v grep -c)
                if [ $HAS_FEH -eq 1 ]; then
                    killall feh 2>&1 > /dev/null
                fi
                echo "  displaying state chart ($NAME.png)"
                feh --no-screen-clip "$NAME.png" &
            fi
            ;;
        *)
            ;;
    esac
done

