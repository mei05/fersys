<?php
require "conn.php";

$data       = mysqli_query($con, "SELECT * FROM ch WHERE thn IN (SELECT MAX(thn) FROM ch);");
$data       = mysqli_fetch_array($data, MYSQLI_ASSOC);

echo json_encode($data);