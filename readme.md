# nyc-taxi-demo
NYC Taxi demo with Elasticsearch and Machine Learning

## Download Taxi data
Go to http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml and download the CSV file for Oct-Dec 2016 (Yellow cabs). 

To make it easier, use the script `download_raw_data.sh` to download those months (relies on you having `raw_data_urls.txt` local as well)

Once the download completed, you should find the csv files under the 'data' folder.

## Use Logstash to import into Elasticsearch

Run the following command to get Logstash and it's runtime enviroment.

```
./ls.sh deploy
```

Change username and password in taxi.conf file in output section, then run the following command to load the data to targeting Elasticsearch.

```
./ls.sh import
```

Finally, go to Kibana, under Management create an index pattern called 'nyc-taxi-*'

## Import Kibana visualizations

In Kibana, Managmenet, Saved Objects, Import taxi.json file
