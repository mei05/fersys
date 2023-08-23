<?php 
$connect = new mysqli("localhost","root","","sisawit_db_v1");
if($connect){
}else{
	echo "Connection Failed";
	exit();
}
 ?>