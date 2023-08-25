#!/bin/bash

usage() {
    echo "Usage: $0 [-m <apply|collect>] [-r <directory to search] [-f <mapfile to use>]"
}

#extend to allow the search string to be configured
while getopts "m::f::r:" opt; do
  case $opt in
    m)
        mode=${OPTARG}
        ((mode == "apply" || mode == "collect")) || usage
        ;;
    f)
        mapfile=${OPTARG}
        ;;
    r)
        repodirectory=${OPTARG}
        ;;
    \?)
        usage
        exit 1
        ;;
    :)
        usage
        exit 1
        ;;
  esac
done

ghname() 
{
    githubname=`echo $1 | sed 's/^.*-//' | sed 's/\/$//'`

    # echo -e "\tgithub username is $githubname"
}

addtomap()
{
    echo "$1 $2" >> $mapfile
}

collect()
{
    echo "starting collect mode"
    echo "change directory to ${repodirectory}"
    cd $repodirectory

    for f in */ ; do

        echo "Entering ${f}"

        cd ${f}
        local studentname=`grep -i "Author:" README.md  | \
        tr '[:upper:]' '[:lower:]'                      | \
        sed 's/^.*: //'                                 | \
        sed 's/ /-/'`
        
        if [ ${studentname} ] 
        then
            echo -e "\tStudent name was ${studentname}"
        
        fi

        ghname $f

        addtomap $githubname $studentname

        cd $repodirectory
        
    done
}

getstudentnamefrommap() 
{
    studentname=`grep $1 $mapfile | \
    sed 's/^.* //'`
}

apply()
{
    echo "starting collect mode"
    echo "change directory to ${repodirectory}"
    cd $repodirectory

    for f in */ ; do

        echo "Entering ${f}"

        ghname $f

        getstudentnamefrommap $githubname

        if [[ "$studentname" == "" ]]  
        then
            echo -e "\tno student name detected"
        else
            finalpath=`echo "$f$studentname" | sed 's/\//-/'`
            echo -e "\tmoving $f to $finalpath/"

            mv -i "$f" "$finalpath"

        fi

        

    done 

}



case $mode in
    apply)
        apply
        ;;
    collect)
        collect
        ;;
    *)
        usage
        exit 1
        ;;
esac