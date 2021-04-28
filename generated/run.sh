#!/bin/bash

docker exec -it -w /opt/host/generated hs-db psql -U postgres -q -f run.sql generated
