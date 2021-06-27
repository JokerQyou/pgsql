# pgsql

A docker image recipe mixing the official Postgres 12 image and `wal-g` backup tool.

## Build

To build locally, run `docker build -t IMAGE_TAG .`.
Use [docker buildx](https://docs.docker.com/buildx/working-with-buildx/) if you need a multi-platform image.

## Credits

The `wal-g` directory comes from [koehn/postgres-wal-g](https://gitlab.koehn.com/docker/postgres-wal-g).

