# Zhihu

##16-6-24

####I think I should use `UIPageViewController` instead of `UINavigationController`


##16-6-24
###This demo is an imitation of the exist APP 知乎日报,and it is just used to test my ability.I will never use it in business way.

###So it should have such functions:

#####DATA:
1. downloading data from server 
2. since the data is written in Json,we can use `NSJSONSerialization` class to parse it.

#####INTERFACE:
1. a loading view (not done yet)
2. a main view (is an `UITableView` ,one day a section,today's is completed,but other days' are not)
3. a comment view (not done yet)
4. an article view (finished except the bottom bar)
5. a theme view (not done yet)

#####ERROR_HANDLING: (not done yet)
1. downloading
2. parsing
3. ...

#####ASYNCHONOROUS: (for not blocking the main queue,has been finished)
1.downloading
2.parsing


######The APIs are copied from izzyleung's [知乎日报 API 分析][https://github.com/izzyleung/ZhihuDailyPurify/wiki/知乎日报-API-分析]


