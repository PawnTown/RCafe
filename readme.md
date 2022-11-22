# Development Environment

These scripts can be used to create a development environment.

## How to setup

Before you start, make sure you have your `env.local` files ready:

- app.local.env
- api.local.env


These files will be injected into the project folders during setup.

You will also need following software:

- Docker

If you have that ready, run the setup with:

```bash
./setup.sh
```

This will spinup a database and als clone all necessary repositories.

If you want to start the dev environment, just run:

```bash
./start.sh
```
