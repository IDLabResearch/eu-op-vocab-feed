#!/bin/bash

# Source the environment variables
set -a
source conf.env
set +a

# Array of all version dates in ascending order
DATES=(
  "20140521-3"
  "20150318-0"
  "20150520-0"
  "20150916-0"
  "20151118-0"
  "20160217-0"
  "20160316-0"
  "20160615-0"
  "20160722-0"
  "20160921-0"
  "20161026-0"
  "20161214-0"
  "20170130-0"
  "20170315-0"
  "20170427-0"
  "20170428-0"
  "20170621-0"
  "20170920-0"
  "20171213-0"
  "20180124-0"
  "20180321-0"
  "20180620-0"
  "20180725-0"
  "20180926-0"
  "20181212-0"
  "20190220-0"
  "20190619-0"
  "20190918-0"
  "20191116-0"
  "20191211-0"
  "20191218-0"
  "20200131-0"
  "20200318-0"
  "20200624-0"
  "20200923-0"
  "20201216-0"
  "20210116-0"
  "20210303-0"
  "20210317-0"
  "20210420-0"
  "20210616-0"
  "20210929-0"
  "20211208-0"
  "20211210-0"
  "20220119-0"
  "20220316-0"
  "20220615-0"
  "20220928-0"
  "20221019-0"
  "20221214-0"
  "20230315-0"
  "20230412-0"
  "20230614-0"
  "20230927-0"
  "20231120-0"
  "20231213-0"
  "20240111-0"
  "20240313-0"
  "20240321-0"
  "20240425-0"
  "20240612-0"
  "20240925-0"
  "20241211-0"
  "20250131-0"
  "20250211-0"
  "20250319-0"
  "20250618-0"
  "20251022-0"
  "20260105-0"
  "20260318-0"
)

# Move to pipeline directory
cd pipeline
# Loop over each date
for VERSION_DATE in "${DATES[@]}"; do
  echo "--------------------------------------------------------"
  echo "Processing version: $VERSION_DATE"
  
  if [ "$VERSION_DATE" = "20170428-0" ]; then
    export VOCAB_SOURCE="https://op.europa.eu/o/opportal-service/euvoc-download-handler?cellarURI=http%3A%2F%2Fpublications.europa.eu%2Fresource%2Fdistribution%2Fcorporate-body%2F20170428-0_skos_corporatebodies-skos.rdf&fileName=corporatebodies-skos.rdf"
  else
    export VOCAB_SOURCE="https://op.europa.eu/o/opportal-service/euvoc-download-handler?cellarURI=http%3A%2F%2Fpublications.europa.eu%2Fresource%2Fdistribution%2Fcorporate-body%2F$VERSION_DATE%2Frdf%2Fskos_core%2Fcorporatebodies-skos.rdf&fileName=corporatebodies-skos.rdf"
  fi
  
  echo "VOCAB_SOURCE=$VOCAB_SOURCE"

  # Create temporary run files from templates
  cp ./config/sds-metadata.ttl ./config/sds-metadata-run.ttl
  cp ./rdfc-pipeline.ttl ./rdfc-pipeline-run.ttl

  # Replace any environment variables in the files
  # Only replace targeted variables to avoid sed injection from other env vars
  for name in LDES_BASE_URL LDES_URL_PATH STORE_TYPE STORE_URL VOCAB_SOURCE NODE_HEAP_SIZE; do
      value="${!name}"
      # Escape | and & to prevent them from breaking sed
      value="${value//|/\\|}"
      value="${value//&/\\&}"
      sed -i "s|\${${name}}|${value}|g" ./config/sds-metadata-run.ttl
      sed -i "s|\${${name}}|${value}|g" ./rdfc-pipeline-run.ttl
  done

  # Run the RDF-Connect pipeline for the current version using the temporary file
  npx --node-options="--max-old-space-size=${NODE_HEAP_SIZE}" rdfc rdfc-pipeline-run.ttl
  
  echo "Finished processing version: $VERSION_DATE"
done

# Clean up temporary run files
rm -f ./config/sds-metadata-run.ttl ./rdfc-pipeline-run.ttl

echo "All versions have been processed."
