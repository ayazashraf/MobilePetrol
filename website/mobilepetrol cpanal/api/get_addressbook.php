<?php

require_once("../includes/MobilePetrol.class.php");
$MobilePetrol = new MobilePetrol();


$backup_id=$_GET['backup_id'];

$MobilePetrol->GetAddressBook($backup_id);

?>