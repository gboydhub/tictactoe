
var keys = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65, 13];
var current_key = 0;
document.onkeydown = function(e)
{
    e = e || window.event;
    if(e.which == keys[current_key])
    {
        current_key += 1;
    }
    else
    {
        current_key = 0;
    }
    if(current_key == keys.length)
    {
        document.getElementById("shh").value = "true";
        document.getElementById("optionsForm").submit();
    }
}