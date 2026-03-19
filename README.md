# EU Publications Office vocabulary feed 

This repository contains the architectural configuration to produce and publish a [Linked Data Event Stream (LDES)](https://w3id.org/ldes/specification) containing a feed of changes for a given and configurable controlled vocabulary, as the ones managed by the [EU Publications Office](https://op.europa.eu/en/web/eu-vocabularies/controlled-vocabularies). 

The vocabulary changes are modelled using the W3C [Activity Streams 2](https://www.w3.org/TR/activitystreams-core/) vocabulary. 

The data processing workflow is built as an [RDF-Connect](https://rdf-connect.github.io/) pipeline that performs several data transformation steps, which include:

- Raw vocabulary fetching over HTTP
- SHACL-based change detection and semantic labeling with Activity Streams 2
- Fragmentation based on temporal constraints
- Ingestion into a given data store system

The publishing is done via an instance of the [ldes-server](github.com/rdf-connect/LDES-Solid-Server), which sits on top of the data store used by the RDF-Connect pipeline to write the data. 

## System components and architecture

`TODO:` Diagram and description of pipeline components.

## How to run it?

`TODO:` describe the steps to run without Docker

### With Docker

This pipeline and the necessary data storage and interface components are containerized using Docker and can be executed altogether using `docker-compose` as follows:

```bash
$ docker-compose up --build 
```

The [`conf.env`](https://github.com/rdf-connect/OP-vocab-feed/blob/main/conf.env) file contains the main configuration variables to be set.