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

INSERT INTO ANIMALES VALUES ('viejito','León',25,200,200,'El gran carnivoro','La grande');

-- 2
create trigger after_ins_animal after insert on ANIMALES for each row
    begin
        -- PASO 1: AVERIGUAR ARTISTA CON MENOS ANIMALES
        declare nif_encontrado char(9);

        SELECT nif_artista into nif_encontrado
        from ANIMALES_ARTISTAS
        group by nif_artista
        order by count(*) limit 1;
        -- PASO 2: RELACIONAR EL ANIMAL NUEVO A ESE ARTISTA
        insert into ANIMALES_ARTISTAS values (NEW.nombre,nif_encontrado);
    end;

insert into ANIMALES values ('nuevito','León',10,200,200,'El gran carnivoro','La grande');

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

-- 6
create trigger bef_ins_artist before insert on ARTISTAS for each row
    begin
        declare existe_nif int;


        select count(*) into existe_nif
        from ARTISTAS where nif=NEW.nif_jefe;

        if(existe_nif = 0) then
            set NEW.nif_jefe = null;
        end if;
    end;
insert into ARTISTAS values ('87754321A','no tiene','jefe','55555555A');
