<?php
require "conn.php";

$data       = mysqli_query($con, "select * from kebun where id=".$_GET['id']);
$data       = mysqli_fetch_array($data, MYSQLI_ASSOC);

echo json_encode($data);
