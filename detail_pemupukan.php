<?php 
	require "conn.php";

    $id = $_GET['id_pemupukan'];

    $data       = mysqli_query($con, "select pemupukan.*, kebun.id as id_kebun, kebun.kode_kebun as kode_kebun, 
                pupuk.nama_pupuk as nama_pupuk, pupuk.id_pupuk as id_pupuk 
                from pemupukan 
                INNER JOIN kebun on kebun.id = pemupukan.id_kebun
                INNER JOIN pupuk on pupuk.id_pupuk = pemupukan.id_pupuk
                where pemupukan.id_pemupukan=".$_GET['id_pemupukan']);
    $data       = mysqli_fetch_array($data, MYSQLI_ASSOC);

    echo json_encode($data);