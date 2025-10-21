<?php
// api/register.php
header('Content-Type: application/json');

require_once '../config/database.php';

try {
    $database = new Database();
    $db = $database->getConnection();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents("php://input"), true);

        $full_name = trim($input['full_name'] ?? '');
        $email = trim($input['email'] ?? '');
        $username = trim($input['username'] ?? '');
        $password = trim($input['password'] ?? '');
        $role = trim($input['role'] ?? '');
        $phone = trim($input['phone'] ?? '');

        if (empty($full_name) || empty($email) || empty($username) || empty($password) || empty($role)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'All fields required']);
            exit;
        }

        $check = $db->prepare("SELECT user_id FROM users WHERE email = ?");
        $check->execute([$email]);
        if ($check->rowCount() > 0) {
            http_response_code(409);
            echo json_encode(['success' => false, 'message' => 'Email already registered']);
            exit;
        }

        $db->beginTransaction();

        $query = "INSERT INTO users (username, email, password, full_name, role, phone, status) 
                  VALUES (:username, :email, :password, :full_name, :role, :phone, 'active')";
        $stmt = $db->prepare($query);
        $stmt->execute([
            ':username' => $username,
            ':email' => $email,
            ':password' => $password,
            ':full_name' => $full_name,
            ':role' => $role,
            ':phone' => $phone
        ]);

        $user_id = $db->lastInsertId();

        if ($role === 'student') {
            $roll = 'STU' . time();
            $db->prepare("INSERT INTO students (user_id, roll_number, admission_date, status) 
                         VALUES (?, ?, CURDATE(), 'active')")->execute([$user_id, $roll]);
        } elseif ($role === 'teacher') {
            $emp = 'EMP' . time();
            $db->prepare("INSERT INTO teachers (user_id, employee_id, joining_date, status) 
                         VALUES (?, ?, CURDATE(), 'active')")->execute([$user_id, $emp]);
        } elseif ($role === 'parent') {
            $db->prepare("INSERT INTO parents (user_id, status) VALUES (?, 'active')")->execute([$user_id]);
        }

        $db->commit();
        echo json_encode(['success' => true, 'message' => 'Registration successful! Please login.']);
    }
} catch(Exception $e) {
    if (isset($db)) $db->rollBack();
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Registration failed: ' . $e->getMessage()]);
}
?>
