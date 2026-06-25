<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$report_id = $_POST['report_id'] ?? '';
$user_id = $_POST['user_id'] ?? '';

if (empty($report_id) || empty($user_id)) {
    echo json_encode([
        "success" => "failed",
        "message" => "Report ID and User ID are required"
    ]);
    exit;
}

try {
    // Check if this report belongs to the logged-in user
    $checkSql = "SELECT item_id 
                 FROM reports 
                 WHERE report_id = ? 
                 AND user_id = ?";

    $checkStmt = $db->prepare($checkSql);
    $checkStmt->execute([
        $report_id,
        $user_id
    ]);
//take whole row data
    $report = $checkStmt->fetch(PDO::FETCH_ASSOC);

    if (!$report) {
        echo json_encode([
            "success" => false,
            "message" => "You can only delete your own report"
        ]);
        exit;
    }

    $item_id = $report['item_id'];

    // Start a transaction- run mutltiple queries delete report and delete item
    $db->beginTransaction();

    // Delete report first
    $deleteReportSql = "DELETE FROM reports 
                        WHERE report_id = ? 
                        AND user_id = ?";

    $deleteReportStmt = $db->prepare($deleteReportSql);
    $deleteReportStmt->execute([
        $report_id,
        $user_id
    ]);

    // Delete item also because each report has its own item
    $deleteItemSql = "DELETE FROM items
                      WHERE item_id = ?";

    $deleteItemStmt = $db->prepare($deleteItemSql);
    $deleteItemStmt->execute([
        $item_id
    ]);

    // save all db
    $db->commit();

    echo json_encode([
        "success" => true,
        "message" => "Report deleted successfully"
    ]);

} catch (PDOException $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }

    echo json_encode([
        "success" => false,
        "message" => "Delete failed: " . $e->getMessage()
    ]);
    exit;
}
?>