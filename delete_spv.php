<?php
	require "conn.php";

    $id = $_POST['id'];

    $result = mysqli_query($con, "delete from user where id=".$id);

    if($result){
        echo json_encode([
            'message' => 'Data delete successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to delete'
        ]);
    }