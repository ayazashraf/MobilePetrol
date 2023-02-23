<?php
require_once("config.inc.php");

class MobilePetrol
{
	
	function RegisterUser($username,$email,$password,$fname,$lname,$phoneno)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());
		//echo "asdas";


		$usersql = "INSERT INTO user(user_name,user_password,user_isactive) VALUES( '".$username."','".$password."',1)"; 
		$uresult = $mysqli->query($usersql);

		if($uresult)
		{
			
			//echo "in if condition";
			$sql1 = "SELECT user_id FROM user WHERE user_name = '".$username."' AND user_password = '".$password."'";
			$result1 = $mysqli->query($sql1);

			$urow = $result1->fetch_array(MYSQLI_ASSOC);

			$sql = "INSERT INTO userdetail(userdetail_firstname,userdetail_lastname,userdetail_email,userdetail_phone,user_id)
			 VALUES( '".$fname."','".$lname."','".$email."','".$phoneno."','".$urow['user_id']."')"; 

			$result = $mysqli->query($sql);

			if($result)
			{

			$sql = "INSERT INTO phonebook(phonebook_name,user_id)
					 VALUES( '".$username."','".$urow['user_id']."')"; 

			$iresult = $mysqli->query($sql);
			if($iresult)
			{

				$fsql = "SELECT phonebook_id FROM phonebook WHERE phonebook_name = '".$username."' AND user_id = '".$urow['user_id']."'";
				
				$fresult = $mysqli->query($fsql);
				$frow = $fresult->fetch_array(MYSQLI_ASSOC);
				//echo $fsql;
				$response = array( "status" => "ok", "user_id" => $urow['user_id'], "phonebook_id" => $frow['phonebook_id'] );

			}		

			}
			else 
			{

				$response = array( "status" => "error");	

			}

		}
		else{

			$response = array( "status" => "error");		
		
		}
	
			echo json_encode($response);
	}
		
		
		//colums name change karny hen

	function SaveAddressBook($tmpfname,$user_id)
	{

		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());
			
			

		$select = "SELECT COUNT( user_id ) as count FROM backup WHERE backuptype_id =1 AND user_id = '".$user_id."'";
		$loc_count	= $mysqli->query($select);
		$count = $loc_count->fetch_array(MYSQLI_ASSOC);
		$rowcount = $count['count'];


		//insert only 3 backups
		if($rowcount>2)
		{
				$select = "SELECT MIN(backup_id) as min, backup_file FROM backup WHERE backuptype_id =1 AND user_id = '".$user_id."'";
				$mres	= $mysqli->query($select);
				$mcount = $mres->fetch_array(MYSQLI_ASSOC);
				$min = $mcount['min'];

				$fsql = "SELECT backup_file FROM backup WHERE backup_id='".$min."'";
				$fres	= $mysqli->query($fsql);
				$fn = $fres->fetch_array(MYSQLI_ASSOC);
				$filepath = $fn['backup_file'];

				//echo "filepath delted:".$filepath;
				$del  = "DELETE FROM backup WHERE backup_id='".$min."'";
				$dres = $mysqli->query($del);

				if ($dres) {

					//echo "path deleted"."../".$filepath;
					unlink("../".$filepath);
				}
				
		}

			$date = date('d-m-Y H:i:s');

			$pos = strrpos($tmpfname, "/");
			$filename = substr($tmpfname, $pos);
			$filename = "addressbooks".$filename;

			$sql = "INSERT INTO backup(backup_datetime,backup_file,backuptype_id,user_id) 
			VALUES( '".$date."','".$filename."',1,'".$user_id."')";

			
			
				$result = $mysqli->query($sql);
				if($result)
				{
					$response = array( "status" => "ok");
				}
				else
				{

					$response = array( "status" => "error");

				}
				
				echo json_encode($response);

	}
		
	function RegisterDevice($devicename,$uuid,$user_id)
	{
	
			$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());

			$sql = "INSERT INTO device(d_uuid,d_name) VALUES( '".$uuid."','".$devicename."')";
			
			$result = $mysqli->query($sql);
				if($result)
				{
					$sql1 = "SELECT d_id FROM device WHERE d_name = '".$devicename."' AND d_uuid = '".$uuid."'";
					$result1 = $mysqli->query($sql1);
			
					$row = $result1->fetch_array(MYSQLI_ASSOC);
						$d_id = $row['d_id'];


					$insertuserdevice = "INSERT INTO userdevice(user_id,d_id) VALUES( '".$user_id."','".$d_id."')";
					$iresult = $mysqli->query($insertuserdevice);

					if($iresult)
					{
					//insert device user in user device table
						$sql2 = "SELECT ud_id FROM userdevice WHERE u_id = '".$user_id."' AND d_id = '".$d_id."'";
							$result3 = $mysqli->query($sql2);
			
						
							$row1 = $result3->fetch_array(MYSQLI_ASSOC);
							$ud_id = $row1['ud_id'];
							$response = array( "status" => "OK" , "ud_id" =>$ud_id);
						
			
					}
				}
				else
				{
						$response = array( "status" => "Error");		
					
				}
	
			echo json_encode($response);
	}
		
		
		
	// Set location from user device
		
	function InsertLocation($user_id,$lat,$long,$datetime)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());

		$select = "SELECT COUNT( user_id ) as count FROM backup WHERE backuptype_id =1 AND user_id = '".$user_id."'";
		$loc_count	= $mysqli->query($select);
		$count = $loc_count->fetch_array(MYSQLI_ASSOC);
		$rowcount = $count['count'];


		//insert only twenty locations
		if($rowcount>2)
		{
				$select = "SELECT MIN(backup_id) as min, backup_file FROM backup HERE backuptype_id =1 AND user_id = '".$user_id."'";
				$mres	= $mysqli->query($select);
				$mcount = $mres->fetch_array(MYSQLI_ASSOC);
				$min = $mcount['min'];
				$filepath = $mcount['backup_file'];
				$del  = "DELETE FROM backup WHERE backup_id='".$min."'";
				$dres = $mysqli->query($del);

				if ($dres) {

					unlink($filepath);
				}
				
		}
		

		$sql = "INSERT INTO location (ud_id,l_lat,l_long,l_datetime) VALUES( '".$udid."','".$lat."','".$long."','".$datetime."')"; 
			$result = $mysqli->query($sql);
			if($result)
			{
				$response = array( "status" => "OK");		
			}
			else{
				$response = array( "status" => "Error");		
			}

		echo json_encode($response);
	}
		
		
		
	//complete karni he ye service
				
	function GetAddressBook($backup_id)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());
		
		$sql = "SELECT backup_file FROM backup WHERE backup_id= '".$backup_id."'"; 

				$result = $mysqli->query($sql);
					
			if($result->num_rows > 0)
			{
					$row = $result->fetch_array(MYSQLI_ASSOC);
					$filepath = $row['backup_file'];

					$response = array( "status" => "ok", "fileurl"=>BASE_URL."/".$filepath);	


					// $handle = fopen("../".$filepath, "r");
					// $contents = fread($handle, filesize("../".$filepath));
					// fclose($handle);

					// $file = file_get_contents("../".$filepath);
					// $xml=simplexml_load_file("../".$filepath);					
			}
			else{
					$response = array( "status" => "error");	
			}
	
				echo json_encode($response);

	}
		
		


	function GetLocationforWebpanal($ud_id)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());
		
		$sql = "SELECT d_name,l_lat, l_long, l_datetime
				FROM location JOIN userdevice ON ( location.ud_id = userdevice.ud_id ) 
				JOIN device ON ( userdevice.d_id = device.d_id ) 
				WHERE userdevice.ud_id ='".$ud_id."' ORDER BY l_datetime DESC"; 

				$result = $mysqli->query($sql);
					
			if($result->num_rows > 0)
			{
				while($row = $result->fetch_array(MYSQLI_ASSOC))
				{
					$array[] = array(
						"devicename" => $row['d_name'], 
						"lat" => $row['l_lat'], 
						"long" => $row['l_long'], 
						"datetime" => $row['l_datetime'], 
						);
				}
				echo json_encode($array);

			}
			else{
					$response = array( "status" => "error");	
					echo json_encode($response);	
			}
	
				
	}




	function GetDevicesforWebpanal($userid)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());

		$sql1 = "SELECT ud_id,d_name FROM userdevice 
				JOIN device ON(userdevice.d_id = device.d_id)
				WHERE userdevice.u_id = '".$userid."'";
				
				$result1 = $mysqli->query($sql1);
			
			if($result1->num_rows > 0)
			{	
				while($row = $result1->fetch_array(MYSQLI_ASSOC)){

					$array[] = array(
					"userdeviceid" => $row['ud_id'], 
					"devicename" => $row['d_name'], 
					);

				}
				echo json_encode($array);
			
			}
			else{

				$response = array( "status" => "error");	
				echo json_encode($response);
			}
	
	}


			// Set location from user device
		
	function UserLogin($username,$pass)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());

		//$sql1 = "SELECT user_id FROM user WHERE user_name = '".$username."' AND user_password = '".$pass."'";

		$sql = "SELECT user.user_id as user_id ,userdetail_phone,userdetail_email,userdetail_lastname,userdetail_firstname FROM userdetail 
				JOIN user ON userdetail.user_id = user.user_id  WHERE user_name = '".$username."' AND user_password = '".$pass."'";
				
			
				$result1 = $mysqli->query($sql);

				$row = $result1->fetch_array(MYSQLI_ASSOC);

				$user_id = $row['user_id'];
				$userdetail_phone= $row['userdetail_phone'];
				$userdetail_email = $row['userdetail_email'];
				$userdetail_lastname = $row['userdetail_lastname'];
				$userdetail_firstname = $row['userdetail_firstname'];
				
			if($user_id)
			{
				$response = array( "status" => "ok" , "user_id" =>$user_id , "userdetail_phone" =>$userdetail_phone, 
					"userdetail_email" =>$userdetail_email, "userdetail_lastname" =>$userdetail_lastname, "userdetail_firstname" =>$userdetail_firstname);		
			}
			else{
				$response = array( "status" => "error");		
			}
	
	
		echo json_encode($response);

		
	}




	function GetAddressBooks($user_id)
	{
	
		$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME) or die("Couldn't Connect: " . mysqli_connect_error());

		$sql1 = "SELECT backup_id, backup_datetime FROM backup WHERE backuptype_id=1 AND user_id='".$user_id."'";
				
				$result1 = $mysqli->query($sql1);
			
			if($result1->num_rows > 0)
			{	
				while($row = $result1->fetch_array(MYSQLI_ASSOC)){

					$array[] = array(
					"backup_id" => $row['backup_id'], 
					"backup_datetime" => $row['backup_datetime'], 
					);

				}
				echo json_encode($array);
			
			}
			else{

				$response = array( );	
				echo json_encode($response);
			}
	
	}
}
?>			