<?php

require_once 'includes/Kolachi.class.php';
session_start();
	if (isset($_POST['email'])) {
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());
		$query = "SELECT * FROM user WHERE u_email='".$_POST['email']."' AND u_pass='".$_POST['password']."'";
		$res = $mysqli->query($query);
		if ($res->num_rows > 0) {
			$_SESSION['isLoggedin'] = 1;
			header('Location: home.php');
		}
		else{
			echo "Incorrect UserId or Password";
		}
	}
?>
<html>
<head>
	<title>Kolachi Web Panel</title>
</head>
<link rel="stylesheet" type="text/css" href="Stylesheets/main.css">
<body>
	<div id="body" style="width:500px;">
		<div id="logo">
			<img src="Images/logo.png">
		</div>
		<div id="login">
			<form action="index.php" method="post">
				<table>
					<tr>
						<td><label for="username" style="font-size:12px;">Email:</label></td>
						<td><input type="text" name="email"></td>
					</tr>
					<tr>
						<td></td><td></td>
					</tr>
					<tr>
						<td><label for"password" style="font-size:12px;">Password:</label></td>
						<td><input type="password" name="password"></td>
					</tr>
					<tr>
						<td></td><td></td>
					</tr>
					<tr>
						<td><input type="submit" name="submit" value="Login"></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>