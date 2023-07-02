# docker-zenphoto
A dedicated docker image of the ZenPhoto CMS.

# Features
- GD Support
- PHP 8.0.0
- Apache2
- (future) 2 image versions.
  - One with a built in MariaDB.
  - One requring and existing MariaDB.

# Requirements
- Existing MariaDB running

# Docker Setup
## CLI
```
$ docker volume create zp_cache --opt o=uid=33
$ docker volume create zp_cache_html  --opt o=uid=33
$ docker run -it ghcr.io/shaneapowell/docker-zenphoto \
        -p 80:80 \
        -v zp_cache:/var/www/html/cache \
        -v zp_cache_html:/var/www/html/cache_html \
        -v
```
- Create needed local volumes
  - `zp-data`
  - `cache`
  - `cache_html`

## Docker Compose
```
version: "3.9"
services:

  zenphoto:
    container_name: zenphoto
    image: ghcr.io/shaneapowell/zenphoto:1.6.0
    restart: unless-stopped
    user: 33:100
    ports:
      - 80:80
    volumes:
      - /home/myuser/zenphoto/data:/var/www/html/zp-data
      - /home/myuser/zenphoto/albums:/var/www/html/albums
      - /home/myuser/zenphoto/cache:/var/www/html/cache
      - /home/myuser/zenphoto/cache_html:/var/www/html/cache_html

```

# Docker Update
TBD

# Zenphto Setup
- `Navigate to http://<host>:80`
- Enter your DB credentials at the bottom.
  - Database Creation Success
- Click `GO` button to complete setup. This can take some time if you have lots of photos. Be patient, it's running.
- Step through the final zenphoto setup pages.
- Disable Maintenance mode.
  - ZenPhoto Admin pages.
  - navigate to `Overview`.
  - click the `maintentance mode` link near the middle.
  - click the `open the site` radio button
  - click `Apply`
- Enable MOD_REWRIET
  - ZenPHoto Admin Pages.
  - navigate to `Options` tab.
  - Enable the `mod rewrite` checkbox
  - click `Apply`


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
## FAQ
- What is the UID:GID of the user within the container?
  - username: www-data (UID33)
  - group:

## Tips
- the `zp-data` mounted volume must be RW by the `www-data` (UID:33) user within the container.   The easiest solution is to set this folder to to `chmod 777`. This is not ideal though as it opens up the permissions to far.
- Your mounted `albums` folder at `/var/www/html/albums` must be RW by the `www-data` user.  Easiest thing to do is set the directory permissions to `a+rwx`.

## I keep getting an error when I access the URL?
- This is usually a database connection error.  You can skip the setting of the various DB ENV vars in your docker compose. This should cause zen-photo to bring up the "setup" page.  You can manually try and enter your DB credentials here and see if they work as expected. If you manage to get a connection, you can `shell` into your container and view the contents of the generated