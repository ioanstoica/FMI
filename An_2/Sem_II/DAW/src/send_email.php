<?php

use PHPMailer\PHPMailer\PHPMailer;

require $_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php';

// Get the form data
$name = $_POST["name"];
$email = $_POST["email"];
$subject = $_POST["subject"];
$message = $_POST["message"];

$mail = new PHPMailer;
$mail->isSMTP();
$mail->Host = 'smtp.zoho.eu';
$mail->SMTPAuth = true;
$mail->Username = 'ioanstoica@zohomail.eu';
$mail->Password = 'CcCc246...';
$mail->SMTPSecure = 'tls';
$mail->Port = 587;

$mail->SMTPDebug = 0;

$mail->From = 'ioanstoica@zohomail.eu';
$mail->FromName = 'Ioan Stoica';
$mail->addAddress('ioanstoica89@gmail.com', $name);
$mail->addReplyTo('ioanstoica@zohomail.eu', 'Ioan Stoica');

$mail->isHTML(false);
$mail->Subject = $subject;
$mail->Body    = $message;
$mail->AltBody = 'Email body in plain text';


if (!$mail->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $mail->ErrorInfo;
} else {
    echo 'Message has been sent';
}

echo '<br><br><a href="/index.php">Back</a>';
