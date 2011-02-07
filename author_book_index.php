<?php
  require_once('../../include/vern/commoncent285hcc/xml_helpers.php');
  require_once('../../include/vern/library/library.php');
  $pdo = connect();
  if (!$pdo) {
    die("Could not connect");
  }
  //echo "Connected\n";
  $sql = "select * from author_book_view";
  $results = $pdo->query($sql);
  $data = array();
  $data['rowname'] = 'author_book_rec';
  $data['filename'] = 'author_book.css';
  $dataArray = array();
  while ($row = $results->fetch(PDO::FETCH_ASSOC)) {
    $dataArray[] = $row;
  }
  $data['dataArray'] = $dataArray;
  writeCSSFile($data);
  showXML($data);
?>
