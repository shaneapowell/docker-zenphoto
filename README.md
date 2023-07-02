# docker-zenphoto
A dedicated docker image of the ZenPhoto CMS.

# Features
- GD Support

# Requirements
- Existing MariaDB running

# Docker Setup
- Create needed local volumes
  - `zp-data`
  - `cache`
  - `cache_html`

# Docker Update
TBD

# Zenphto Setup
- `Navigate to http://<host>:80`
- Enter your DB credentials at the bottom.
  - Database Creation Success
- Click `GO` button to complete setup. This can take some time if you have lots of photos. Be patient, it's running.
- Edit your new `zenphoto.cfg.php` on your mapped volume.
  - Comment out the line near the bottom to enable your zenphoto instance.
  - `#$conf['site_upgrade_state'] = "closed";`


# Create a MariaDB database
```
$ mysql -u root -P
Enter Password:

MariaDB> create database zenphoto;
Query OK, 1 row affected (0.000 sec)

MariaDB> CREATE USER 'zenphoto'@'%' IDENTIFIED by '<your-password>';
Query OK, 0 rows affected (0.162 sec)

MariaDB> GRANT USAGE on zenphoto.* to 'zenphoto'@'%';
Query OK, 0 rows affected (0.136 sec)

MariaDB> GRANT ALL ON zenphoto.* TO 'zenphoto'@'%';
Query OK, 0 rows affected (0.076 sec)

```

# Troubleshooting

## Tips
- Your mounted `albums` folder at `/var/www/html/albums` must be RW by the `www-data` user.  Easiest thing to do is set the directory permissions to `a+rwx`.

## I keep getting an error when I access the URL?
- This is usually a database connection error.  You can skip the setting of the various DB ENV vars in your docker compose. This should cause zen-photo to bring up the "setup" page.  You can manually try and enter your DB credentials here and see if they work as expected. If you manage to get a connection, you can `shell` into your container and view the contents of the generated