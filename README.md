# Drupal Installation Guide.

**Table of Contents**

------------
<!-- MarkdownTOC -->

-
    - Create Project Composer Command
    - To do a modified install
    - Configure Apache2
    - Virtual Hosts Configuration
    - Enable the Virtual Host and Rewrite Module
    - Restart Apache2 Server
    - Edit hosts file
    - Creating MySQL User
    - Creating Empty Database
    - Importing Existing Database
    - Exporting Database
    - Install Drupal with the standard profile
    - Export the current configuration outside of the webroot
    - Setting up Drush Aliases
    - Adding Pre-Commit Hook
    - Additional Reference

<!-- /MarkdownTOC -->
------------

#### Create Project Composer Command

> composer create-project drupal/recommended-project d8cards

#### To do a modified install

If you want to modify some of the properties of the downloaded composer.json before `composer install` is executed, use the `--no-install` flag when running `composer create-project`. For example, it is possible that you want to rename the subdirectory 'web' to something else.

- To do that:


    Run composer create-project --no-install drupal/recommended-project d8cards
    Change directories to d8cards and edit the composer.json file to suit your needs. For example, to change the sub-directory from 'web' to something else, the keys to modify are the 'extra' sub-keys 'webroot' and 'installer-paths'.
    Run composer install to download Drupal 8 and all its dependencies.


**Remember**:

- Add development modules always to Composer with `--dev`, for example:

> composer require --dev drupal/devel

- Check for available Drupal core and module updates:

> composer outdated drupal/*

- All of your modules and themes can be updated along with Drupal core via:

> composer update

- To update only Drupal core without any modules or themes, use:

> composer update drupal/core-recommended --with-dependencies

#### Configure Apache2

> sudo subl /etc/apache2/sites-available/d8cards.conf

#### Virtual Hosts Configuration

```
<VirtualHost *:80>
  ServerAdmin admin@d8cards.local
     DocumentRoot /var/www/d8cards/web
     ServerName d8cards.local
     ServerAlias www.d8cards.local *.d8cards.local
     <Directory /var/www/d8cards/web>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

#### Enable the Virtual Host and Rewrite Module

> sudo a2ensite d8cards.conf

> sudo a2enmod rewrite

#### Restart Apache2 Server

> sudo systemctl restart apache2.service

#### Edit hosts file

>  sudo subl /etc/hosts

Add the below line the host file

> 127.0.0.1  local.d8cards.local

Then open your browser and browse to the server domain name. You should see Drupal page at http://local.d8cards.local


#### Creating MySQL User

> CREATE USER 'drupal'@'localhost' IDENTIFIED BY '<password>';

> GRANT ALL PRIVILEGES ON * . * TO 'drupal'@'localhost';

> FLUSH PRIVILEGES;


#### Creating Empty Database

```
sudo mysql -u drupal -p
create database d8cards_local;
exit;

```

#### Importing Existing Database

> drush @site.alias sql-drop -y; drush @site.alias sql-cli < db-backups/[your-filename].sql

Or, if you have a GZIP:

> gunzip -c file_name.sql.gz | drush @site.alias sqlc

or

> drush  @site.alias sqlq --file=db.sql.gz

Note that `–file` supports both compressed and uncompressed files.

#### Exporting Database

> drush sql-dump --gzip --result-file=db-backups/[your-filename].sql

#### Install Drupal with the standard profile

>  drush si standard --site-name='Site Name' --account-name=admin --account-pass=YourPass --account-mail='admin@site.local' --sites-subdir=LocalDir --locale=en --db-url=mysql://[db_user]:[db_pass]@[ip-address]/[db_name]

for example :

>  drush si standard --site-name='D8cards Local' --account-name=admin --account-pass=admin --account-mail='admin@d8cards.local' --sites-subdir=local --locale=en --db-url=mysql://drupal:drupal@localhost/d8cards_local

#### Export the current configuration outside of the webroot

- Change the location of the configuration sync directory.

> sudo subl web/sites/default/settings.php

- Change the last line to:

> $settings['config_sync_directory'] = '../config/local';

#### Setting Up Public, Private and Temp directories

> $settings['file_public_path'] = 'sites/local/files/public';
> $settings['file_private_path'] = 'sites/local/files/private';
> $settings['file_temp_path'] = 'sites/local/files/tmp';

#### Setting up Drush Aliases

Create a directory named `drush` outside `webroot`
In `drush/sites` folder create a file named `sitename.site.yml`

- For example in local.site.yml file add the below code

```yaml
    local:
      uri: local.d8cards.local
```
- Export the current configuration to create an initial set of YAML files.

>  drush @site.alias cex

#### Adding Pre-Commit Hook

 - Run Code Sniffer automatically on each changed file before a commit.

[ Refer the link for pre-commit snippet](https://git.io/fNXiK)

This pre-commit hook is designed to be used for Drupal 7 and 8 sites.

Download the pre-commit file. Save it as ` .git/hooks/pre-commit` in your git repo. You need to ensure that the file is executable.

If you want this to be added to all **new** projects automatically, add it to your [git init templates](https://git-scm.com/docs/git-init#_template_directory).

To install and PHP CodeSniffer for Drupal, please read [the official documentation](https://www.drupal.org/node/1419988).

To see this working checking out [this short YouTube video](https://youtu.be/LV9s-ue2JG8).

- You can skip executing the pre-commit script by using:

> git commit --no-verify

#### Additional Reference

[Set up Drupal 8](https://www.drupal.org/docs/develop/local-server-setup/linux-development-environments/set-up-a-local-development-drupal-0-4 "Set up Drupal 8")

------------


- File created using  [Editor.md](https://pandao.github.io/editor.md/index.htm "Editor.md")


![](https://pandao.github.io/editor.md/images/logos/editormd-logo-180x180.png)
