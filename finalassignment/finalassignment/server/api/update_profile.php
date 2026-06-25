<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$user_id = $_POST['user_id'];

$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$phone = $_POST['phone'] ?? '';




if (empty($user_id) || empty($name) || empty($email) || empty($phone)) {
    echo json_encode([
        "success" => false,
        "message" => "All fields are required"
    ]);
    exit;
}

try {
    $sql = "UPDATE users 
            SET user_name = ?,
                user_email = ?,
                user_phone = ?
            WHERE user_id = ?";

    $stmt = $db->prepare($sql);
    $stmt->execute([
        $name,
        $email,
        $phone,
        $user_id
    ]);

        echo json_encode([
            "success" => true,
            "message" => "Profile updated successfully"
        ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Database error: " . $e->getMessage()
    ]);
    exit;
}
?>