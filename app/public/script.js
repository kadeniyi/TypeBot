$(document).ready(function(){
	var iLastTime = 0;
	var iTime = 0;
	var iTotal = 0;
	var iKeys = 0; 
	var high = parseInt(document.getElementById('high').textContent);
	var fet;
	var fet2;	

	$('#t1').bind('copy paste cut',function(e) { 
		e.preventDefault(); //this line will help us to disable cut,copy,paste		
	});

    $('#button1').click(function(){

    	var labe = document.getElementById('lab').textContent;
    	
    	
    	if (labe == "Submit"){
    		iLastTime = 0;
		    iTime = 0;
		    iTotal = 0;
		    iKeys = 0;
    		
    		$( "#foo" ).submit();
    		$('#lab').text("Start Typing!");
    		$("#mlabel").load(location.href + " #mylabel");
    		$('textarea').val("");
    		$('.click').hide();
    		
    		var ch = parseInt(document.getElementById('CPM').textContent);
    	if (ch > high){
    		$("#hs1").fadeOut(5)
    		$("#hs1").load(location.href + " #hs");
    		$("#hs1").fadeIn(3000);
    		}

    		$('#CPM').text("0");
    		$('#WPM').text("0");

    	}else{
    			
    		$(function() { $('textarea').keyup(function(){checkSpeed();
    		fet = document.getElementById('CPM').textContent;
    		fet2 = document.getElementById('WPM').textContent;
			$('#bar').val(fet);
			$('#bar2').val(fet2);
    		});});


    		$('#result').hide();
    		$('#bar').val('0');
    		$('#lab').text("Submit");
    		$('.click').show();
    	}
    });

    	
			


	        	function checkSpeed() {
	                iTime = new Date().getTime();
	                if (iLastTime != 0) {
	                    iKeys++;
	                    iTotal += iTime - iLastTime;
	                    //iWords = $('textarea').val().split(/\s/).length;
	                    iWords = $('textarea').val().replace(/\s/g, "").length;
	                    $('#CPM').text(Math.round(iKeys / iTotal * 60000, 2));
	                    $('#WPM').text(Math.round(iWords / (5*iTotal) * 60000, 2));
	                }

                iLastTime = iTime;
            }
	            

	            


// Variable to hold request
var request;

// Bind to the submit event of our form
$("#foo").submit(function(event){

    // Abort any pending request
    if (request) {
        request.abort();
    }
    // setup some local variables
    var $form = $(this);

    // Let's select and cache all the fields
    var $inputs = $form.find("input, select, button, textarea");

    // Serialize the data in the form
    var serializedData = $form.serialize();

    // Let's disable the inputs for the duration of the Ajax request.
    // Note: we disable elements AFTER the form data has been serialized.
    // Disabled form elements will not be serialized.
    $inputs.prop("disabled", true);

    // Fire off the request to /form.php
    request = $.ajax({
        url: "/submit",
        type: "post",
        data: serializedData
    });

    // Callback handler that will be called on success
    request.done(function (response, textStatus, jqXHR){
    	//spinner.spin(target);
    	//document.getElementById('hs').display("none");
        // Log a message to the console
        console.log("Hooray, it worked!");
        $("#result").html(response);
    });

    // Callback handler that will be called on failure
    request.fail(function (jqXHR, textStatus, errorThrown){
        // Log the error to the console
        console.error(
            "The following error occurred: "+
            textStatus, errorThrown
        );
    });

    // Callback handler that will be called regardless
    // if the request failed or succeeded
    request.always(function () {
        // Reenable the inputs
        $inputs.prop("disabled", false);
    });

    // Prevent default posting of form
    event.preventDefault();
});









    });