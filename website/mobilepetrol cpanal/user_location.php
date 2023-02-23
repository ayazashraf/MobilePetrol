
<!--<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=places"></script>-->

<!DOCTYPE html>
<html>
<head>
  <title>Kolachi User Location</title>
</head>
<body>


<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places,visualization&v=3.exp"></script>


<div id="googleMap" style="width:500px;height:400px;border:1px solid black;"></div>

<script>
function success(position) {
  var latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
  var mapOptions = {
    zoom: 12,
    center: latlng,
    panControl: true,
	zoomControl: true,
	scaleControl: true,
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("googleMap"), mapOptions);

  var marker = new google.maps.Marker({
      position: latlng,
      map: map,
	  <?php if(!$_SESSION['user']){ ?>
	  icon: 'images/location.png',
	  <?php }else{ ?>
	  icon: '<?php echo $user_info['user_marker']; ?>',
	  <?php } ?>
	  animation:google.maps.Animation.BOUNCE,
      title:"You are here!"
  });
  // Add circle overlay and bind to marker
	var circle = new google.maps.Circle({
	  map: map,
	  radius: 3218.69,    // 2 miles in metres (1 mile = 1609.34 meters)
	  fillColor: '#666666'
	});
	circle.bindTo('center', marker, 'position');
	
}
function error(msg) {
	alert(msg);
  //var s = document.querySelector('#status');
//  s.innerHTML = typeof msg == 'string' ? msg : "failed";
//  s.className = 'fail';

  // console.log(arguments);
}
if(navigator.geolocation){
	navigator.geolocation.getCurrentPosition(success, error);
}else{
	alert("GPS Tracking not supported");
}

</script>


</body>
</html>
