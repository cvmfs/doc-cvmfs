function filtertable(filterbar_id, table_name) {
  var input, filter, table, tr, td, i, txtValue, show;

  input = document.getElementById(filterbar_id);
  filter = input.value.toUpperCase();
  table = document.getElementById(table_name);
  tr = table.getElementsByTagName("tr");

  // For each row: loop through all columns and hides the row that 
  // does not match the case-insensitive search query
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