<?php 
	require "conn.php";

    $data       = mysqli_query($con, "select * from ch where thn=".$_GET['thn']);
    $data       = mysqli_fetch_array($data, MYSQLI_ASSOC);

    echo json_encode($data);