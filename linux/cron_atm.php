<?php
$conn = mysql_connect('localhost','sqladmin','9Qf2+kXrM@h9ZNhnL{Qnf');
$db = mysql_select_db('rcmsdata',$conn) or die("Please refresh this page!!");
date_default_timezone_set('Asia/Kolkata');
$trans_date=date('Y-m-d');
$totime=date('H:i:s'); 
$startTime = date("H:i:s",strtotime('-60 minutes',strtotime($totime)));
$start_date = $trans_date.' '.$startTime;
$end_date = $trans_date.' '.$totime;	

//Start
// Its for maintain the data for only 7 days
$previous_day = date("Y-m-d",strtotime('-7 days',strtotime($trans_date)));
$chk_query=mysql_query("SELECT * FROM rcms_sms_mail_console WHERE collection_date='".$previous_day."' ");
if(mysql_num_rows($chk_query) > 0)
{
	$execute=mysql_query("DELETE FROM rcms_sms_mail_console WHERE collection_date='".$previous_day."' ");
}
//End

		
$whr = " AND  collection_datetime between '".$start_date."' and '".$end_date."'"; 

// echo "SELECT trans_id,shop_id,cust_id,email_id,customer_name,shop_name,amount,sms_status,email_status,trans_no,shop_code,contact_no,service_type,location,ce_id,collection_date,collection_time FROM rcms_sms_mail_console WHERE status='Y' ".$whr;
// exit;
 $query=mysql_query("SELECT trans_id,shop_id,cust_id,email_id,customer_name,shop_name,amount,sms_status,email_status,trans_no,
 shop_code,contact_no,service_type,location,ce_id,collection_date,collection_time FROM rcms_sms_mail_console WHERE status='Y' ".$whr);

$trans = array();
if(mysql_num_rows($query) > 0)
{
while($dynamic=mysql_fetch_array($query)){
	$trans[$dynamic['trans_id']]['contact_no']=$dynamic['contact_no'];
	$trans[$dynamic['trans_id']]['sms_status']=$dynamic['sms_status'];
	$trans[$dynamic['trans_id']]['shop_code']=$dynamic['shop_code'];
	$trans[$dynamic['trans_id']]['collection_date']=$dynamic['collection_date'];
	$trans[$dynamic['trans_id']]['collection_time']=$dynamic['collection_time'];
	$trans[$dynamic['trans_id']]['shop_id']=$dynamic['shop_id'];
	$trans[$dynamic['trans_id']]['cust_id']=$dynamic['cust_id'];
	$trans[$dynamic['trans_id']]['ce_id']=$dynamic['ce_id'];
	$trans[$dynamic['trans_id']]['trans_id']=$dynamic['trans_id'];
	$trans[$dynamic['trans_id']]['email_id']=$dynamic['email_id'];
	$trans[$dynamic['trans_id']]['email_status']=$dynamic['email_status'];
	$trans[$dynamic['trans_id']]['cust_name']=$dynamic['customer_name'];
	$trans[$dynamic['trans_id']]['shop_name']=$dynamic['shop_name'];
	$trans[$dynamic['trans_id']]['service_type']=$dynamic['service_type'];
	$trans[$dynamic['trans_id']]['location']=$dynamic['location'];
	$trans[$dynamic['trans_id']]['amount']=$dynamic['amount'];
	$trans[$dynamic['trans_id']]['trans_no']=$dynamic['trans_no'];
}
}

mysql_close($conn);
// echo '<pre>';
// print_r($trans); die;
echo json_encode($trans,true); 

?>