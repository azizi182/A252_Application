<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$search = $_GET['search'] ?? '';
$category = $_GET['category'] ?? '';
$report_type = $_GET['report_type'] ?? '';
$report_status = $_GET['report_status'] ?? '';


try{ $sql = "SELECT 
            reports.report_id,
            reports.report_title,
            reports.report_type,
            reports.report_location,
            reports.report_date,
            reports.report_status,
            reports.created_at,

            items.item_id,
            items.item_name,
            items.item_category,
            items.item_description,
            items.item_imagepath,

            giver.user_id AS user_id,
            giver.user_name AS user_name,
            giver.user_email AS user_email,
            giver.user_phone AS user_phone,


            receiver.user_id AS receiver_id,
            receiver.user_name AS receiver_name,
            receiver.user_email AS receiver_email,
            receiver.user_phone AS receiver_phone

        FROM reports
        INNER JOIN items ON reports.item_id = items.item_id
        INNER JOIN users AS giver ON reports.user_id = giver.user_id
        LEFT JOIN users AS receiver ON reports.receive_id = receiver.user_id
        WHERE 1 = 1
    ";

if (!empty($search)) {
    $sql .= " AND (reports.report_title LIKE '%$search%'
    OR items.item_name LIKE '%$search%'
    OR reports.report_location LIKE '%$search%'
    OR giver.user_name LIKE '%$search%')";
}
if (!empty($category) && $category != "All") {
    $sql .= " AND items.item_category = '$category'";
}
if (!empty($report_type) && $report_type != "All") {
    $sql .= " AND reports.report_type = '$report_type'";
}

if (!empty($report_status) && $report_status != "All") {
    $sql .= " AND reports.report_status = '$report_status'";
}

$stmt = $db->prepare($sql);
$stmt->execute();
$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "success" => true,
    "reports" => $reports
]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}

?>