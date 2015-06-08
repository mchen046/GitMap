#! /bin/bash/

#make temporary files that will assure us that no file of that name exists
temp_file="$(mktemp)"
temp_file2="$(mktemp)"
temp_file3="$(mktemp)"

#create file to get all branch names
git branch > $temp_file	

#filter out the branch we are currently in
cat $temp_file | grep '\*' > $temp_file2
currBranch=`cat $temp_file2 | awk '{print $2;}'`

#find how many times we need to loop, so how many branches there are
branches=`wc -l $temp_file | awk '{print $1;}'`

echo $branches
echo $currBranch
#this will let us traverse all our branches as if they were in a vector of string
count=1
changed=0
fileEnd="Branch"
while [ $count -le $branches ]
do
	sed -n ''$count'p' < $temp_file | awk '{print $1;}' > $temp_file3
	atBranch=`cat $temp_file3`
	totalBranch=$atBranch$fileEnd
	if [ "$atBranch" != "*" ]
		then
			echo "branch changed"
			git checkout $atBranch
			((changed++))
		else
			echo "not changed"
			totalBranch=$currBranch$fileEnd
	fi
	git log > $totalBranch
	((count++))
done
if [ $changed -gt 0 ]
	then
		git checkout $currBranch
		lastFile=$currBranch$fileEnd
		git log > $lastFile
fi
rm $temp_file
rm $temp_file2
rm $temp_file3
#cat masterBranch | sed "s/commit.*//g" | sed "s/Merge:.*//g" | sed 's/<.*>//g' | sed '/^\s*$/d'

echo "Finished Script"
