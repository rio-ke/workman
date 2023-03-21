<?php
$con = mysqli_connect("192.168.8.15","username","Password@123","data-base");
for($i=0;$i<=100;$i++){
 $sql = "INSERT INTO `daily_collection_multi` (`id`, `TransId`, `PickupPointCode`, `PisHclNo`, `ClientCode`, `SlipNo`, `SlipImage`, `PickupAmount`, `2000`, `500`, `200`, `100`, `50`, `20`, `10`, `5`, `coins`, `remarks`, `PickupStatus`, `CreatedDate`, `CreatedBy`, `UpdatedDate`, `UpdatedBy`, `status`) VALUES
 (NULL, 'RADIANT261120220$i', 'senthile', 'WE2342', 'QWER', 'RAD2315542524', 'SESFSR4523424234.jpg', $i, 0, 0, 0, 0, 0, 0, 0, 0, $i, 'Cash Received', 'Completed', '2022-11-26 06:40:14', 'RAD-CE-HR-0889', '2022-11-26 12:11:57', 'RAD-CE-HR-0889', 'Y');";
 $query = mysqli_query($con,$sql);
 if($query){
  echo "success";echo "<br>";
 }else{
  echo "failed";echo "<br>";
 }
}

$sql_count = "select count(*) as total  from daily_collection_multi";
$query_co = mysqli_query($con,$sql_count);
$arr = mysqli_fetch_array($query_co);
echo $arr['total']; 
?>
