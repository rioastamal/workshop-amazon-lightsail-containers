#!/bin/bash

realpath() {
    [[ $1 = /* ]] && {
        echo "$1"
        return 0
    }

    [[ "$1" = "." ]] && {
        echo "$PWD"
        return 0
    }

    echo "$PWD/${1#./}"
}

BASE_DIR=$( dirname "$0" )
ABS_DIR=$( realpath $BASE_DIR )
WORKSHOP_VERSION=2022-05-12

echo "$@" | grep '\-\-split-pages' > /dev/null && {
    [ -z "$SOURCE_FILE" ] && SOURCE_FILE="README.single-page.md"
    [ -z "$TOC_FILE" ] && TOC_FILE="README.md"
    [ -z "$MAX_PAGE" ] && {
      echo "Missing env MAX_PAGE." >&2
      exit 1
    }
    
    cd $ABS_DIR && \
    echo "Splitting into multiple pages..."
    for i in $( seq 0 $MAX_PAGE )
    do
      BEGIN=$(( $( sed -n "/\!-- begin step-$i -->/=" $SOURCE_FILE ) + 1 ))
      END=$( sed -n "/\!-- end step-$i -->/=" $SOURCE_FILE )
      NUMBER_OF_LINES=$(( $END - $BEGIN ))
      
      PREV_NUMBER=$(( $i - 1 ))
      NEXT_NUMBER=$(( $i + 1 ))
      
      PREV_LINK="STEP-${PREV_NUMBER}.md"
      NEXT_LINK="STEP-${NEXT_NUMBER}.md"
      INDEX_LINK=$TOC_FILE
      
      CURRENT_FILE=$ABS_DIR/STEP-$i.md
      
      [ $i -eq 0 ] && {
        PREV_LINK="STEP-${MAX_PAGE}.md"
        CURRENT_FILE=$ABS_DIR/$TOC_FILE
      }
      
      [ $i -eq 1 ] && {
        # No Step-0
        PREV_LINK=$INDEX_LINK
      }
      
      [ $i -eq $MAX_PAGE ] && {
        NEXT_LINK=$INDEX_LINK
      }
      
      echo "SEQ=$i BEGIN=$BEGIN END=$END NO_LINES=$NUMBER_OF_LINES"
      tail -n +$BEGIN $SOURCE_FILE | head -n $NUMBER_OF_LINES > $CURRENT_FILE
      sed -i '/\[\^back to top\]/d' $CURRENT_FILE
      
      cat <<EOF >> $CURRENT_FILE
<table border="0" style="width: 100%; display: table;"><tr><td><a href="${PREV_LINK}">&laquo; Sebelumnya</td><td align="center"><a href="$INDEX_LINK">Daftar Isi</a></td><td align="right"><a href="$NEXT_LINK">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: ${WORKSHOP_VERSION}  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
EOF
    done
    
    # Change #step-1 to STEP-1.md
    sed -i 's/#step-\([0-9]\+\)/STEP-\1\.md/g' $ABS_DIR/$TOC_FILE
}