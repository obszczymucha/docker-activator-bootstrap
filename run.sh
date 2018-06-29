#!/bin/bash
DOCKER_IMAGE="obszczymucha/activator"

function find-sbt-cache-container {
  docker ps -af name=sbt-cache | grep -v "CONTAINER ID" > /dev/null
}

function print-no-sbt-cache-found {
  echo "Docker container for SBT cache was not found."
  echo "What to do:"
  echo "  * clone https://github.com/obszczymucha/docker-sbt-cache"
  echo "  * follow README file in that repo"
  echo "  * run this script again"
}

function print-usage {
  echo "Usage: $0 <start|test|coverage|custom>"
  echo "where:"
  echo "                 start - start the application"
  echo "                  test - run unit tests and listen for code changes"
  echo "              coverage - instrument coverage and generate the report"
  echo "     custom <commands> - pass given commands directly to activator"
}

function pull-docker-image {
  docker pull ${DOCKER_IMAGE}
}

function start-the-app {
  pull-docker-image
  docker run -it -p 80:9000 -v $(pwd):/app --volumes-from sbt-cache -w /app ${DOCKER_IMAGE} activator start
}

function run-unit-tests {
  pull-docker-image
  docker run -it -v $(pwd):/app --volumes-from sbt-cache -w /app ${DOCKER_IMAGE} activator ~test
}

function run-coverage-report {
  pull-docker-image
  docker run -it -v $(pwd):/app --volumes-from sbt-cache -w /app ${DOCKER_IMAGE} activator test-coverage
}

function run-activator-ui {
    pull-docker-image
    echo "Cleaning up..."
    docker run --volumes-from sbt-cache -w /app obszczymucha/activator rm /root/.activator/1.3.10/.currentpid
    docker run -it -p 8888:8888 -v $(pwd):/app --volumes-from sbt-cache -w /app ${DOCKER_IMAGE} activator -Dhttp.address=0.0.0.0 ui
}

function run-custom {
  if [ "$#" -eq 0 ]; then
    print-usage
    exit 1
  fi

  pull-docker-image
  docker run -it -v $(pwd):/app --volumes-from sbt-cache -w /app ${DOCKER_IMAGE} activator $@
}

function main {
  if [ "$#" -eq 0 ]; then
    print-usage
    exit 1
  elif ! find-sbt-cache-container; then
    print-no-sbt-cache-found
    exit 2
  else
    case $1 in
                start) start-the-app ;;
                 test) run-unit-tests ;;
             coverage) run-coverage-report ;;
                   ui) run-activator-ui ;;
               custom) run-custom ${@:2} ;;
                    *) print-usage; exit 3 ;;
    esac
  fi
}

main $@

