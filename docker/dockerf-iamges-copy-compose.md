488  mkdir -p test-qrcode
  489  ll
  490  chown datatx:datatx test-qrcode
  491  ll
  492  cd QRCode/
  493  ll
  494  cd ..
  495  cp -r QRCode/ /webdata/test-qrcode/
  496  ll
  497  cd QRCode/
  498  ls
  499  ll
  500  cd ../test-qrcode/
  501  ls
  502  cd QRCode/
  503  ll
  504  pwd
  505  mv ajax Classes dist plugins /webdata/test-qrcode/
  506  cd ..
  507  ll
  508  cd QRCode/
  509  ll
  510  pwd
  511  mv cashpickup.php changepassword.php check_con.php check_session.php CreateTransaction.php dbconnection.php db.php destroy-session.php excelTransListReport.php export_lastlogin.php footer.php get_data.php getLocationTest.php /webdata/test-qrcode/
  512  ll
  513  mv head.php home.php index.php initiatePickup.php login.php logout.php mainSidebar.php pickup.php process.php qr-code.png qr.jpg qr_scan_image.jpg RecentInitiation.php rightNav.php Roles.php sample.csv script.php slip.php test.php topheader.php updatePickup.php userManagement.php User.php ViewPickup.php /webdata/test-qrcode/
  514  cd ..
  515  ll
  516  rmdir QRCode
  517  cd QRCode/
  518  ll
  519  pwd
  520  cd ..
  521  pwd
  522  rm -rf QRCode
  523  ll
  524  cd
  525  docker -ps
  526  docker ps
  527  cd /home/admin/
  528  ll
  529  cd test-qrcode/
  530  vim docker-compose.yaml 
  531  cd /etc/nginx/conf.d/
  532  vim test-qr.scanslips.in.ssl.conf 
  533  nginx -t
  534  cd
  535  mysql -u root -p
  536  exit
  537  cd /home/admin/test-qrcode/
  538  ll
  539  docker-compose up -d
  540  docker ps
  541  systemctl restart nginx
  542  exit
  543  cd /webdata/test-qrcode/
  544  ll
  545  vim index.html
  546  ll
  547  56apple91$
  548  cd /webdata/
  549  ll
  550  mkdir -p mail-alert
  551  ll
  552  chown datatx:datatx mail-alert/
  553  ll
  554  cd idfc/
  555  ll
  556  cd ../mail-alert/
  557  vim index.php
  558  ll
  559  cd /home/admin/
  560  ll
  561  cd idfc/
  562  cat docker-compose.yml 
  563  cd ../mail-alert/
  564  vim docker-compose.yml
  565  cd ../test-qrcode/
  566  ll
  567  cat docker-compose.yaml 
  568  cd ../mail-alert/
  569  vim docker-compose.yml
  570  cd /webdata/
  571  ll
  572  cd /etc/nginx/conf.d/
  573  ll
  574  cat ldm.scanslips.in.ssl.conf > version: '3.2'
  575  networks:
  576    idfc-server:
  577  services:
  578   idfc-web:
  579      container_name: idfc-web
  580      hostname: idfc.scanslips.in
  581      image: rcms/db-amazon:v1
  582      restart: unless-stopped
  583      ports:
  584        - "8099:80"
  585      volumes:
  586        - /webdata/idfc:/var/www/html
  587      networks:
  588        - idfc-server
  589      labels:
  590        org.label-schema.group: "monitoring"
  591  ll
  592  cat idfc.scanslips.in.ssl.conf > mail-alert.scanslips.in.ssl.conf 
  593  cat mail-alert.scanslips.in.ssl.conf 
  594  vim  mail-alert.scanslips.in.ssl.conf 
  595  docker ps
  596  nginx -t
  597  exit
  598  cd /home/admin/
  599  cd mail-alert/
  600  ll
  601  docker-compose up -d
  602  vim docker-compose.yml 
  603  docker-compose up -d
  604  docker ps
  605  cd
  606  systemctl restart nginx
  607  cd /webdata/
  608  ll
  609  chmod 777 test-qrcode
  610  ll
  611  cd test-qrcode/
  612  ll
  613  chmod 777 login.php
  614  ll
  615  cd ../qr
  616  cd ../QRCode/
  617  ll
  618  cd ..
  619  ll
  620  chown -R datatx:datatx test-qrcode
  621  cd test-qrcode/
  622  ll
