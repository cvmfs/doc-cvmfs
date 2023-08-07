function searchtable(searchbar_id, table_to_search) {
// Declare variables
var input, filter, table, tr, td, i, txtValue, show;
input = document.getElementById(searchbar_id);
filter = input.value.toUpperCase();
table = document.getElementById(table_to_search);
tr = table.getElementsByTagName("tr");
// Loop through all table rows, and hide those who don't match the search query
for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[0];
    show = "none";
    if (td) {
    for (j = 0; j < tr[i].getElementsByTagName("td").length; j++) {
        column = tr[i].getElementsByTagName("td")[j];
        txtValue = column.textContent || column.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
        show = "";
        }
    }
    tr[i].style.display = show;
    }
}
}