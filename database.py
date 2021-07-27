import configparser
import os

# # Set environment variables
# os.environ['API_USER'] = 'username'
# os.environ['API_PASSWORD'] = 'secret'

# Get environment variables
USER = os.getenv('user') or 'root'
PASSWORD = os.environ.get('password') or 'toor'
DBNAME = os.environ.get('dbname') or 'omeka'
HOST = os.environ.get('host') or 'omeka-mysql'
PORT = os.environ.get('port') or '3306'


config = configparser.ConfigParser()

config.add_section('db');
config.set('db','user', USER)
config.set('db','password',PASSWORD)
config.set('db','dbname', DBNAME)
config.set('db','host', HOST)
config.set('db','port',PORT)

# /var/www/html/config/database.ini
with open('./config/database.ini', 'w') as cfgfile:
  config.write(cfgfile)