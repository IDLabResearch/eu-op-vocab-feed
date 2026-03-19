# RDF-Connect pipeline

This system component is an [RDF-Connect](https://rdf-connect.github.io/) pipeline that performs the following steps:

1. Reads a source [OP controlled vocabulary](https://op.europa.eu/en/web/eu-vocabularies/controlled-vocabularies).
2. Performs change detection (based on a given SPARQL query) and Activity Streams (AS) semantic annotation.
3. Bucketizes the extracted stream of AS events into a [B+Tree](https://en.wikipedia.org/wiki/B%2B_tree) data structure.
4. Writes down the buckets and members into a data store, over which a new LDES can be published.

This is accomplished by linking together the following set of RDF-Connect processors

- [rdfc:HttpFetch](https://github.com/rdf-connect/http-utils-processor-ts/tree/main?tab=readme-ov-file#http-utils-processor-ts)
- [rdfc:DumpsToFeed](https://github.com/rdf-connect/dumps-to-feed-processor-ts?tab=readme-ov-file#dumps-to-feed-processor-ts)
- [rdfc:GlobRead](https://github.com/rdf-connect/file-utils-processors-ts?tab=readme-ov-file#-rdfcglobread--glob-based-file-reader)
- [rdfc:Sdsify](https://github.com/rdf-connect/sds-processors-ts?tab=readme-ov-file#rdfcsdsify)
- [rdfc:Bucketize](https://github.com/rdf-connect/sds-processors-ts?tab=readme-ov-file#rdfcbucketize)
- [rdfc:SDSIngest](https://github.com/rdf-connect/sds-storage-writer-ts?tab=readme-ov-file#a-rdf-connect-sds-storage-writer)


# Run it with Docker

We can execute the pipeline using the following Docker commands:

1. First build a container from the [`Dockerfile`](https://github.com/rdf-connect/OP-vocab-feed/blob/main/pipeline/Dockerfile) present in this repository:

```bash
docker build -t rdfc-pipeline .
```

2. Run a Docker container:

```bash
docker run \
-e SOURCE_LDES_URL=https://aphia.org/feed \
-e LDES_BASE_URL=http://localhost:8080 \
-e LDES_URL_PATH=/aphia-mirror/ldes \
-e STORE_TYPE=redis \
-e STORE_URL=default:mypassword@[REDIS_IP]:6379 \
-e NODE_HEAP_SIZE=16384 \
-v ./state:/rdfc-pipeline/state \
rdfc-pipeline
-
```

The above command executes the pipeline, which will: 

1. replicate the Aphia LDES (`SOURCE_LDES_URL`), 
2. apply a different fragmentation strategy (a time-based B+Tree) 
3. that will be persisted in a data store (`STORE_TYPE`://`STORE_URL`) and,
3. that can be published as a mirrored LDES using a given URL (`LDES_BASE_URL`+`LDES_URL`).