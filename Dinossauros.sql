CREATE DATABASE DINOSSAUROS;

----DINOSSAUROS;
create table regioes
(
	id serial primary key,
	nome varchar(70) not null
);

CREATE TABLE eras (
	id serial primary key,
	nome VARCHAR(50),
    ano_inicio INT,
    ano_fim INT
);

CREATE TABLE grupos (
	id serial primary key,
    nome VARCHAR(50) 
);

create table descobridores
(
	id serial primary key,
	nome varchar(80) not null
); 

CREATE TABLE dinossauros (
	id serial primary key,
    nome VARCHAR(50),
    toneladas INT,
    ano_descoberta INT,
    ano_inicio INT,
    ano_fim INT,
    fk_regiao int, 
    FOREIGN KEY (fk_regiao) REFERENCES regioes(id),
	fk_era int,
    FOREIGN KEY (fk_era) REFERENCES eras(id),
	fk_grupo int,
    FOREIGN KEY (fk_grupo) REFERENCES grupos(id),
	fk_descobridor int,
    FOREIGN KEY (fk_descobridor) REFERENCES descobridores(id)
);

select * from regioes;
select * from eras;
select * from grupos;
select * from descobridores;
select * from dinossauros;

--- INSERT
INSERT INTO Eras (nome, ano_inicio, ano_fim) VALUES 
('Triássico', 251000000, 200000000),
('Jurássico', 200000000, 145000000),
('Cretáceo', 145000000, 65000000);

INSERT INTO grupos (nome) VALUES 
('Anquilossauros'),
('Ceratopsídeos'),
('Estegossauros'), 
('Terápodes');

insert into descobridores (nome) values 
('Maryanska'), ('John Bell Hatcher'), ('Cinetistas Alemãs'), 
('Museu Americano de História Natural'), ('Othniel Charles Marsh'), ('Barnum Brown');

insert into regioes (nome) values 
('Mongólia'), ('Canadá'), ('Tanzânia'), 
('China'), ('America do Norte'), ('USA');

select * from dinossauros
INSERT INTO Dinossauros (nome, toneladas, ano_descoberta, ano_inicio, ano_fim, fk_regiao, fk_era,fk_grupo, fk_descobridor) VALUES
('Saichania', 'Anquilossauros', 4, 1977, 'Maryanska', 'Cretáceo', 'Mongólia'),
('Tricerátops', 'Ceratopsídeos', 6, 1887, 'John Bell Hatcher', 'Cretáceo', 'Canadá'),
('Kentrossauro', 'Estegossauros', 2, 1909, 'Cientistas Alemães', 'Jurássico', 'Tanzânia'),
('Pinacossauro', 'Anquilossauros', 6, 1999, 'Museu Americano de História Natural', 'Triássico', 'China'),
('Alossauro', 'Terápodes', 3, 1877, 'Othniel Charles Marsh', 'Jurássico', 'América do Norte'),
('Torossauro', 'Ceratopsídeos', 8, 1891, 'John Bell Hatcher', 'Cretáceo', 'USA'),	
('Anquilossaur', 'Anquilossauros', 8, 1906, 'Barnum Brown', 'Triássico', 'América do Norte');	

CREATE OR REPLACE FUNCTION valida_anos_dinossauro()
RETURNS TRIGGER AS $$
DECLARE
    era_inicio INT;
    era_fim INT;
BEGIN
    -- Busca o período da era informada
    SELECT ano_inicio, ano_fim INTO era_inicio, era_fim 
    FROM Era 
    WHERE nome = NEW.era;

    -- Verifica se os anos de início e fim são válidos
    IF NEW.ano_descoberta NOT BETWEEN era_inicio AND era_fim THEN
        RAISE EXCEPTION 'Os anos de descoberta não são válidos para a era informada';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER valida_anos_dinossauro_trigger
BEFORE INSERT OR UPDATE ON Dinossauros
FOR EACH ROW
EXECUTE FUNCTION valida_anos_dinossauro();


CREATE OR REPLACE FUNCTION valida_anos_e_era_dinossauro()
RETURNS TRIGGER AS $$
DECLARE
    era_inicio INT;
    era_fim INT;
BEGIN
    -- Busca o período da era informada
    SELECT ano_inicio, ano_fim INTO era_inicio, era_fim 
    FROM Era 
    WHERE nome = NEW.era;

    -- Verifica se os anos de descoberta são válidos para a era informada
    IF NEW.ano_descoberta < era_inicio OR NEW.ano_descoberta > era_fim THEN
        RAISE EXCEPTION 'Os anos de descoberta não são válidos para a era informada';
    END IF;

    -- Verifica se os anos de existência do dinossauro estão corretos conforme a era
    IF NEW.ano_descoberta < era_inicio OR NEW.ano_descoberta > era_fim THEN
        RAISE EXCEPTION 'Os anos de existência do dinossauro não condizem com a era informada';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER valida_anos_e_era_dinossauro_trigger
BEFORE INSERT OR UPDATE ON Dinossauros
FOR EACH ROW
EXECUTE FUNCTION valida_anos_e_era_dinossauro();



