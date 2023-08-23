<?php
	require "conn.php";

    // $id_kebun = $_POST['id_kebun'];
    // $id_pupuk = $_POST['id_pupuk'];
	$tanggal_selesai = $_POST['tanggal_selesai'];
    // $dosis = $_POST['dosis'];
    $status = $_POST['status'];
    $id = $_POST['id_pemupukan'];
        
    $result = mysqli_query($con, "update pemupukan set tanggal_selesai = '$tanggal_selesai', status='$status' where id_pemupukan='$id'");
        
    if($result){
        echo json_encode([
            'message' => 'Data edit successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to update'
        ]);
    }