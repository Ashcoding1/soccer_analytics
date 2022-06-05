unzip -o archive.zip -d broken_db
echo "Unzipped archive downloaded from https://www.kaggle.com/datasets/hugomathien/soccer"
echo "Removing broken foreign key constraints from Team_Attributes and"
echo "Player_Attributes tables and renaming tables to plurals, snake_case..."
sqlite3 broken_db/database.sqlite < fix.sql && \
echo -n "Successfully fixed up db. Copying to backend/db.sqlite3..."
cp broken_db/database.sqlite backend/db.sqlite3
echo "done."
echo "Cleaning up..."
rm -rvf broken_db
echo "Success. Cleaned db available at:\n./backend/db.sqlite3"
