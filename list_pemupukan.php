<?php 
	require "conn.php";
    // $connection = new mysqli("localhost","root","","latihan");
    $data       = mysqli_query($con, "select * from pemupukan ORDER BY id_pemupukan desc");
    $data       = mysqli_fetch_all($data, MYSQLI_ASSOC);

    echo json_encode($data);