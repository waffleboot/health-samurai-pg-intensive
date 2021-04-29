#!/bin/bash

docker exec -it -w /opt/host/fhir hs-db psql -U postgres -q -f run.sql fhir
