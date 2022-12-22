<?php
include('dbconnection.php');							
include('NetyfishSmsVendor.php');
date_default_timezone_set("Asia/Calcutta");

$mclass = new sendSms();
$query=mysql_query("SELECT trans_id,shop_id,cust_id,email_id,customer_name,shop_name,amount,sms_status,email_status,trans_no,shop_code,contact_no,service_type,location,ce_id,collection_date,collection_time FROM rcms_sms_mail_console WHERE status='Y' ");

$trans = array();
$sms_arr = array();
$execute = array();
if(mysql_num_rows($query) > 0)
{
while($dynamic=mysql_fetch_array($query)){
//SMS START	
if($dynamic['contact_no'] !='' and $dynamic['contact_no'] !='0' and $dynamic['sms_status'] =='1'){
//Multiple contact no
$mobiles=explode(",",$dynamic['contact_no']);
foreach($mobiles as $mobile_no)
{
	
	$OtpShopname = !EMPTY($dynamic['shop_name'])?substr($dynamic['shop_name'],0,28):'-';

	//$OtpShopname = !EMPTY($dynamic['shop_name'])?$dynamic['shop_name']:"-";
	$OtpShopcode = !EMPTY($dynamic['shop_code'])?$dynamic['shop_code']:"-";
	$OtpLocation = !EMPTY($dynamic['location'])?$dynamic['location']:"-";
	$OtpAmount = !EMPTY($dynamic['amount'])?$dynamic['amount']:"-";
	$OtpDate = !EMPTY($dynamic['collection_date'])?$dynamic['collection_date']:"-";
	$OtpTime = !EMPTY($dynamic['collection_time'])?$dynamic['collection_time']:"-";
	$smsmessage="Dear Customer, Cash Collected from Point Name: ".trim($OtpShopname).", Point Code: ".trim($OtpShopcode).", Location: ".trim($OtpLocation).", Amount: ".trim($OtpAmount).", on Date:".$OtpDate.", Time: ".trim($OtpTime)." - Radiant.";	 
	

if($mobile_no!=""){ 

$response = $mclass->sendSmsToUser2($smsmessage, $mobile_no, "");  
mysql_query("UPDATE rcms_sms_mail_console SET sms_sent_status='".$response."' WHERE trans_id = '".$dynamic['trans_id']."' ");
//$sms_arr[$dynamic['trans_id']] = $response;
$sms_arr[$dynamic['trans_id']] = $dynamic['trans_id'];
}
}
}
 
//SMS END



//E-MAIL START	

if($dynamic['email_id'] !='' and $dynamic['email_id'] !='0' and $dynamic['email_status'] =='1'){
	$trans[$dynamic['trans_id']]['email_id']=$dynamic['email_id'];
	$trans[$dynamic['trans_id']]['cust_name']=$dynamic['customer_name'];
	$trans[$dynamic['trans_id']]['shop_name']=$dynamic['shop_name'];
	$trans[$dynamic['trans_id']]['service_type']=$dynamic['service_type'];
	$trans[$dynamic['trans_id']]['location']=$dynamic['location'];
	$trans[$dynamic['trans_id']]['amount']=$dynamic['amount'];
	$trans[$dynamic['trans_id']]['trans_no']=$dynamic['trans_no'];
} 
//E-MAIL END


$execute[$dynamic['trans_id']] = $dynamic['trans_id']; 
}
}







//if(!empty($sms_arr)){
//$sms_sent = implode("','",$sms_arr);
//mysql_query("UPDATE rcms_sms_mail_console SET sms_sent_status='Sent' WHERE trans_id IN('".$sms_sent."') ");
//}


if(!empty($trans)){
	
	//email start
	$jsonDataEncoded = json_encode( $trans );
    $ch = curl_init("http://emailsalert.com/rcmsemail/email_alert/NotificationForEmailAlert.php");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonDataEncoded );
    curl_setopt($ch, CURLOPT_HTTPHEADER, array( "Content-Type: application/json" ) ); 
    $result = curl_exec($ch);
    curl_close($ch);
	//ECHO 'HELLO'. $result;
	$email_arr = json_decode($result,true);	 

	if(!empty($email_arr)){
	$email_sent = implode("','",$email_arr);
	mysql_query("UPDATE rcms_sms_mail_console SET email_sent_status='Sent' WHERE trans_id IN('".$email_sent."') ");
    }
	//email end
	
}

if(!empty($execute)){
	$complete = implode("','",$execute);
	//ECHO "UPDATE rcms_sms_mail_console SET status='C' WHERE trans_id IN('".$complete."') "; DIE;
	mysql_query("UPDATE rcms_sms_mail_console SET status='C' WHERE trans_id IN('".$complete."') ");
}
mysql_close($conn);

?>