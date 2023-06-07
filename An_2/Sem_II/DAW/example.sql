require_once 'database.php';

// Insert a new hotel
$hotelData = ['DENUMIRE' => 'Hotel Test', 'ZONA' => 'Zona 1', 'JUDET' => 'Judet Test', 'LOCALITATE' => 'Localitate Test', 'NUMAR_STELE' => 4];
$hotelId = insert('HOTEL', $hotelData);

// Update the hotel
$hotelData = ['DENUMIRE' => 'Hotel Test Updated', 'ZONA' => 'Zona 2'];
update('HOTEL', $hotelData, $hotelId);

// Delete the hotel
delete('HOTEL', $hotelId);
