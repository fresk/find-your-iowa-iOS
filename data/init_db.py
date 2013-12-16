import os
import json
import sqlite3
import time


## SETUP MONGO CONNECTION
import pymongo
import bson
from bson.objectid import ObjectId
class ObjectIDFieldRenamer(pymongo.son_manipulator.SONManipulator):

    def transform_incoming(self, son, collection):
        if "id" in son:
            son["_id"] = ObjectId(son['id'])
        return son

    def transform_outgoing(self, son, collection):
        if "_id" in son:
            son['id'] = str(son['_id'])
        if self.will_copy():
            return bson.son.SON(son)
        return son

mongo_client = pymongo.MongoClient('findyouriowa.com', 27017)
db = mongo_client.find_your_iowa
manipulator = ObjectIDFieldRenamer()
pymongo.database.Database.add_son_manipulator(db, manipulator)
db.locations.ensure_index([('location', pymongo.GEOSPHERE)])



def init_db():
## CREATE SQLITE DB
    try:
        os.remove("locations.db")
    except:
        pass

    conn = sqlite3.connect('locations.db')
    c = conn.cursor()

    c.execute("""
    CREATE TABLE locations (
    id varchar PRIMARY KEY NOT NULL,
    lat double,
    lng double,
    name varchar,
    city varchar,
    images varchar,
    categories varchar,
    popularity float,
    last_update integer
    );
    """)

    c.execute("""
    CREATE TABLE location_categories(
        category_id varchar NOT NULL,
        location_id varchar NOT NULL,
        PRIMARY KEY (category_id, location_id)
    );
    """)



    ## CACHE IMPORTANT VALUES AND INSERT INTO SQLLITE
    for r in db.locations.find():
        r['last_update'] = int(time.time())
        r['popularity'] = 0.0
        #id, lat, lon, name, city, image_list, popularity, last_update

        row = [
            r['id'],
            r['location']['coordinates'][1], #lat
            r['location']['coordinates'][0], #lng
            r['name'],
            r['address']['city'],
            ",".join(r['images']),
            ",".join(r['category']),
            r['popularity'], #popularity,
            r['last_update']
        ]

        c.execute("INSERT INTO locations VALUES (?,?,?,?,?,?,?,?,?)", row)
        for cat in r['category']:
            c.execute("INSERT INTO location_categories VALUES (?,?)", [cat, r['id']] )

    conn.commit()
    c.close()


from PIL import Image, ImageOps
import urllib2
import urllib
import io
import md5
import posixpath
import requests
from StringIO import StringIO
import os

def fetch_image(img, r):
    print "fetching ", img

    hsh = md5.new(img.encode("utf-8")).hexdigest()
    outname = "img_cache/%s.png"%hsh
    if os.path.exists(outname):
        process_img(outname, r)
        return

    r = requests.get(img, stream=True)
    if r.status_code == 200:
        i = Image.open(StringIO(r.content))
        i.save(outname)



def render_list_item_image(r):
    if len(r['images'][0]) == 0:
        return

    #for img in r['images']:
    fetch_image(r['images'][0], r)


def process_img(fname, r):
    im = Image.open(fname)
    out = ImageOps.fit(im, (320,240), Image.ANTIALIAS)
    print "rendering thumnail for: %s" % fname
    out.save("img/%s.jpg" % r['id'], "jpeg")
    out2 = ImageOps.fit(im, (800,600), Image.ANTIALIAS)
    out2.save("img/%s-large.jpg" % r['id'], "jpeg")



def render_thumnails():
    for r in db.locations.find():
        render_list_item_image(r)


#render_thumnails()
init_db()
