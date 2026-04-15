-- 1
    create trigger bef_ins_leon
        before insert
        on ANIMALES
        for each row
    begin
        if (NEW.tipo = 'León' and NEW.anhos > 20) then
            signal sqlstate '45000' set message_text = 'HAS METIDO UN LEON DEMASIADO VIEJO';
        end if;
    end;

INSERT INTO ANIMALES VALUES ('viejito','León',25,200,200,'El gran carnivoro','La grande')