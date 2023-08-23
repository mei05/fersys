<?php
	require "conn.php";

    $thn = $_POST['thn'];
	$jan = $_POST['jan'];
    $feb = $_POST['feb'];
	$mar = $_POST['mar'];
	$apr = $_POST['apr'];
    $mei = $_POST['mei'];
	$jun = $_POST['jun'];
	$jul = $_POST['jul'];
    $agt = $_POST['agt'];
	$sep = $_POST['sep'];
	$okt = $_POST['okt'];
    $nov = $_POST['nov'];
    $des = $_POST['des'];
    $akurasi = $_POST['akurasi'];
    
    $result = mysqli_query($con, "INSERT INTO ch VALUE($thn, $jan, $feb, $mar, $apr, $mei,
								$jun, $jul, $agt, $sep, $okt, $nov, $des, '$akurasi')");
    
    if($result){
        echo json_encode([
            'message' => 'Data input successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to input'
        ]);
    }