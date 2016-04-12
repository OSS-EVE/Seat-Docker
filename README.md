# SEATv2

Run:
    docker-compose up -d

Initialize DB (need to run):

    docker exec -i seatdocker_seat_1 bash /var/www/seat/init.sh

Update SDE (needs to run):

    docker exec -i seatdocker_seat_1 bash /var/www/seat/update.sh