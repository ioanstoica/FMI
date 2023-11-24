// Folosind modul în care este aranjată stiva pe IA-32, găsiți un input pentru care veți avea afișat mesajul “Parola introdusă este corectă”, chiar dacă aceasta este complet diferită de string-ul “fmiSSI”.
//  Cum se numește aceasta vulnerabilitate/acest atac?

#include <iostream>
#include <string.h>
using namespace std;
int main()
{
    char pass[7] = "fmiSSI";
    char input[7];
    int passLen = strlen(pass);
    cout << "Introduceti parola: ";
    cin >> input;
    if (strncmp(input, pass, passLen) == 0)
    {
        cout << "Parola introdusa este corecta!\n";
    }
    else
    {
        cout << "Ati introdus o parola gresita :(\n";
    }
    return 0;
}

// solutie: 12345671234567