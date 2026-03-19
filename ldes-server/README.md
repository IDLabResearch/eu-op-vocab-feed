# LDES Server

This system component provides a container with an implementation of an LDES server. The implementation used by this component is available at <https://github.com/rdf-connect/ldes-server>.

## Run it

1. Make sure to have Node.js v20 or higher installed.
2. Install the dependencies by running the following command:

```bash
npm install
```

3. Make sure that the environment variables in the `config-ldes.json` file are set to the desired values. These include:

- `STORE_TYPE`: The type of data store to use. Options are `redis` and `mongodb`.
- `STORE_URL`: The URL of the data store.
- `LDES_BASE_URL`: The base URL of the LDES server.
- `LDES_URL_PATH`: The URL path of the LDES server.

4. Start the server by running the following command:

```bash
npx @solid/community-server -c ./config-ldes.json -b http://localhost:3000
```

## Run with Docker

1. First build the server image as follows:

```bash
docker build -t ldes-server .
```

2. Now, run a container of the server (using a Redis data store) with the following command:

```bash
docker run \
--name ldes-server \
-p 3000:3000 \
-e STORE_TYPE=redis \
-e STORE_URL=default:mypassword@localhost:6379 \
-e LDES_BASE_URL=http://localhost:8080 \
-e LDES_URL_PATH=/aphia-mirror/ldes \
ldes-server
```

An example using a MongoDB data store is as follows:

```bash
docker run \
--name ldes-server \
-p 3000:3000 \
-e STORE_TYPE=mongodb \
-e STORE_URL=root:mypassword@localhost:27017/mr-ldes?authSource=admin \
-e LDES_BASE_URL=http://localhost:8080 \
-e LDES_URL_PATH=/aphia-mirror/ldes \
ldes-server
```
