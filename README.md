# EU Publications Office vocabulary feed 

This repository contains the architectural configuration to produce and publish a [Linked Data Event Stream (LDES)](https://w3id.org/ldes/specification) containing a feed of changes for a given and configurable controlled vocabulary, as the ones managed by the [EU Publications Office](https://op.europa.eu/en/web/eu-vocabularies/controlled-vocabularies). 

The vocabulary changes are modelled using the W3C [Activity Streams 2](https://www.w3.org/TR/activitystreams-core/) vocabulary. 

The data processing workflow is built as an [RDF-Connect](https://rdf-connect.github.io/) pipeline that performs several data transformation steps, which include:

- Raw vocabulary fetching over HTTP
- Change detection and semantic labeling with Activity Streams 2
- Fragmentation based on temporal constraints
- Ingestion into a target data store system

The publishing is done via an instance of the [ldes-server](github.com/rdf-connect/ldes-server), which sits on top of the data store used by the RDF-Connect pipeline to write the data. 

## System components and architecture

`TODO:` Diagram and description of pipeline components.

## How to run it?

To run the pipeline locally, you need to make sure all the required components are up and running. These include:

- A Redis or MongoDB instance (see [/datastore](./datastore/) for more information)
- An instance of the ldes-server (see [/ldes-server](./ldes-server/) for more information)
- Optionally, an Varnish instance for caching (see [/varnish](./varnish/) for more information)

Next, you need to configure all the environment variables in the [`conf.env`](./conf.env) file according to your local setup.

Finally, you can an execution loop of the pipeline, that will fetch all versions of a given vocabulary (see [run.sh](./run.sh)) with:

```bash
./run.sh 
```

### With Docker

This pipeline and the necessary data storage and interface components are containerized using Docker and can be executed altogether using `docker-compose` as follows:

```bash
$ docker-compose up --build 
```

The [`conf.env`](./conf.env) file contains the main configuration variables to be set.