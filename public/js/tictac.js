function hideOptions(id)
{
    var opdiv = document.getElementById(`comp${id}_options`);
    opdiv.style.height = "0rem";
}

function showOptions(id)
{
    var opdiv = document.getElementById(`comp${id}_options`);
    opdiv.style.height = "4rem";
}