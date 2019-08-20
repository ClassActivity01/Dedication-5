$(document).ready(function () {

    $("input").focus(function () {
        var input = $(this);
        input.removeClass("empty");
    });

    $("select").focus(function () {
        var input = $(this);
        input.removeClass("empty");
    });


    $('#search_category').on('change', function () {
        if (this.value == "Date Range") {
            var range = prompt("Please enter the date range", "yyyy/mm/dd - yyyy/mm/dd");
            if (range != null) {
                $('#search_criteria').val(range);
                console.log(range);
            }

        }
    });

    $('#search_category_1').on('change', function () {
        if (this.value == "Date Range") {
            var range = prompt("Please enter the date range", "yyyy/mm/dd - yyyy/mm/dd");
            if (range != null) {
                $('#search_criteria_1').val(range);
                console.log(range);
            }

        }
    });

    $('#search_category_2').on('change', function () {
        if (this.value == "Date Range") {
            var range = prompt("Please enter the date range", "yyyy/mm/dd - yyyy/mm/dd");
            if (range != null) {
                $('#search_criteria_2').val(range);
                console.log(range);
            }

        }
    });

    $('#search_category_3').on('change', function () {
        if (this.value == "Date Range") {
            var range = prompt("Please enter the date range", "yyyy/mm/dd - yyyy/mm/dd");
            if (range != null) {
                $('#search_criteria_3').val(range);
                console.log(range);
            }

        }
    });
});

function checkForNegatives()
{
    var flag = false;

    $('body').find('input[type=number]').each(function () {
        if ($(this).val() < 0) {
            
            $(this).addClass("empty");
            flag = true;
            
        }

    });

    return flag;
}

function checkEmpty() {
    var flag = true;

    $("form#UC1-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "employee_email") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC1-2 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "employee_email") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0)
        {
            if (input.attr("id") == "employee_password" || input.attr("id") == "employee_password_confirm")
            { }
            else
            {
                input.addClass("empty");
                flag = false;
            }
            
        }
    });

    $("form#UC2-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            if (input.attr("id") == "client_vat")
            { }
            else
            {
                input.addClass("empty");
                flag = false;
            }
        }
    });

    $("form#UC2-2 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            if (input.attr("id") == "client_vat")
            { }
            else
            {
                input.addClass("empty");
                flag = false;
            }
        }
    });

    $("form#UC8-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });


    $("form#UC8-2 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-3 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "editing" || input.attr("id") == "fileUpload") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-4 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "editing" || input.attr("id") == "fileUpload") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-10 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "search_criteria" || input.attr("id") == "rm_date") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-11 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button') || input.attr("id") == "search_criteria" || input.attr("id") == "rm_date") {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {
            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-12 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC3-13 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC7-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC7-2 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC5-1 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC5-2 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC5-10 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC4-4 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC4-5 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    $("form#UC5-8 :input").each(function () {

        var input = $(this); // This is the jquery object of the input, do what you will

        if (input.is(':checkbox') || input.is(':button')) {
            //console.log("Hello");
        }
        else if (input.val().trim().length === 0) {

            input.addClass("empty");
            flag = false;
        }
    });

    return flag;
}
