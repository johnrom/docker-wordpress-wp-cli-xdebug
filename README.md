# docker-wordpress-wp-cli-xdebug

This is an image based off of [Conetix's docker-wordpress-wp-cli](https://github.com/conetix/docker-wordpress-wp-cli).

This repository adds xDebug support.

Additionally, I've removed an opcache configuration file that the WordPress image installs because it appeared to affect PHP Opcode Caching on my machine. You shouldn't notice a difference unless your local machine gets a lot of hits *lol*.

Finally, I added phpunit to integrate unit testing into my workflow. Unfortunately, WP installs the tests using `mysqladmin`, which requires installing `mysql`.

**This is super untested.** Do not use in production. I built this on Windows so permissions are not correct. Maybe one day I will fix it.

This image works even better when provisioning your projects with [nimble](https://github.com/johnrom/nimble), enabling `phpmyadmin`, `phpunit` testing, xdebug, `webgrind` and `wp-cli` all at the same time instantly.

To use, you'll have to pass a variable to XDebug with your IP Address. Please note, this is the IP address of your machine, not the docker VM. It is generally a 192.168.* address. You can find it a number of ways, one is to check the Virtual Host-Only Network in VirtualBox (Docker toolsbox only) and look at the gateway IP. Another way is to get the IP address of eth1 on the Virtual Machine, and replace the last octal with "1". If using native Docker, [nimble](https://github.com/johnrom/nimble) does this work for you.

`192.168.99.100 => 192.168.99.1`

Are you super lazy? Try the following within Docker Terminal, replacing default with your machine name if necessary:

`echo $(docker-machine ip default) | sed 's/\.[0-9]*$/.1/'`

Example: `192.168.99.1`

Are you the only one developing your project? Try:

```
wp_site:
  image: johnrom/docker-wordpress-wp-cli-xdebug
  ... [ your regular configuration ]
  environment:
    XDEBUG_CONFIG: remote_host=[your.local.ip4.address]
```

If that worked, skip to "So what now?"

---

Are you **not** the only one developing your project? Then we'll have to use the environment variable from each of your shells. So, replace the above with:

```
wp_site:
  image: johnrom/docker-wordpress-wp-cli-xdebug
  ... [ your regular configuration ]
  environment:
    - XDEBUG_CONFIG
```

This means it will use whatever environment variable is in your shell when you run `docker-compose up -d`. Now go download the xdebug.sh file from this GitHub repo to your root docker directory. If your docker-machine is not named default, you should replace default with your machine's name in the `xdebug.sh` file.

Every time, before you run `docker-compose up -d`, run `eval $(./xdebug.sh)` **in the directory with `docker-compose.yml` in it**. Like so:

```
eval $(./xdebug.sh)
docker-compose up -d
```

This tiny command runs the `docker-machine ip | sed` command above and exports it to an environment variable, that docker-compose picks up.

To confirm everything is working, make a phpinfo.php with `<?php phpinfo(); ?>` and check the variables for XDebug -- "remote_host" should show your IP address.

## So what now?

Now, PHP will query your host machine on port 9000 every time you make a request. You'll have to set up an xdebug debugger in your editor of choice. I'm currently using VS Code so I haven't verified any others' tutorials. Set breakpoints, test listening for notices, etc. It should all magically work.

- [VS Code](https://github.com/felixfbecker/vscode-php-debug) - skip *Install XDebug*, go to Configuration, and make sure to set localSourceRoot and serverSourceRoot
- [Sublime](https://github.com/martomo/SublimeTextXdebug) - **unverified**
- [Atom](https://atom.io/packages/php-debug) - **unverified, but official**
- [Brackets](https://github.com/spocke/php-debugger) - **unverified**, don't use "idekey"

### If that wasn't enough

Here's my launch.json for every project in VS Code for demonstrative purposes:

```
{
	"version": "0.2.0",
	"configurations": [
		{
			"name": "Listen for XDebug",
			"type": "php",
			"request": "launch",
			"port": 9000,
            "localSourceRoot": "${workspaceRoot}",
            "serverSourceRoot": "/var/www/html"
		}
	]
}
```
