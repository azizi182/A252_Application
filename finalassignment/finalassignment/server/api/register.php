<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require_once 'db.php';

$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$phone = $_POST['phone'] ?? '';

if (empty($name) || empty($email) || empty($password)) {
    echo json_encode([
        "success" => false,
        "message" => "All fields are required"
    ]);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid email format"
    ]);
    exit;
}

if (!preg_match('/^[0-9+\-\s]{8,20}$/', $phone)) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid phone number format"
    ]);
    exit;
}


try {
    $check = $db->prepare("SELECT * FROM users WHERE user_email = ? LIMIT 1");
    $check->execute([$email]);

    if ($check->fetch()) {
        echo json_encode([
            "success" => false,
            "message" => "Email already registered"
        ]);
        exit;
    }

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    $stmt = $db->prepare("
        INSERT INTO users (user_name, user_email, user_password, user_phone)
        VALUES (?, ?, ?, ?)
    ");

    $stmt->execute([$name, $email, $hashedPassword, $phone]);

    echo json_encode([
        "success" => true,
        "message" => "Registration successful"
    ]);
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Registration failed: " . $e->getMessage()
    ]);
}

?>