# jibri_finalize_recording_script
This is a bash script for sending an email with conference recording URL link.

The concept is quite simple. Jibri saves conference recording locally and participants can retrieve it by acessing an URL link sent to their email box;

Requisites on Jibri Server:

1-Install Nginx/Apache and point it to conference recording directory;
2-Install JQ to extract email from Metatada.json file;
3-Install and configure MSMTP to send email

Requisites on Jitsi Meet Server:

1-Configure Prosody to send partipant email on metadata.json

Requisites on Conference Meet Front End:

1-Participants should set up their emails on Profiles, so they are able to receive emails from Jibri at the end of the recording.

