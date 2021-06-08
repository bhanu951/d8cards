#!/bin/bash

## Set composer memory limit -1 unlimited. Valid options 2G,1G,512M
echo "Set composer memory limit -1 unlimited."
export COMPOSER_MEMORY_LIMIT=-1

## Check Composer Version.
echo "Check Composer Version."
composer --version

## Self Update Composer.
# composer self-update
## Check Updated Composer Version.
# composer --version
## Pull the latest code from git
# git pull <branchname>

## Backup databases before update.
echo "Backup databases before update."
./vendor/bin/drush sql:dump --gzip --result-file=./sites/default/files/d8cards-backup-`date +%Y-%m-%d-%H.%M.%S`.sql

## Drop old database
echo "Dropping old database"
./vendor/bin/drush sql:drop -y

## Restore the backup
./vendor/bin/drush sqlc < ./databases/d8cards_clean.sql

## Clear cache to reflect imported database.
echo "Clear cache to reflect imported database."
./vendor/bin/drush cr

## Set site in maintenance mode.
echo "Set site in maintenance mode."
./vendor/bin/drush sset system.maintenance_mode 1

## Clear cache to reflect maintanace mode.
echo "Clear cache to reflect maintanace mode."
./vendor/bin/drush cr

## Install updates.
echo "Install updates."
composer install

# composer update -W

## Check if drush is accessible.
echo "Check if drush is accessible."
./vendor/bin/drush st

## Clear cache to get updated code in file system tracked.
echo "Clear cache to get updated code in file system tracked."
./vendor/bin/drush cr

## Update database changes.
echo "Update database changes."
./vendor/bin/drush updb -y

## Set site maintenance mode.
echo "Set site maintenance mode."
./vendor/bin/drush sset system.maintenance_mode 0

## Disable css and js aggregraton.
echo "Disable css and js aggregraton."
./vendor/bin/drush -y cset system.performance css.preprocess 0
./vendor/bin/drush -y cset system.performance js.preprocess 0

## Clear cache to get updates reflected.
echo "Clear cache to get updates reflected."
./vendor/bin/drush cr

## Check site details after update.
echo "Check site details after update."
./vendor/bin/drush st

## Run cron to execute any pending crons.
echo "Run cron to execute any pending crons."
./vendor/bin/drush cron

## Drop database
# ./vendor/bin/drush sql:drop
## Restore the backup
# ./vendor/bin/drush sqlc < /apps/tmp/backups/devportaltest_9_2_2020.sql
