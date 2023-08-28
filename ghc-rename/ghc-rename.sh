#!/bin/bash

usage() {
    echo "Usage: $0 
    [-m <apply|collect>] 
    [-r <directory containing repos>] 
    [-f <mapfile to save or load from>]"
}

#TODO extend to allow the search string to be configured
while getopts "m::f::r::h:" opt; do
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
    h)
        repodirectory=${OPTARG}
        usage
        exit 0
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
    local githubname=`echo $1   | \
    # replace everything until the first '-' TODO: also remove that first hyphen!
    sed 's/^[^-]*//'              | \
    # Remove trailing slash
    sed 's/\/$//'`

    echo "$githubname"
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

        # get the line that should contain a name
        local studentname=`grep -i "Author:" README.md  | \
        # make lower case
        tr '[:upper:]' '[:lower:]'                      | \
        # remove everything until their name should begin
        sed 's/^.*: //'                                 | \
        # remove spaces and replace with '-'
        sed 's/ /-/'`
        
        if [ ${studentname} ] 
        then
            echo -e "\tStudent name was ${studentname}"
        else 
            echo -e "\tNo student name detected in $f" 1>&2
        fi

        local githubname=`ghname $f`

        addtomap $githubname $studentname

        cd $repodirectory
        
    done
}

# queries the file that was created in collect phase. $1 should be github username from ghname
getstudentnamefrommap() 
{
    # get the line that matches the github name. '--' because the github name could start with hyphen
    local studentname=`grep -- $1 $mapfile | \
    # remove everything until the first space (remove the github name)
    sed 's/^.* //'`

    #only left with the students name (or nothing!)
    echo "$studentname"
}



apply()
{
    echo "starting apply mode"
    echo "change directory to ${repodirectory}"
    cd $repodirectory

    for f in */ ; do

        echo "Entering ${f}"

        local githubname=`ghname $f`

        local studentname=`getstudentnamefrommap $githubname`

        if [[ "$studentname" == "" ]]  
        then
            echo -e "\tno student name detected for $f" 1>&2
        else
            finalpath=`echo "$f$studentname" | sed 's/\//-/'` # remove the trailing / from the directory name and replace with '-'
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