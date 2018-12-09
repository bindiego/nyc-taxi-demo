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

## Install Elastic Stack

Please go to  https://github.com/bindiego/local_services/tree/develop/elastic for more information

## 导入纽约出租车数据到Elasticsearh
如果大家对Elastic Stack的部署还有任何问题，可以参考 https://github.com/bindiego/local_services/tree/develop/elastic 这里就不做介绍了。

### 下载出租车数据
数据下载的位置定义在 `raw_data_urls.txt` 这个文件内，默认的是2016年10到12月的数据，这些数据比较有代表性，适合我们demo中要演示的一些内容。当然你也可以任意修改，去探索其他数据里的奥秘。只要简单运行 `download_raw_data.sh` 这个脚本就可以自动把这些数据文件下载到本地 `data` 的本地文件夹里了。

### 使用Logstash把数据加载到Elasticsearch
首先运行下面这个命令

```
./ls.sh deploy
```

现在你本地的Logstash和运行环境就都应该准备就绪了，现在需要修改 taxi.conf 这个文件底部输出到Elasticsearch的参数，主机地址、用户名和密码。然后运行如下命令来加载数据。

```
./ls.sh import
```

等待程序运行完毕，回到Kibana里建立一个index pattern名叫 'nyc-taxi-*' 就可以开始玩耍了 ：-）
