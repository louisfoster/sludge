PERM0=--allow-env --allow-net --allow-run
PERM1=--allow-write="$(SLUDGE_DIR)" --allow-read="$(SLUDGE_DIR),$(PWD)"
PERM2=--unstable
PERM=$(PERM0) $(PERM1) $(PERM2)
PERM_OSX=$(PERM0) --allow-write="$(SLUDGE_DIR),/usr/local/etc/nginx/servers" --allow-read="$(SLUDGE_DIR),$(PWD)" $(PERM2)
PERM_LINUX=$(PERM0) --allow-write="$(SLUDGE_DIR),/etc/nginx/sites-enabled" --allow-read="$(SLUDGE_DIR),$(PWD)" $(PERM2)
PERM_PROD=$(PERM0) --allow-write="$(SLUDGE_DIR),/etc/systemd/system" --allow-read="$(SLUDGE_DIR),$(PWD)" $(PERM2)
ARGS0=--dir="$(SLUDGE_DIR)" --port="$(SLUDGE_PORT)"
ARGS1=--files="$(SLUDGE_FILES)"
ARGS2=--public="$(SLUDGE_PUBLIC)"
SERVE_ARGS=$(ARGS0) $(ARGS1) $(ARGS2)
CONFIG_ARGS=--configure $(ARGS0) --host="$(NGINX_HOST)" --nginx="$(NGINX_PORT)" --cache="$(SLUDGE_CACHE)"
TEST_ARGS=--test $(CONFIG_ARGS)
OS := $(shell uname)
is_darwin :=$(filter Darwin,$(OS))
CONFIG_DEV_CMD_LINUX=sudo $(HOME)/.deno/bin/deno run $(PERM_LINUX) src/sludge.ts $(CONFIG_ARGS)
CONFIG_DEV_CMD_OSX=$(HOME)/.deno/bin/deno run $(PERM_OSX) src/sludge.ts $(CONFIG_ARGS)


run:
	test $(SLUDGE_FILES)
	test $(SLUDGE_PUBLIC)
	test $(SLUDGE_PORT)
	test $(SLUDGE_DIR)
	$(HOME)/.deno/bin/deno run $(PERM) src/sludge.ts $(SERVE_ARGS)

help:
	$(HOME)/.deno/bin/deno run $(PERM2) src/sludge.ts --help

tester:
	test $(NGINX_HOST)
	test $(NGINX_PORT)
	test $(SLUDGE_PORT)
	test $(SLUDGE_CACHE)
	test $(SLUDGE_DIR)
	$(HOME)/.deno/bin/deno run $(PERM) src/sludge.ts $(TEST_ARGS)

config-dev:
	test $(NGINX_HOST)
	test $(NGINX_PORT)
	test $(SLUDGE_PORT)
	test $(SLUDGE_CACHE)
	test $(SLUDGE_DIR)
	$(if $(is_darwin), $(CONFIG_DEV_CMD_OSX), $(CONFIG_DEV_CMD_LINUX))

config-prod:
	test $(NGINX_HOST)
	test $(NGINX_PORT)
	test $(SLUDGE_PORT)
	test $(SLUDGE_CACHE)
	test $(SLUDGE_DIR)
	sudo $(HOME)/.deno/bin/deno run $(PERM_PROD) src/sludge.ts $(CONFIG_ARGS)