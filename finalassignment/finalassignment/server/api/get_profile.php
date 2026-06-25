<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$user_id = $_GET['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode([
        "success" => false,
        "message" => "User ID is required"
    ]);
    exit;
}

try {
    $sql = "SELECT *
            FROM users
            WHERE user_id = '$user_id'
            LIMIT 1";

    $stmt = $db->prepare($sql);
    $stmt->execute();

    $user = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if ($user) {
        echo json_encode([
            "success" => true,
            "data" => $user
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "User not found"
        ]);
    }

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Database error: " . $e->getMessage()
    ]);
    exit;
}
?>