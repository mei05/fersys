<?php

	require "conn.php";

	if($_SERVER['REQUEST_METHOD'] == "POST"){
		$data = array();

		$username = $_POST['username'];
		$email = $_POST['email'];
		$password = $_POST['password'];
		$created_at = date_create();
		$level = $_POST['level'];

		$cek = mysqli_query($con, "SELECT * FROM user WHERE username='$username' AND password='$password'");
		$cekData = mysqli_fetch_array($cek);
		$cek = mysqli_fetch_all($cek, MYSQLI_ASSOC);

		echo json_encode($cek);

		if(isset($cekData)){
			$data['status'] = 1;
			$data['msg'] = "Data Sudah Ada!";
			echo json_encode($data);
		}else{
			$query = mysqli_query($con, "INSERT INTO user VALUE(, '$username', '$email', '$password', '$created_at', '$level')");
		
			if(isset($query)){
				$data['status'] = 2;
				$data['msg'] = "Berhasil Di Inputkan";
				echo json_encode($data);
			}else{
				$data['status'] = 3;
				$data['msg'] = "Cannot Add Your Data!";
				echo json_encode($data);
			}
		}
	}
