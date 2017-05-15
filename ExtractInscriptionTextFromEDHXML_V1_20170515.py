# coding: utf-8

from bs4 import BeautifulSoup

with open('xml/HD000001.xml') as file:
    soup = BeautifulSoup(file, 'html.parser')
    ab = soup.ab
    ab_text = ab.get_text()