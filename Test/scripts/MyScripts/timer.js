
/*window.setDeadline = function(action_cookie)
{
    // if there's a cookie with the name myClock, use that value as the deadline
    if (action_cookie == "new_set")
    {
        // create deadline 10 minutes from now
        var timeInMinutes = 10;
        var currentTime = Date.parse(new Date());
        var deadline = new Date(currentTime + timeInMinutes * 60 * 1000);

        //console.log("setting cookie");
        delete_cookie("myClock");
        // store deadline in cookie for future reference
        document.cookie = 'myClock=' + deadline + '; path=/;';

        return deadline;
    }
    else if (document.cookie && document.cookie.match('myClock')) {
        // get deadline value from cookie
        var deadline = document.cookie.match(/(^|;)myClock=([^;]+)/)[2];

        //console.log("getting cookie");

        return deadline;
    }

        // otherwise, set a deadline 10 minutes from now and 
        // save it in a cookie with that name
    else {
        // create deadline 10 minutes from now
        var timeInMinutes = 10;
        var currentTime = Date.parse(new Date());
        var deadline = new Date(currentTime + timeInMinutes * 60 * 1000);

        //console.log("setting cookie");

        // store deadline in cookie for future reference
        document.cookie = 'myClock=' + deadline + '; path=/;';

        return deadline;
    }
}*/

function delete_cookie(name) {
    document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}





function getTimeRemaining(endtime) {
    var t = Date.parse(endtime) - Date.parse(new Date());
    var seconds = Math.floor((t / 1000) % 60);
    var minutes = Math.floor((t / 1000 / 60) % 60);
    var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
    var days = Math.floor(t / (1000 * 60 * 60 * 24));
    return {
        'total': t,
        'days': days,
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds
    };
}

var timer = false;

function initializeClock(endtime) {

    function updateClock() {
        var t = getTimeRemaining(endtime)
        if(t.minutes < 10)
            $('#minutes').html('0' + t.minutes).slice(-2);
        else
            $('#minutes').html(t.minutes).slice(-2);

        if (t.seconds < 10)
            $('#seconds').html('0' + t.seconds).slice(-2);
        else
            $('#seconds').html(t.seconds).slice(-2);

        if (t.total <= 0) {
            clearInterval(timer);
        }
    }

    if (timer == false) {
        starttimer();
    }
    else {

        pausetimer();
        starttimer();
    }

    function starttimer() {
        timer = setInterval(updateClock, 1000);
    }

    function pausetimer() {
        clearTimeout(timer);
        timer = false;
    }
}



