<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$user_id = $_POST['user_id'] ?? '';

$report_title = $_POST['report_title'] ?? '';
$report_type = $_POST['report_type'] ?? '';
$report_location = $_POST['report_location'] ?? '';
$report_date = $_POST['report_date'] ?? '';

$report_status = $_POST['report_status'] ?? 'Unclaimed';

$item_name = $_POST['item_name'] ?? '';
$item_category = $_POST['item_category'] ?? '';
$item_description = $_POST['item_description'] ?? '';
$item_image = $_POST['item_image'] ?? '';

if (
    empty($user_id) ||
    empty($report_title) ||
    empty($report_type) ||
    empty($report_location) ||
    empty($item_name) ||
    empty($item_category) ||
    empty($item_description)
) {
    echo json_encode([
        "success" => false,
        "message" => "All fields are required"
    ]);
    exit;
}




try {

$upload_dir = __DIR__ . "/uploads/";

    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $image_name = "item_by_" . $user_id . "_" .$report_type . ".jpg";
    $image_path = "uploads/" . $image_name;
    $full_path = $upload_dir . $image_name;

    $decoded_image = base64_decode($item_image);
    file_put_contents($full_path, $decoded_image);

$db->beginTransaction();

    $item_stmt = $db->prepare("
        INSERT INTO items (
            item_name,
            item_category,
            item_description,
            item_imagepath
        ) VALUES (?, ?, ?, ?)
    ");

    $item_stmt->execute([
        $item_name,
        $item_category,
        $item_description,
        $image_path
    ]);

    $item_id = $db->lastInsertId();

    $report_stmt = $db->prepare("
        INSERT INTO reports (
            user_id,
            item_id,
            receive_id,
            report_title,
            report_type,
            report_location,
            report_date,
            report_status
            
        ) VALUES (?, ?,NULL, ?, ?, ?, ?, ?)
    ");

    $report_stmt->execute([
        $user_id,
        $item_id,
        $report_title,
        $report_type,
        $report_location,
        $report_date,
        $report_status,
        
    ]);

    $db->commit();

    echo json_encode([
        "success" => true,
        "message" => "Report submitted successfully"
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Submit report failed: " . $e->getMessage()
    ]);
}

?>