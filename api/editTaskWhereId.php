<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];
		$editDataTime = $_GET['editDataTime'];
		$images = $_GET['images'];
		$myrequire = $_GET['myrequire'];
		$detailRequire = $_GET['detailRequire'];
		$gender = $_GET['gender'];
			
		
		
		
							
		$sql = "UPDATE `task` SET `editDataTime` = '$editDataTime', `images` = '$images', `myrequire` = '$myrequire', `detailRequire` = '$detailRequire', `gender` = '$gender', `status` = 'true' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}

	mysqli_close($link);
?>