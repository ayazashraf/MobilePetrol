<?php

require_once("../includes/MobilePetrol.class.php");
$MobilePetrol = new MobilePetrol();


$user_id=$_GET['user_id'];

$MobilePetrol->GetAddressBooks($user_id);

?>