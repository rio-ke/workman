<?php 
include('dbconnection.php');							
$ch = curl_init();
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//LIVE IP
curl_setopt($ch, CURLOPT_URL, 'http://192.168.1.245/RCMS/ServiceForSmsEmailToAtmServer.php');
//HYDERABED IP
//curl_setopt($ch, CURLOPT_URL, 'http://192.168.4.245/RCMS/ServiceForSmsEmailToAtmServer.php');
$response = curl_exec($ch);
curl_close($ch);
$obj = json_decode($response,true);
//echo "raghu <pre>";
//PRINT_R($obj);DIE;

$total =0;
$executed =0;
if(!empty($obj)){
foreach($obj as $key=>$result){

$selQry=mysql_query("select trans_id from rcms_sms_mail_console where trans_id='".$key."'");

if(mysql_num_rows($selQry) == 0){	 
$query ="INSERT INTO rcms_sms_mail_console(trans_id,shop_id,cust_id,email_id,customer_name,shop_name,amount,sms_status,email_status,trans_no,shop_code,contact_no,service_type,location,ce_id,collection_date,collection_time,status)VALUES('".$result['trans_id']."','".$result['shop_id']."','".$result['cust_id']."','".mysql_real_escape_string($result['email_id'])."','".mysql_real_escape_string($result['cust_name'])."','".mysql_real_escape_string($result['shop_name'])."','".mysql_real_escape_string($result['amount'])."','".$result['sms_status']."','".$result['email_status']."','".$result['trans_no']."','".mysql_real_escape_string($result['shop_code'])."','".mysql_real_escape_string($result['contact_no'])."','".mysql_real_escape_string($result['service_type'])."','".mysql_real_escape_string($result['location'])."','".mysql_real_escape_string($result['ce_id'])."','".$result['collection_date']."','".mysql_real_escape_string($result['collection_time'])."','Y')";
//echo $query; die;
$aa=mysql_query($query);
if($aa){ $executed++; }
$total++;
}
}
}

mysql_close($conn);

echo	'Total Records - '.$total.' &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; Inserted Records - '.$executed;


include('SmsAndEmailSending2.php');							


?>
