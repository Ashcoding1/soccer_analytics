#!/bin/bash
rm -rvf broken_db && unzip -o archive.zip -d broken_db
echo "Unzipped archive downloaded from https://www.kaggle.com/datasets/hugomathien/soccer"
echo "Removing broken foreign key constraints and making names consistent"
sqlite3 broken_db/database.sqlite -echo < fix.sql && \
echo -n "Successfully fixed up db. Copying to backend/db.sqlite3..."
cp broken_db/database.sqlite backend/db.sqlite3
echo "done."
echo "Cleaning up..."
rm -rvf broken_db
echo "Success. Cleaned db available at:"
echo "./backend/db.sqlite3"
