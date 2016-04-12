php artisan key:generate
php artisan vendor:publish --force
php artisan migrate
php artisan db:seed --class=Seat\\Services\\database\\seeds\\NotificationTypesSeeder
php artisan db:seed --class=Seat\\Services\\database\\seeds\\ScheduleSeeder
php artisan eve:update-sde -n
php artisan seat:admin:reset
