-- 7.
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent care să utilizeze 2 tipuri diferite de cursoare studiate, unul dintre acestea fiind cursor parametrizat, dependent de celălalt cursor. Apelați subprogramul.

-- scrie un cursor parametrizat care returneaza cate tranzactii au un anumit volum si un alt cursor care returneaza volumul maxim al unei tranzactii. Apoi afiseaza tranzactiile cu volumul egal cu volumul maxim al unei tranzactii.

create or replace procedure volum_maxim as
  cursor c1(v_volum number) is
    select count(*) as nr_tranzactii
    from tranzactii
    where volum = v_volum;
  cursor c2 is
    select max(volum) as max_volum
    from tranzactii;
  v_max_volum number;
  v_nr_tranzactii number;
begin
    open c2;
    fetch c2 into v_max_volum;
    close c2;
    open c1(v_max_volum);
    fetch c1 into v_nr_tranzactii;
    close c1;
    dbms_output.put_line('Tranzactiile cu volumul egal cu volumul maxim al unei tranzactii sunt: ' || v_nr_tranzactii);
    end;
/

begin
  volum_maxim;
end;

/


