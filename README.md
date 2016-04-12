# SEATv2

Note: this requires https://github.com/OSS-EVE/seat.git to sit in the dev folder until the changes are merged into the the official repo.



## Run:

    docker-compose up -d

## Start background workers:

    docker exec -i seatdocker_seat_1 supervisord -k -c /etc/supervisor/supervisord.conf


## Initialize DB, SDE and set admin PW (needs to run):

    docker exec -i seatdocker_seat_1 bash /var/www/seat/init.sh

## Update SDE (needs to run):

    docker exec -i seatdocker_seat_1 bash /var/www/seat/update.sh