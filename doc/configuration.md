Configuration
=============

config/database.yml
-------------------

Just like any other rails application. Example is in [config/database.yml.example](../config/database.yml.example)

config/config.yml
-----------------

Main config file of application. It contains constant information about invoice (e.g. company id and contacts) and elasticsearch address. Example is in [config/config.yml.example](../config/config.yml.example).

config/connectors/<config_name>.yml
-------------------------

Connectors to external databases. Should include config strings for them. Run 'rails g user_connector:install' to get sample one.

You can use multiple redmines if you want, just keep their names unique.
