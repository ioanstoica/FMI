-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent de tip procedură care să utilizeze într-o singură comandă SQL 5 dintre tabelele definite. Tratați toate excepțiile care pot apărea, incluzând excepțiile NO_DATA_FOUND și TOO_MANY_ROWS. Apelați subprogramul astfel încât să evidențiați toate cazurile tratate.

-- Se da numele unei Actiuni, Emitentul unei obligatiuni, Key pentru o criptomoneda si Emitentul unui ETF. aflati id-urile lor, si aflati care are pretul mai mare in tabela de active.  

create or replace procedure most_expensive_investment(
    actiune char,
    obligatiune char,
    criptomoneda int,
    etf char
) is
    actiune_id int;
    obligatiune_id number;
    criptomoneda_id number;
    etf_id number;
    pret_actiune number;
    pret_obligatiune number;
    pret_criptomoneda number;
    pret_etf number;
begin
    select id_actiune into actiune_id from actiuni where companie = actiune;
    select id_obligatiune into obligatiune_id from obligatiuni where emitent = obligatiune;
    select id_criptomoneda into criptomoneda_id from criptomonede where Cheie = criptomoneda;
    select id_etf into etf_id from etfuri where emitent = etf;
    select pret into pret_actiune from active where id_activ = actiune_id;
    select pret into pret_obligatiune from active where id_activ = obligatiune_id;
    select pret into pret_criptomoneda from active where id_activ = criptomoneda_id;
    select pret into pret_etf from active where id_activ = etf_id;
    if pret_actiune > pret_obligatiune and pret_actiune > pret_criptomoneda and pret_actiune > pret_etf then
        dbms_output.put_line('Actiunea are pretul cel mai mare');
    elsif pret_obligatiune > pret_actiune and pret_obligatiune > pret_criptomoneda and pret_obligatiune > pret_etf then
        dbms_output.put_line('Obligatiunea are pretul cel mai mare');
    elsif pret_criptomoneda > pret_actiune and pret_criptomoneda > pret_obligatiune and pret_criptomoneda > pret_etf then
        dbms_output.put_line('Criptomoneda are pretul cel mai mare');
    elsif pret_etf > pret_actiune and pret_etf > pret_obligatiune and pret_etf > pret_criptomoneda then
        dbms_output.put_line('ETF-ul are pretul cel mai mare');
    else
        dbms_output.put_line('Exista mai multe active cu pretul cel mai mare');
    end if;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista active pentru cautarea facuta');
    when too_many_rows then
        dbms_output.put_line('Exista mai multe active cu numele dat');
end;
/

begin
    most_expensive_investment('Appdle', 'SUA', 345678, 'Fidelity');  
end;
/

begin
    most_expensive_investment('Apple', 'SUA', 345678, 'Fidelity');  
end;
/

update actiuni
set companie = 'Apple'
where id_actiune = 2;
