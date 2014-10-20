#!/usr/bin/env python

from scraper.scraper import get_feed, ItemsContainter
from bs4 import BeautifulSoup


def main():
    url = "http://www.rte.ie/news/rss/news-headlines.xml"
    feed = get_feed(url)
    soup = BeautifulSoup(feed)
    items = soup.findAll('item')
    items_container = ItemsContainter()
    for item in items:
        items_container.add_item(item)
    items_container.generate_report()


if __name__ == '__main__':
    main()
