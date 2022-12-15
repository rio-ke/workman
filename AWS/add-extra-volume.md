# Adding extra disk volume in aws instance


**Expand the Amazon EBS root volume of my Amazon EC2 Linux instance**

- With user name and password, sign in to your amazon web services console page;

- click `Elastic Block Store` panel

- go to Elastic Block Store click `Volumes`

**_ADD-VOLUME_**

* click default web server instance

* simply select "Actions" in the right corner.

* click `Modify volume`info 

![Volumes EC2 Management Console](https://user-images.githubusercontent.com/88568938/207834108-1936dba8-20d9-4f0b-aaf0-c98bbf7f0cae.png)

**_MODIFY-VOLUME_**

* to modify-volume information

* check volume details

* modify "Size (GiB)Info" in addition to the amount requested 150GiB

* then click modify 

![Modify volume EC2 Management Console](https://user-images.githubusercontent.com/88568938/207834118-2bd1b2ae-c1a0-48b8-aebf-5c05f576a2b0.png)

now check web-server instance root `size` changed

![Volumes EC2 Management Console](https://user-images.githubusercontent.com/88568938/207834139-e994f995-f7be-487d-89fe-4ac47f118535.png)

After adding volume in aws console page go to linux terminal and login linux instance


**_Terminal-work_**
