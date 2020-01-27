#!/bin/bash

acpi_handler() {
    case $1 in
        button/sleep)
            case $2 in
                SLPB|SBTN)
                    lock.sh
                    ;;
            esac
            ;;
        button/lid)
            case $3 in
                close)
                    lock.sh
                    ;;
            esac
            ;;
    esac
}

coproc acpi_listen
trap 'kill $COPROC_PID' EXIT

while read -u "${COPROC[0]}" -a event; do
    acpi_handler ${event[@]}
done
