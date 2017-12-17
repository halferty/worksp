# -*- coding: utf-8 -*-
"""
Created on Wed Nov  8 21:32:20 2017

@author: Armani
"""
from bs4 import BeautifulSoup
import requests
import datetime 

def tp100(url):
    response = requests.get(url)
    #print (response.encoding)  
    response.encoding = 'gbk'
    soup = BeautifulSoup(response.text,'lxml')
    
    courts = soup.select('li > div.img > div.text > p.clearfix > a')
    regions = soup.select('li > div.img > div.text > p.clearfix > span.floatr')
    prices = soup.select('li > div.imgInfo > div.price')
    addresses = soup.select('li > div.imgInfo > p[class="address"] > a')
    hrefs = soup.select('li > div.img > a')
    
    for court, region, price, address, href in zip(courts, regions, prices, addresses, hrefs):
            data = {
                'court': court.string,
                'region': region.string,
                'price': str(price.get_text()).strip(),
                'address': str(address.get_text()).strip(),
                'type' : 'work_top 100',
                'time' : datetime.datetime.now().strftime('%Y-%m-%d'),
                'href': href['href']
            }
            print(data)

for page in range(1,10):
    url = 'http://newhouse.yz.fang.com/house/web/newhouse_sumall.php?page='+str(page)
    tp100(url)


#print(courts[0].string)
#print(regions[0].string)
#print(str(prices[0].get_text()).strip())
#print(str(addresses[0].get_text()).strip())
#print(hrefs[0]['href'])