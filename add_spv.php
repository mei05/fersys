<?php
	require "conn.php";

    $username = $_POST['username'];
	$email = $_POST['email'];
    $password = $_POST['password'];
    $created_at = date('d-m-Y');
    $level = 'spv';
    
    $result = mysqli_query($con, "INSERT INTO user VALUE(null, '$username', '$email', '$password', '$created_at', '$level')");
    
    if($result){
        echo json_encode([
            'message' => 'Data input successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to input'
        ]);
    }