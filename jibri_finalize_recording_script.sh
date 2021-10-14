#!/bin/bash

# The script extracts the path/filename and emails, then send an recording URL Link to jibri parcipant EMAIL
# Prosody should already been configured on Jitsi Meet to send participant's email to metadata.json file
# You should install JQ, MSMTP and NGINX/APACHE on Jibri VM.

# This will storage the recording path 
RECORDINGS_DIR=$1
HTTP_SERVER=recording.domain.com

echo "$RECORDINGS_DIR" > /tmp/jibri.out


# Renaming/Normalizing recording name to fix room characters names issues
cd $1
for file in find . -type f -name "*.mp4"
do
dt=`date +%Y-%m-%d-%T`
newfilename="recording_$dt.mp4"
mv $file $newfilename
done


# Install NGINX/Apache and point it to jibri recording root directory. 
# This will create Recording URL path to be sent via email.
jibri_path=$(cat /tmp/jibri.out)"/*mp4"
echo "$jibri_path" > /tmp/jibri_path.out
ls -l $jibri_path > /tmp/jibri_path.out
jibri_path=$(cat /tmp/jibri_path.out)
jibri_url_path="http://"$HTTP_SERVER$(echo $jibri_path | awk '{ print $9 } ' | cut -c 16-) # You should adjust "cut" according to your settings.
echo "$jibri_url_path" > /tmp/jibri_url_path.out


# Install JQ linux command --- apt install jq  -------
# This will retrieve all the participants emails from metadata.json JSON file
emails=$(cat $1/metadata.json|jq -r '.participants[].user.id | select( . != null )')
echo "$emails" > /tmp/jibri_email.out


# Then send an email to all recording participants. 
# You should have MSMTP already installed and configured(SMTP credentials).

while IFS= read -r email; do

message="To: $email\nSubject: Download Recording Link: $jibri_url_path\n\n."
echo -e "$message" > /tmp/jibri_send_email.out
echo -e "$message" | msmtp -d  $email >> /tmp/jibri_send_email.log

done < /tmp/jibri_email.out

exit 0
