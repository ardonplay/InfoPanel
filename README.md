# Infopanel

Infopanel - core app for creating software for infopanels

Infopanel project contains:

- [server](https://github.com/ardonplay/infopanel-server)

- [client](https://github.com/ardonplay/infopanel-client)

- [database](https://github.com/ardonplay/infopanel-database)

## Installation

Clone repository:

```sh
git clone https://github.com/ardonplay/infopanel
```

To install the necessary components (server, client, database), run the following command:

```bash
./control.sh install
```

This will clone the necessary components.

## Launching app

> [!IMPORTANT]  
> A [docker](https://www.docker.com/) is required to successfully launch the application.

To run appp, use following command:

```bash
./control.sh run
```

Run in the background:

```bash
./control.sh run -d
```

Stop:

```bash
./control.sh stop
```

You can also:

```bash
./control.sh restart
```

## Help

To display the usage information and available options, run the following command:

```bash
./control.sh --help
```


## Links

- [Docker](https://www.docker.com/)

- [NodeJs](https://nodejs.org/en)

- [PostgreSQL](https://www.postgresql.org/)

- [OpenJDK](https://openjdk.org/)
