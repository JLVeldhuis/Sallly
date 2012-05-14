# developer says: dummy ruby script to check api calls. Will convert this to proper class and module once tried and tested

DATABASEDOTCOM_CLIENT_ID="5826664495915710786"
DATABASEDOTCOM_CLIENT_SECRET='3MVG9Y6d_Btp4xp6xNqHbQc1SUpIWPMmYJtJqCaexLP4ehbqAqcIa37Ks.id8qX.0W91om8W26s3FzXa.dm6s'

client = Databasedotcom::Client.new

# fetch client_id and client_secret
client.client_id
client.client_secret

# client authentication to acquire oAuth token

client.authenticate :username => "", :password => ""


