#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
cd "${DIR}" || exit 1

inotifywait -r -m -e modify . | while read line; do
    RET=($line)
    FILE=${RET[2]}
    case $FILE in
        *.rl)
            NAME=${FILE%.rl}
            echo "building $NAME ($FILE)"
            COMPILE_OUT=$(ragel -p -R $FILE 2>&1)
            if [ "$?" != 0 ]; then
                notify-send -t 5000 "$COMPILE_OUT"
                echo -e "  ragel failure:\n$COMPILE_OUT"
                continue
            fi
            ;;
        *)
            ;;
    esac
done

