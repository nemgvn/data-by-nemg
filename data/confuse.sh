
#!/bin/bash

TABLENAME="NemOSMain"

SYMBOL_DB_FILE="NemGSCR/Encryption/aNemOS.db"

STRING_SYMBOL_FILE="NemGSCR/Encryption/func.list"

HEAD_FILE="NemGSCR/CodeObfuscation.h"

createTable()

{

echo "create table $TABLENAME(src text,des text);" | sqlite3 $SYMBOL_DB_FILE

}

insertValue()

{

echo "insert into $TABLENAME values('$1','$2');" | sqlite3 $SYMBOL_DB_FILE

}

query()

{

echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE

}

randomString()

{

openssl rand -base64 64 | tr -cd 'a-zA-Z' | head -c 50

}

rm -f $SYMBOL_DB_FILE

rm -f $HEAD_FILE 

createTable

touch $HEAD_FILE

echo '#ifndef NemOS_CodeObfuscation_h

#define NemOS_CodeObfuscation_h' >> $HEAD_FILE 

echo "//confuse string at `date`" >> $HEAD_FILE 

cat "$STRING_SYMBOL_FILE" | while read -ra line;

do

if [[ ! -z "$line" ]]

then

random=`randomString`

echo $line $random

insertValue $line $random

echo "#define $line $random" >> $HEAD_FILE

fi

done

echo "#endif" >> $HEAD_FILE

sqlite3 $SYMBOL_DB_FILE .dump
