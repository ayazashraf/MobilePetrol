<?php

require_once("../includes/MobilePetrol.class.php");
$MobilePetrol = new MobilePetrol();

$body = $_POST['addressbook'];
$user_id = $_POST['user_id'];
$tmpfname = tempnam("../addressbooks", "ab");
$handle = fopen($tmpfname.".plist", "w");

$saveddata = fwrite($handle, $body);
fclose($handle);

// do here something
//unlink($tmpfname);
if($saveddata>0)
	$MobilePetrol->SaveAddressBook($tmpfname.".plist",$user_id);

?>