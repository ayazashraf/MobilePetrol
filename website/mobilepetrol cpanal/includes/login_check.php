<?php
if (isset($_GET['lg'])) {
	unset($_SESSION['isLoggedin']);
	header('Location: index.php');
}
if (!isset($_SESSION['isLoggedin'])) {
	header('Location: index.php?errmsg=11');
}
?>