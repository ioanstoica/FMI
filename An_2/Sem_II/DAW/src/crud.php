<?php
// Connect to the database
require_once "db_connect.php";
$conn = db_connect();

// Create function
function createUser($user, $email, $password)
{
    global $conn;
    $sql = "INSERT INTO users (user, email, password) VALUES ('$user', '$email', '$password')";
    $result = mysqli_query($conn, $sql);
    return $result;
}

// Read function
function readUsers()
{
    global $conn;
    $sql = "SELECT * FROM users";
    $result = mysqli_query($conn, $sql);
    return $result;
}

// Update function
function updateUser($id, $user, $email, $password)
{
    global $conn;
    $sql = "UPDATE users SET user='$user', email='$email', password='$password' WHERE id=$id";
    $result = mysqli_query($conn, $sql);
    return $result;
}

// Delete function
function deleteUser($id)
{
    global $conn;
    $sql = "DELETE FROM users WHERE id=$id";
    $result = mysqli_query($conn, $sql);
    return $result;
}

if (isset($_POST['create'])) {
    createUser($_POST['user'], $_POST['email'], $_POST['password']);
}
if (isset($_POST['read'])) {
    $result = readUsers();
    if (mysqli_num_rows($result) > 0) {
        echo "<table>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>";
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>
                    <td>" . $row["id"] . "</td>
                    <td>" . $row["user"] . "</td>
                    <td>" . $row["email"] . "</td>
                    <td>" . $row["role"] . "</td>
                </tr>";
        }
        echo "</table>";
    } else {
        echo "No records found.";
    }
}
if (isset($_POST['update'])) {
    updateUser($_POST['id'], $_POST['user'], $_POST['email'], $_POST['password']);
}
if (isset($_POST['delete'])) {
    deleteUser($_POST['id']);
}
