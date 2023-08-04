(cvmfs_test_title)=
# Another MD Testfile

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

(md_test2_label)=
## Label In Other Markdown File
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

(md_test2_label2)=
My text-only label 

## Search a table

Modified example from [W3Schools](https://www.w3schools.com/howto/howto_js_filter_table.asp) combined with sphinx,
and added that all columns are searched for hit, not just the first one.
Javascript is directly embedded in this page.

<script>
function myFunction() {
  // Declare variables
  var input, filter, table, tr, td, i, txtValue, show;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("mytable");
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
</script>

<!-- <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.."> -->

<p>
<div class="wrapper">
  <form action="">
    <input class="description" type="text" id="myInput" onkeyup="myFunction()" placeholder="Search..." title="Type in anything">
    <button type="button" class="btn" onclick="document.getElementById('myInput').value = null; myFunction();"><span>&times;</span></button>
  </form>
</div>	
</p>

:::{table}
  :name: myTable
  | Name                | Country |
  | ------------------- | ------- |
  | Alfreds Futterkiste | Germany |
  | asfasdf             | Sweden  |
  | Island              | UKss     |
  | Konasd              | Germany |
:::

:::{note}
  The name in table `:name: myTable` will be transformed into lower-case and can be accessed in
  js with `document.getElementById("mytable");`
:::