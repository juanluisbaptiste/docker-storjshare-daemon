# storjshare-daemon docker image

Unofficial Storjshare Daemon + CLI for farming data on the [Storj](https://storj.io/) network.


## How to build the image

Clone the repo and then use `docker-compose` to build the image:

    cd docker-storjshare-daemon
    sudo docker-compose -f docker-compose-dev.yml build

## How to run the container

To start the container there's a docker-compose.yml file. You need to create the configuration first if you don't have it yet.

### Create configuration file

If you don't have a configuration file for the daemon you will need to create one. For this you can invoke _storjshare create_ with the following command:

    sudo docker-compose run daemon storjshare create .....

And specify the parameters of the create command to create the configuration file:
    Starting daemon-data

        Usage: storjshare-create [options]

        generates a new share configuration


        Options:

          --storj <addr>             specify the STORJ address (required)
          --key <privkey>            specify the private key
          --storage <path>           specify the storage path
          --size <maxsize>           specify share size (ex: 10GB, 1TB)
          --rpcport <port>           specify the rpc port number
          --rpcaddress <addr>        specify the rpc address
          --maxtunnels <tunnels>     specify the max tunnels
          --tunnelportmin <port>     specify min gateway port
          --tunnelportmax <port>     specify max gateway port
          --manualforwarding         do not use nat traversal strategies
          --verbosity <verbosity>    specify the logger verbosity
          --logdir <path>            specify the log directory
          --noedit                   do not open generated config in editor
          -o, --outfile <writepath>  write config to path
          -h, --help                 output usage information

If you already have a configuration file then you can skip this step and put your configuration file on the _/config_ directory, there's where the _run.sh_ startup script will look into for _config.json_ by default. If you are going to use a different location for the configuration file you need to set STORJ_CONFIG_FILE pointing to the new directory.

The _docker-compose.yml_ configuration file defines the following volumes that needs to be adjusted according to your setup (specially the data directory):

  * _ Data directory_: This is the path to the space you are going to rent to the Storj network. Inernally it maps to _/rented_.
  * _ Configuration directory_: Where the Storjshare daemon configuration file is stored. Internally it uses _/config_, where it will look for a config file named _config.json_.
  * _Logs directory_: Where to store the daemon logs.

This is how they are defined in the _docker-compose_ file:

    volumes:
      - ./volumes/rented:/rented #data
      - ./volumes/config:/config #configuration
      - ./volumes/log:/log #logs
      - /etc/localtime:/etc/localtime:ro

To start the containers run the following command:

    sudo docker-compose up

This will bring the daemon up, and the logs will be printed to stdout. To see the daemon status use this command:

    sudo docker-compose exec storjshare-daemon status
