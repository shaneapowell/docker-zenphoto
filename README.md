# docker-zenphoto
A dedicated docker image of the ZenPhoto CMS.

## Registry
https://github.com/shaneapowell/docker-zenphoto/pkgs/container/docker-zenphoto

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

## docker-compose - Quick Start
Keeps all dynamic files in `/home/zenphoto/data`.  A series of sub-folders will be added automatically to this location.  You can then simply manually add any image files to the `./albums` folder that will be created.
```
version: "3.9"
services:

  zenphoto:
    container_name: zenphoto
    image: ghcr.io/shaneapowell/zenphoto:1.6.0
    restart: unless-stopped
    ports:
      - 80:80
    volumes:
      - /home/zenphoto/data:/var/www/data

```

## docker-compose - Separate Volumes (preferred)
You can keep the data, albums, and cache folders separate if wanted.  In this example, the `albums` is stored on a NAS using NFS to mount.  The cache folders are kept in an automatically created docker volume.
```
version: "3.9"
services:

  zenphoto:
    container_name: zenphoto
    image: ghcr.io/shaneapowell/zenphoto:1.6.0
    restart: unless-stopped
    ports:
      - 80:80
    volumes:
      - /home/zenphoto/zp-data:/var/www/data/zp-data
      - zenphoto-albums/var/www/data/albums
      - zenphoto-cache:/var/www/data/cache


volumes:

  # Auto-Created volume for cache data
  zenphoto-cache:

  # NFS mounted volume for photos
  zenphoto-albums:
    driver_opts:
      type: "nfs"
      o: "addr=192.168.2.5,nolock,soft,rw"
      device: ":/mnt/user/media/photos"


```

## CLI
```
$ docker volume create zp_cache --opt o=uid=33
$ docker run -it ghcr.io/shaneapowell/docker-zenphoto \
        -p 80:80 \
        -v /home/zenphoto/data:/var/www/data
```


# Update to next ZenPhoto version
As soon as the next version of zenphoto is released, I'll populate this section.


# Zenphto Setup
- `Navigate to http://<host>:80`
- Enter your DB credentials at the bottom.
- Click `GO` button to complete setup. This can take some time (up to a minute),  Be patient, it's running.
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

# Behind a Proxy
ZenPhoto can be easily put behind a host routed proxy (like Caddy or Traefik) without any issue at all.  eg (photos.mydomain.com)

If you try to however proxy ZenPhoto behind a sub-path, you will run into an issue. eg (www.mydomain.com/photos/).
ZenPhoto tries to automaticaly determine it's base path for us.  In this case, the base path is `/`.  
If you need to place zenphoto behind a subpath, you'll need to manually modify your `zp-data/zenphoto.cfg.php` file.  Find the line near the bottom and uncomment it with the appropriate path.
```
// define('WEBPATH', '/zenphoto');
```
to
```
define('WEBPATH', '/photos');
```

# Troubleshooting
## FAQ
- What is the UID:GID of the user within the container?
  - UID:33 (www-data)
  - GID:33 (www-data))

- How is the `/var/www/data` volume structured?
  - `./zp-data`: Where the main configuration data is stored.
  - `./albums`: The location of all your image files.
  - `./cache` Temporary cache files for permormance. Can be deleted anytime. Auto-Created by zen-photo.  If you don't care about ZenPhoto having to re-create this every time you re-create or re-start your container, you can even leave this cache volume unmapped.  I don't recommend that though.

## Tips
- the `zp-data` mounted volume must be `RW` by the `www-data` (UID:33) user within the container.   The easiest solution is to set this folder to to `chmod 777`. This is not ideal though as it opens up the permissions to far.  I simply set the owner of the mount point to `UID:33`
- Your mounted `albums` folder at `/var/www/html/albums` must be RW by the `www-data` user.  Easiest thing to do is set the directory permissions to `a+rwx`.

