# Docker-based Activator Bootstrap Project

This project is a bootstrap for any Docker-based project using Activator.
It leverages Docker volumes as a cache for SBT dependencies by using https://github.com/obszczymucha/docker-sbt-cache.

## How to get started

1. Fork this repo and clone it.
2. Run `./run.sh ui` script to launch Activator UI.
3. Navigate to http://localhost:8888.
4. Select your template.
5. In *Create an app from this template* section, set `/app` directory as the location for your project.
5. Click *Create app*.

The source code will be created in the `app` directory on your host, so you can use your favourite IDE to work on it.
