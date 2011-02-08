<?php
  require_once('../../include/vern/commoncent285hcc/html_helpers.php');
  require_once('../../include/vern/library/library.php');
  $pdo = connect();
  if (!$pdo) {
    die("Could not connect");
  }
  //echo "Connected\n";
  $valid = FALSE;
  
  if (count($_POST) > 0) {
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    $sql = "select get_id(:usr,:pass) as id";
    $statement = $pdo->prepare($sql);
    $statement->execute(array(':usr' => $user,
      ':pass' => $pass));
    $row = $statement->fetch();
    $id = $row['id'];
    if ($id > 0) {
      $valid = TRUE;
    }
  }
  
  if (empty($_POST['pass']) || empty($_POST['user']) || $valid == FALSE) {
    echo "<html>\n  <body>\n";
    echo "    <form action=\"login.php\" method=\"post\">\n";
    $data['prompt'] = 'Username: ';
    $data['name'] = 'user';
    echo makeTextBox($data);
    $data['prompt'] = 'Password: ';
    $data['name'] = 'pass';
    echo makePassword($data);
    echo "      <br /><br />\n";
    echo "      <input type=\"submit\" value=\"Submit\">\n";
    echo "    </form>\n";
    echo "  </body>\n</html>\n";
  }
  else {
    echo "$id";
  }
?>
