# Nagios Check for Reduxio Storage


Nagios (https://www.nagios.com/) is an IT infrastructure monitoring package. This document covers a method of using Reduxio to monitor Reduxio storage systems.

## Usage

The utility initiates an SSH session to the ReduxioCLI to conclude the system status, including a detailed status description.

In order to use the check utility, a reduxio `cfg` file should be created, for example:

```
define command {
        command_name reduxio_status
        command_line $USER1$/check_reduxio.pl --host $HOSTADDRESS$ --username $ARG1$ --password $ARG2$
}

define host {
        use                     linux-server
        host_name               hodor
        alias                   hodor
        address                 hodor-mgmt-address
}

define service {
        use                             generic-service   
        host_name                       hodor
        service_description             Reduxio Status
        check_command                   reduxio_status!rdxadmin!adminpassword
        check_interval                  60
}

```

The above example defines three Nagios objects:

1. `command` object which uses `check_reduxio.pl` utility as a command line. The command defines three arguments - host address which is passed by the Nagios infrastructure, and login credentials (username, password) that should be passed by a service.

2. `host` object representing a Reduxio storage system, including a unique name (`host_name`) and the host management address (`address`).

3. `service` object which includes the host_name and reference to the check_reduxio command with the host's ReduxioCLI username and password.

To define multiple Reduxio hosts, add multiple corresponding `host` and `service` objects.
