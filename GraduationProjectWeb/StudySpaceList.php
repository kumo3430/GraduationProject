<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];
$category_id = 1;

$TodoTitle = array();
$TodoIntroduction = array();
$StartDateTime = array();
$ReminderTime = array();
$repetition1Status = array();
$repetition2Status = array();
$repetition3Status = array();
$repetition4Status = array();

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

// $TodoSELSql = "SELECT * FROM Todo WHERE uid = '$uid' && category_id = '1';";
// $TodoSELSql = "SELECT * FROM Todo WHERE uid = '30' && category_id = '1';";
$TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN StudySpacedRepetition SSR ON T.id = SSR.todo_id WHERE T.uid = '30' && category_id = '1';";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $TodoTitle[] = $row['todoTitle'];
        $TodoIntroduction[] = $row['todoIntroduction'];
        $StartDateTime[] = $row['startDateTime'];
        $ReminderTime[] = $row['reminderTime'];
        $repetition1Status[] = $row['repetition1Status'];
        $repetition2Status[] = $row['repetition2Status'];
        $repetition3Status[] = $row['repetition3Status'];
        $repetition4Status[] = $row['repetition4Status'];
    }
    $userData = array(
        'userId' => $uid,
        'category_id' => $category_id,
        'todoTitle' => $TodoTitle,
        'todoIntroduction' => $TodoIntroduction,
        'startDateTime' => $StartDateTime,
        'reminderTime' => $ReminderTime,
        'repetition1Status' => $repetition1Status,
        'repetition2Status' => $repetition2Status,
        'repetition3Status' => $repetition3Status,
        'repetition4Status' => $repetition4Status,
        'message' => ""
    );
    echo json_encode($userData);
} else {
    $message = "no such Todo";
}

$conn->close();
?>