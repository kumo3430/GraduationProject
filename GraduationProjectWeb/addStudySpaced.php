<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];
$category_id = 1;
$todoTitle = $data['title'];
$todoIntroduction = $data['description'];
$startDateTime = $data['nextReviewDate'];
$reminderTime = $data['nextReviewTime'];

$todo_id = "";
$repetition1Count = $data['First'];
$repetition2Count = $data['third'];
$repetition3Count = $data['seventh'];
$repetition4Count = $data['fourteenth'];

$servername = "localhost"; // 資料庫伺服器名稱
$user = "kumo"; // 資料庫使用者名稱
$pass = "coco3430"; // 資料庫使用者密碼
$dbname = "spaced"; // 資料庫名稱

// 建立與 MySQL 資料庫的連接
$conn = new mysqli($servername, $user, $pass, $dbname);
// 檢查連接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `startDateTime`, `reminderTime`) VALUES ('$uid', '$category_id','$todoTitle','$todoIntroduction','$startDateTime','$reminderTime')";
if ($conn->query($TodoSql) === TRUE) {
    $message = "User New Todo successfully" . '<br>';
} else {
    $message = $message . 'New Todo - Error: ' . $sql . '<br>';
    $conn->error;
}

$TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = '$uid' && `category_id` = '$category_id' && `todoTitle` = '$todoTitle' && `todoIntroduction` = '$todoIntroduction';";
// $TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = '30' && `category_id` = '1' && `todoTitle` = 'New' && `todoIntroduction` = 'New';";
$result = $conn->query($TodoIdSql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $todo_id = $row['id'];
        // echo "todo_id : " . $todo_id . '<br>';
    }
} else {
    $message = $message . "no such Todo" . '<br>';
}

$SpacedSql = "INSERT INTO `StudySpacedRepetition` (`todo_id`, `repetition1Count`, `repetition2Count`, `repetition3Count`, `repetition4Count`, `repetition1Status`, `repetition2Status`, `repetition3Status`, `repetition4Status`) VALUES ('$todo_id', '$repetition1Count','$repetition2Count','$repetition3Count','$repetition4Count', 0, 0, 0, 0)";
if ($conn->query($SpacedSql) === TRUE) {
    $message = $message . "User New StudySpaced successfully" . '<br>';
} else {
    $message = $message . 'New StudySpaced - Error: ' . $sql . '<br>' . $conn->error;
}

$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'startDateTime' => $startDateTime,
    'reminderTime' => $reminderTime,
    'todo_id' => $todo_id,
    'repetition1Count' => $repetition1Count,
    'repetition2Count' => $repetition2Count,
    'repetition3Count' => $repetition3Count,
    'repetition4Count' => $repetition4Count,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>