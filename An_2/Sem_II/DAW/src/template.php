<!DOCTYPE html>
<html>
<head>
    <title>Database Management</title>
</head>
<body>
    <form method="post">
        <select name="table">
            <option value="">-- Select an Option --</option>
            <option value="hotel">Hotel</option>
            <option value="rezervare">Rezervare</option>
            <option value="camera">Camera</option>
            <option value="cazare">Cazare</option>
        </select>
        <input type="submit" name="submit" value="Select"/>
    </form>

    <?php
    if (isset($_POST['table'])) {
        $table = $_POST['table'];
        echo "<h2>Working on: $table</h2>";
        // Generate forms
        echo "<h3>Insert Form</h3>";
        // You should customize your form fields according to the selected table
        echo "
        <form method='post' action='database.php?action=insert'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Insert'>
        </form>";

        echo "<h3>Update Form</h3>";
        echo "
        <form method='post' action='database.php?action=update'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Update'>
        </form>";

        echo "<h3>Delete Form</h3>";
        echo "
        <form method='post' action='database.php?action=delete'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Delete'>
        </form>";
    }
    ?>
</body>
</html>
