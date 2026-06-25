<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$report_id = $_POST['report_id'] ?? '';
$receive_id = $_POST['receive_id'] ?? '';

if (empty($report_id) || empty($receive_id)) {
    echo json_encode([
        "success" => false,
        "message" => "Report ID and receiver ID are required"
    ]);
    exit;
}

try {
    $stmt = $db->prepare("
        UPDATE reports
        SET receive_id = ?,
            report_status = 'Claimed'
        WHERE report_id = ?
    ");

    $stmt->execute([
        $receive_id,
        $report_id
    ]);

    echo json_encode([
        "success" => true,
        "message" => "Item claimed successfully"
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Claim failed: " . $e->getMessage()
    ]);
}
?>