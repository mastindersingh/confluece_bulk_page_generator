#!/bin/bash
color='\e[0;34m'
NC='\e[0m'

echo  -e "${color} Confluence content creator${NC}"

url=$(grep -Po '<(baseurl>)\K.*?(?=</\1)' config.xml)
user=$(grep -Po '<(user>)\K.*?(?=</\1)' config.xml)
pass=$(grep -Po '<(pass>)\K.*?(?=</\1)' config.xml)
number=$(grep -Po '<(totalOf>)\K.*?(?=</\1)' config.xml)
spaceKey=$(grep -Po '<(spaceKey>)\K.*?(?=</\1)' config.xml)
startFrom=$(grep -Po '<(startFrom>)\K.*?(?=</\1)' config.xml)
namePrefix=$(grep -Po '<(namePrefix>)\K.*?(?=</\1)' config.xml)
date=$(date +"%m-%d-%Y")

echo -e ${color} $url ${NC}
echo "$user"
 
for (( c=1; c<=$number; c++ ))
do
   
   title="\"title\":\"$namePrefix$c\""
   space="\"space\":{\"key\":\"$spaceKey\"}"
   
   echo -e ${color} $c {NC}

   curl -u $user:$pass \
   -X POST \
   -H 'Content-Type: application/json' \
   -d'{"type":"page",'$title','$space',"body":{"storage":{"value":"<p><ac:structured-macro ac:name=\"loremipsum\"/></p>","representation":"storage"}}}' "$url/rest/api/content/" \
   | python -mjson.tool >> $date.log

 echo -e ${color} $c Created ${NC}

done

echo -e ${color} Done!! ${NC}


