<?php

require_once("../includes/MobilePetrol.class.php");
$MobilePetrol = new MobilePetrol();


$email=$_POST['username'];
$pass = $_POST['pass'];

$MobilePetrol->UserLogin($email,$pass);

?>