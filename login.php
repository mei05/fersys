<?php 
// include 'conn.php';
// $db = mysqli_connect('localhost','root','','sisawit_db_v1');
// $email = $_POST['email'];
// $password = $_POST['password'];
// $sql="SELECT * FROM user WHERE email='".$email."' AND password='".$password."'";

// $result=mysqli_query($db,$sql);
// $count = mysqli_num_rows($result);

// if ($count == 1){
//     echo json_decode("Success");
// }
// else{
//     echo json_decode("Error");
// }
    require "conn.php";

    if($_SERVER['REQUEST_METHOD'] == "POST"){
        $data = array();

        $email = $_POST['email'];
        $password = $_POST['password'];

        $query = mysqli_query($con, "SELECT * FROM user WHERE email='$email' AND password='$password'");
        $cek = mysqli_fetch_array($query);

        if(isset($cek) && $cek != null){
            $data['msg'] = "DATA ADA";
            $data['level'] = $cek['level'];
            $data['email'] = $cek['email'];
            echo json_encode($data);
        }else{
            $data['msg'] = "DATA TIDAK ADA";
            echo json_encode($data);
        }
    }
?>
