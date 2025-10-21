<?php
// api/forgot_password.php
header('Content-Type: application/json');

require_once '../config/database.php';

try {
    $database = new Database();
    $db = $database->getConnection();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents("php://input"), true);
        $email = trim($input['email'] ?? '');
        $new_password = trim($input['new_password'] ?? '');

        if (empty($email) || empty($new_password)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Email and new password required']);
            exit;
        }

        $check = $db->prepare("SELECT user_id FROM users WHERE email = ?");
        $check->execute([$email]);

        if ($check->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Email not found']);
            exit;
        }

        $update = $db->prepare("UPDATE users SET password = ? WHERE email = ?");
        $update->execute([$new_password, $email]);

        echo json_encode(['success' => true, 'message' => 'Password reset successful! Please login.']);
    }
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
}
?>
