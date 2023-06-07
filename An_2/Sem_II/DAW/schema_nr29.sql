rezervare(id_rezervare,data_sosire,data_plecare,persoana_contact,telefon);
hotel(id_hotel,denumire,zona,judet,localitate,numar_stele);
camera(id_camera,numar,etaj,observatii,id_hotel,tarif_pe_noapte);
cazare(id_cazare,data_sosire,data_plecare,id_rezervare,id_camera);	

user(id_user, email, parola);