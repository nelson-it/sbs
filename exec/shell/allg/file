#!/bin/bash 

if [ ! "$shellallgfilesh" = "1" ]; then
    shellallgfilesh=1

    function find_template()
    {
       if [ -f "exec/local/system/templates/$2/$IMPL/${DISTRIB_ID,,}/$3" ]; then
         eval $1="exec/local/system/templates/$2/$IMPL/${DISTRIB_ID,,}/$3";
         return
       fi
       
       if [ -f "exec/local/system/templates/$2/$IMPL/${ID,,}/$3" ]; then
         eval $1="exec/local/system/templates/$2/$IMPL/${ID,,}/$3";
         return
       fi
       
       if [ -f "exec/system/templates/$2/$IMPL/${DISTRIB_ID,,}/$3" ]; then
         eval $1="exec/system/templates/$2/$IMPL/${DISTRIB_ID,,}/$3";
         return
       fi
       
       if [ -f "exec/system/templates/$2/$IMPL/${ID,,}/$3" ]; then
         eval $1="exec/system/templates/$2/$IMPL/${ID,,}/$3";
         return
       fi
       
       if [ -f "exec/local/system/templates/$2/$IMPL/$3" ]; then
         eval $1="exec/local/system/templates/$2/$IMPL/$3";
         return
       fi
       
       if [ -f "exec/system/templates/$2/$IMPL/$3" ]; then
         eval $1="exec/system/templates/$2/$IMPL/$3";
         return
       fi
       
       if [ -f "exec/local/system/templates/$2/${DISTRIB_ID,,}/$3" ]; then
         eval $1="exec/local/system/templates/$2/${DISTRIB_ID,,}/$3";
         return
       fi

       if [ -f "exec/local/system/templates/$2/${ID,,}/$3" ]; then
         eval $1="exec/local/system/templates/$2/${ID,,}/$3";
         return
       fi

       if [ -f "exec/system/templates/$2/${DISTRIB_ID,,}/$3" ]; then
         eval $1="exec/system/templates/$2/${DISTRIB_ID,,}/$3";
         return
       fi

       if [ -f "exec/system/templates/$2/${ID,,}/$3" ]; then
         eval $1="exec/system/templates/$2/${ID,,}/$3";
         return
       fi

       if [ -f "exec/local/system/templates/$2/$3" ]; then
         eval $1="exec/local/system/templates/$2/$3";
         return
       fi

       if [ -f "exec/system/templates/$2/$3" ]; then
         eval $1="exec/system/templates/$2/$3";
         return
       fi

       echo "File not found $2 $3" 1>&2 
       exit -1
    } 

    function find_script()
    {
       if [ -f "exec/local/system/shell/${DISTRIB_ID,,}/$1/$IMPL/$2" ]; then
        . exec/local/system/shell/${DISTRIB_ID,,}/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/local/system/shell/${ID,,}/$1/$IMPL/$2" ]; then
        . exec/local/system/shell/${ID,,}/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/local/system/shell/${DISTRIB_ID,,}/$1/$2" ]; then
         . exec/local/system/shell/${DISTRIB_ID,,}/$1/$2;
         return
       fi

       if [ -f "exec/local/system/shell/${ID,,}/$1/$2" ]; then
         . exec/local/system/shell/${ID,,}/$1/$2;
         return
       fi

       if [ -f "exec/local/system/shell/$1/$IMPL/$2" ]; then
         . exec/local/system/shell/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/local/system/shell/$1/$2" ]; then
         . exec/local/system/shell/$1/$2;
         return
       fi

       if [ -f "exec/system/shell/${DISTRIB_ID,,}/$1/$IMPL/$2" ]; then
         . exec/system/shell/${DISTRIB_ID,,}/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/system/shell/${ID,,}/$1/$IMPL/$2" ]; then
         . exec/system/shell/${ID,,}/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/system/shell/${DISTRIB_ID,,}/$1/$2" ]; then
         . exec/system/shell/${DISTRIB_ID,,}/$1/$2;
         return
       fi

       if [ -f "exec/system/shell/${ID,,}/$1/$2" ]; then
         . exec/system/shell/${ID,,}/$1/$2;
         return
       fi

       if [ -f "exec/system/shell/$1/$IMPL/$2" ]; then
         . exec/system/shell/$1/$IMPL/$2;
         return
       fi

       if [ -f "exec/system/shell/$1/$2" ]; then
         . exec/system/shell/$1/$2;
         return
       fi
       
       echo "File not found $1 $2" 1>&2 
       exit -1
    } 

fi