<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

$db_file = __DIR__ . "/lostlink.db";


try {
    $db = new PDO("sqlite:$db_file");// Connect to the database
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $db->exec("
        CREATE TABLE IF NOT EXISTS users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_name TEXT NOT NULL,
            user_email TEXT NOT NULL UNIQUE,
            user_phone TEXT NOT NULL DEFAULT '',
            user_password TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    ");

    

    $db->exec("
        CREATE TABLE IF NOT EXISTS items (
            item_id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            item_category TEXT NOT NULL,
            item_description TEXT NOT NULL,
            item_imagepath TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
            
        )
    ");

    $db->exec("
        CREATE TABLE IF NOT EXISTS reports (
            report_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            receive_id INTEGER DEFAULT NULL,
            report_title TEXT NOT NULL,
            report_type TEXT NOT NULL,
            report_location TEXT NOT NULL,
            report_date TEXT NOT NULL,
            report_status TEXT NOT NULL DEFAULT 'Unclaimed',
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(user_id),
            FOREIGN KEY (item_id) REFERENCES items(item_id),
            FOREIGN KEY (receive_id) REFERENCES users(user_id)
        )
    ");


} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}
?>