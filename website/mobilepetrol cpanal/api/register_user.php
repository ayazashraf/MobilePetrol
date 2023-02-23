<?php

require_once("../includes/MobilePetrol.class.php");
$MobilePetrol = new MobilePetrol();


$username=$_POST['username'];
$email =$_POST['email'];
$password =$_POST['password'];
$fname =$_POST['fname'];
$lname =$_POST['lname'];
$phoneno =$_POST['phoneno'];

$MobilePetrol->RegisterUser($username,$email,$password,$fname,$lname,$phoneno);

?>