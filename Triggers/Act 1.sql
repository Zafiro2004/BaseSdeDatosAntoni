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

-- 3 TRES SITUACIONES PARA ACTUALIZAR GANANCIAS
-- SE HACE UN SHOW DE UNA ATRACCIÓN
create trigger aft_ins_show after insert on ATRACCION_DIA for each row
    begin
        update ATRACCIONES a
        set a.ganancias = a.ganancias+NEW.ganancias
        where a.nombre = NEW.nombre_atraccion;
    end;

insert into ATRACCION_DIA values ('El gran felino',now(),100,10000);
-- SE QUITA UN SHOW (con un delete)
create trigger  aft_del_show after delete on ATRACCION_DIA for each row
    begin
        update ATRACCIONES a
        set a.ganancias=a.ganancias-OLD.ganancias
        where a.nombre = OLD.nombre_atraccion;
    end;

delete from ATRACCION_DIA where nombre_atraccion = 'El gran felino' and fecha=date(now());
-- SE MODIFICA GANANCIAS DE UN SHOW (con update)
create trigger aft_upd_show after update on ATRACCION_DIA for each row
    begin
        update ATRACCIONES a
        set a.ganancias=a.ganancias+(NEW.ganancias-OLD.ganancias)
        where a.nombre = OLD.nombre_atraccion;
    end;